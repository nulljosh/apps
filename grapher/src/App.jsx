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
      background: '#0a0a0f',
      display: 'flex',
      flexDirection: 'column',
      fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
      color: '#f5f5f7',
      overflow: 'hidden',
    }}>
      {/* header */}
      <div style={{
        padding: '14px 20px 12px',
        borderBottom: '1px solid rgba(255,255,255,0.07)',
        background: 'rgba(10,10,15,0.8)',
        backdropFilter: 'blur(20px)',
        WebkitBackdropFilter: 'blur(20px)',
        zIndex: 10,
        display: 'flex',
        alignItems: 'center',
        gap: 10,
      }}>
        <img src="/icon.svg" width={24} height={24} alt="" style={{ borderRadius: 6 }} />
        <span style={{ fontSize: 16, fontWeight: 600, letterSpacing: '-0.01em' }}>Grapher</span>
        <span style={{
          marginLeft: 'auto', fontSize: 11,
          color: 'rgba(255,255,255,0.3)',
          fontFamily: '"SF Mono", "Menlo", monospace',
        }}>scroll to zoom · drag to pan</span>
      </div>

      {/* main */}
      <div style={{
        flex: 1,
        display: 'grid',
        gridTemplateColumns: 'minmax(0,1fr) 300px',
        overflow: 'hidden',
      }}>
        {/* graph */}
        <div style={{ position: 'relative', overflow: 'hidden' }}>
          <Graph equations={equations} />
        </div>

        {/* sidebar */}
        <div style={{
          padding: 16,
          borderLeft: '1px solid rgba(255,255,255,0.07)',
          background: 'rgba(255,255,255,0.02)',
          overflowY: 'auto',
        }}>
          <EquationList
            equations={equations}
            onChange={handleChange}
            onRemove={handleRemove}
            onAdd={handleAdd}
          />

          <div style={{
            marginTop: 12,
            background: 'rgba(255,255,255,0.04)',
            border: '1px solid rgba(255,255,255,0.08)',
            borderRadius: 12,
            padding: '12px 14px',
          }}>
            <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: '0.08em', textTransform: 'uppercase', color: 'rgba(255,255,255,0.3)', marginBottom: 8 }}>
              Quick examples
            </div>
            {['x^2', 'sin(x)', 'cos(x)', '2*x+1', 'sqrt(abs(x))', 'tan(x)', '1/x', 'x^3-x'].map((ex) => (
              <button
                key={ex}
                onClick={() => {
                  const id = nextId++;
                  setEquations((prev) => [...prev, makeEq(id, ex)]);
                }}
                style={{
                  display: 'inline-block', margin: '3px 4px 3px 0',
                  background: 'rgba(255,255,255,0.07)',
                  border: '1px solid rgba(255,255,255,0.10)',
                  borderRadius: 8, padding: '4px 9px',
                  color: 'rgba(255,255,255,0.65)',
                  fontSize: 12,
                  fontFamily: '"SF Mono", "Menlo", monospace',
                  cursor: 'pointer',
                  transition: 'background 0.1s',
                }}
                onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(255,255,255,0.12)'}
                onMouseLeave={(e) => e.currentTarget.style.background = 'rgba(255,255,255,0.07)'}
              >{ex}</button>
            ))}
          </div>
        </div>
      </div>

      {/* mobile bottom sheet */}
      <style>{`
        @media (max-width: 640px) {
          .graph-layout {
            grid-template-columns: 1fr !important;
            grid-template-rows: 1fr auto !important;
          }
          .sidebar {
            border-left: none !important;
            border-top: 1px solid rgba(255,255,255,0.07) !important;
            max-height: 45dvh;
          }
        }
      `}</style>
    </div>
  );
}
