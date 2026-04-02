import { useState, useCallback, useMemo } from 'react';
import {
  ReactFlow,
  Controls,
  useNodesState,
  useEdgesState,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';
import CenterSearchNode from './components/CenterSearchNode';
import ResultNode from './components/ResultNode';
import { evaluateMath } from './lib/mathEngine';

const nodeTypes = {
  centerSearch: CenterSearchNode,
  resultNode: ResultNode,
};

const RESULTS_PER_RING = 8;
const START_RADIUS = 300;
const RING_GAP = 220;

function buildLayout(results) {
  const nodes = [];
  const edges = [];

  for (let i = 0; i < results.length; i++) {
    const ring = Math.floor(i / RESULTS_PER_RING);
    const posInRing = i % RESULTS_PER_RING;
    const totalInRing = Math.min(RESULTS_PER_RING, results.length - ring * RESULTS_PER_RING);
    const angle = (2 * Math.PI * posInRing) / totalInRing - Math.PI / 2;
    const radius = START_RADIUS + ring * RING_GAP;

    const id = `result-${i}`;
    nodes.push({
      id,
      type: 'resultNode',
      position: { x: Math.cos(angle) * radius, y: Math.sin(angle) * radius },
      data: results[i],
      draggable: true,
    });
    edges.push({
      id: `edge-${i}`,
      source: 'center',
      target: id,
      style: { stroke: 'var(--edge-color)', strokeWidth: 1.5 },
      animated: false,
    });
  }

  return { nodes, edges };
}

export default function App() {
  const [nodes, setNodes, onNodesChange] = useNodesState([
    {
      id: 'center',
      type: 'centerSearch',
      position: { x: 0, y: 0 },
      data: { onSearch: () => {}, error: null, loading: false },
      draggable: true,
    },
  ]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSearch = useCallback(async (query) => {
    setLoading(true);
    setError(null);

    const mathResult = evaluateMath(query);
    let results = [];

    if (mathResult) {
      results.push({ title: mathResult, isMath: true });
    }

    try {
      const res = await fetch(`/api/search?q=${encodeURIComponent(query)}&limit=20`);
      if (res.ok) {
        const data = await res.json();
        if (data.results) {
          results = results.concat(data.results);
        }
      } else if (!mathResult) {
        setError('Search failed. Try again.');
      }
    } catch {
      if (!mathResult) {
        setError('Network error.');
      }
    }

    const { nodes: resultNodes, edges: resultEdges } = buildLayout(results);

    setNodes([
      {
        id: 'center',
        type: 'centerSearch',
        position: { x: 0, y: 0 },
        data: { onSearch: handleSearch, error: null, loading: false },
        draggable: true,
      },
      ...resultNodes,
    ]);
    setEdges(resultEdges);
    setLoading(false);
  }, [setNodes, setEdges]);

  const centerData = useMemo(() => ({
    onSearch: handleSearch,
    error,
    loading,
  }), [handleSearch, error, loading]);

  const currentNodes = useMemo(() => {
    return nodes.map((n) =>
      n.id === 'center' ? { ...n, data: centerData } : n
    );
  }, [nodes, centerData]);

  return (
    <div className="app">
      <ReactFlow
        nodes={currentNodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        nodeTypes={nodeTypes}
        fitView
        fitViewOptions={{ maxZoom: 1 }}
        minZoom={0.1}
        maxZoom={2}
        proOptions={{ hideAttribution: true }}
      >
        <Controls
          showInteractive={false}
          className="flow-controls"
        />
      </ReactFlow>
    </div>
  );
}
