import { useState, useCallback } from 'react';
import Graph from './components/Graph.jsx';
import EquationList from './components/EquationList.jsx';
import { evaluate } from './utils/evaluate.js';
import { colorAt } from './utils/colors.js';

let nextId = 3;

function makeEq(id, expr = '') {
  const { fn, error } = evaluate(expr);
  return { id, expr, fn, error, color: colorAt(id - 1) };
}

const INITIAL = [
  makeEq(1, 'x^2'),
  makeEq(2, 'sin(x)'),
];

export default function App() {
  const [equations, setEquations] = useState(INITIAL);

  const handleChange = useCallback((id, expr) => {
    setEquations((prev) =>
      prev.map((eq) => eq.id === id ? { ...eq, expr, ...evaluate(expr) } : eq)
    );
  }, []);

  const handleRemove = useCallback((id) => {
    setEquations((prev) => prev.filter((eq) => eq.id !== id));
  }, []);

  const handleAdd = useCallback(() => {
    const id = nextId++;
    setEquations((prev) => [...prev, makeEq(id, '')]);
  }, []);

  return (
    <div style={{
      height: '100dvh',
      background: 'var(--bg)',
      display: 'flex',
      flexDirection: 'column',
      fontFamily: 'var(--font)',
      color: 'var(--text)',
      overflow: 'hidden',
    }}>
      <div style={{
        padding: '14px 20px 12px',
        borderBottom: '1px solid var(--border)',
        background: 'var(--bg)',
        zIndex: 10,
        display: 'flex',
        alignItems: 'center',
        gap: 10,
      }}>
        <img src="/icon.svg" width={24} height={24} alt="" style={{ borderRadius: 6 }} />
        <span style={{ fontSize: 16, fontWeight: 600, letterSpacing: '-0.01em' }}>Grapher</span>
        <span className="nav-hint" style={{
          marginLeft: 'auto', fontSize: 11,
          color: 'var(--text-secondary)',
          fontFamily: '"SF Mono", "Menlo", monospace',
        }}>scroll to zoom · drag to pan</span>
      </div>

      <div className="main-layout" style={{
        flex: 1,
        display: 'flex',
        flexDirection: 'row',
        overflow: 'hidden',
      }}>
        <div className="graph-pane" style={{ position: 'relative', overflow: 'hidden', flex: 1 }}>
          <Graph equations={equations} />
        </div>

        <div className="sidebar-pane" style={{
          width: 300,
          padding: 16,
          borderLeft: '1px solid var(--border)',
          background: 'var(--bg2)',
          overflowY: 'auto',
          flexShrink: 0,
        }}>
          <EquationList
            equations={equations}
            onChange={handleChange}
            onRemove={handleRemove}
            onAdd={handleAdd}
          />

          <div style={{
            marginTop: 12,
            background: 'var(--bg)',
            border: '1px solid var(--border)',
            borderRadius: 12,
            padding: '12px 14px',
          }}>
            <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: '0.08em', textTransform: 'uppercase', color: 'var(--text-secondary)', marginBottom: 8 }}>
              Quick examples
            </div>
            {['x^2', 'sin(x)', 'cos(x)', '2*x+1', 'sqrt(abs(x))', 'tan(x)', '1/x', 'x^3-x'].map((ex) => (
              <button
                key={ex}
                className="example-btn"
                onClick={() => {
                  const id = nextId++;
                  setEquations((prev) => [...prev, makeEq(id, ex)]);
                }}
                style={{
                  display: 'inline-block', margin: '3px 4px 3px 0',
                  background: 'var(--bg2)',
                  border: '1px solid var(--border)',
                  borderRadius: 8, padding: '4px 9px',
                  color: 'var(--text-secondary)',
                  fontSize: 12,
                  fontFamily: '"SF Mono", "Menlo", monospace',
                  cursor: 'pointer',
                  transition: 'background 0.1s',
                }}
                onMouseEnter={(e) => { e.currentTarget.style.color = 'var(--accent)'; e.currentTarget.style.borderColor = 'var(--accent)'; }}
                onMouseLeave={(e) => { e.currentTarget.style.color = 'var(--text-secondary)'; e.currentTarget.style.borderColor = 'var(--border)'; }}
              >{ex}</button>
            ))}
          </div>
        </div>
      </div>

      <style>{`
        @media (max-width: 640px) {
          .nav-hint {
            display: none;
          }
          .main-layout {
            flex-direction: column !important;
          }
          .graph-pane {
            order: 1;
            flex: none !important;
            height: calc(100dvh - 53px - 200px);
            width: 100% !important;
          }
          .sidebar-pane {
            order: 2;
            width: 100% !important;
            flex: none !important;
            height: 200px;
            max-height: 200px;
            border-left: none !important;
            border-top: 1px solid var(--border) !important;
            overflow-y: auto;
            padding: 10px 12px !important;
          }
          .example-btn {
            min-height: 44px !important;
            min-width: 44px !important;
            padding: 8px 10px !important;
          }
        }
      `}</style>
    </div>
  );
}
