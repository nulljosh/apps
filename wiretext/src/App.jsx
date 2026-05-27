import { useReducer, useCallback, useState, useEffect } from 'react';
import './App.css';
import Toolbar from './components/Toolbar.jsx';
import Canvas from './components/Canvas.jsx';
import Inspector from './components/Inspector.jsx';
import { createState, undo, redo, pushHistory, stampComponent, gridToText } from './lib/engine.js';

function reducer(state, action) {
  switch (action.type) {
    case 'SELECT_PRESET':
      return { ...state, selectedPreset: action.preset };

    case 'PLACE_COMPONENT': {
      const { preset, col, row } = action;
      const withHistory = pushHistory(state);
      return {
        ...withHistory,
        grid: stampComponent(withHistory.grid, preset.template, col, row),
        selectedPreset: null,
      };
    }

    case 'SET_CURSOR':
      return { ...state, cursor: { col: action.col, row: action.row } };

    case 'UNDO':
      return undo(state);

    case 'REDO':
      return redo(state);

    case 'CLEAR': {
      const withHistory = pushHistory(state);
      return { ...withHistory, grid: createState(withHistory.cols, withHistory.rows).grid };
    }

    case 'SET_GRID': {
      const withHistory = pushHistory(state);
      return { ...withHistory, grid: action.grid };
    }

    default:
      return state;
  }
}

export default function App() {
  const [state, dispatch] = useReducer(reducer, undefined, () => createState());
  const [inspectorOpen, setInspectorOpen] = useState(false);
  const [darkMode, setDarkMode] = useState(() => {
    const saved = localStorage.getItem('wiretext-theme');
    return saved === 'dark';
  });

  useEffect(() => {
    if (darkMode) {
      document.documentElement.setAttribute('data-theme', 'dark');
    } else {
      document.documentElement.removeAttribute('data-theme');
    }
    localStorage.setItem('wiretext-theme', darkMode ? 'dark' : 'light');
  }, [darkMode]);

  const handleSelectPreset = useCallback((preset) => {
    dispatch({ type: 'SELECT_PRESET', preset });
  }, []);

  const handlePlaceComponent = useCallback((preset, col, row) => {
    dispatch({ type: 'PLACE_COMPONENT', preset, col, row });
  }, []);

  const handleCursorMove = useCallback((col, row) => {
    dispatch({ type: 'SET_CURSOR', col, row });
  }, []);

  const handleUndo = useCallback(() => dispatch({ type: 'UNDO' }), []);
  const handleRedo = useCallback(() => dispatch({ type: 'REDO' }), []);
  const handleClear = useCallback(() => dispatch({ type: 'CLEAR' }), []);

  const handleExport = useCallback(() => {
    const text = gridToText(state.grid);
    const blob = new Blob([text], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'wireframe.txt';
    a.click();
    URL.revokeObjectURL(url);
  }, [state.grid]);

  const handleExportPng = useCallback(() => {
    const FONT_SIZE = 14;
    const LINE_HEIGHT = 20;
    const FONT_FAMILY = "'Berkeley Mono', 'JetBrains Mono', 'Fira Code', ui-monospace, monospace";

    // Measure char width using same approach as Canvas.jsx
    const measureCanvas = document.createElement('canvas');
    const mctx = measureCanvas.getContext('2d');
    mctx.font = `${FONT_SIZE}px ${FONT_FAMILY}`;
    const charW = mctx.measureText('M').width;

    const cols = state.cols;
    const rows = state.rows;
    const width = Math.ceil(cols * charW);
    const height = rows * LINE_HEIGHT;

    const offscreen = document.createElement('canvas');
    offscreen.width = width;
    offscreen.height = height;
    const ctx = offscreen.getContext('2d');

    // White background
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, width, height);

    // Draw characters — black on white, monospace
    ctx.font = `${FONT_SIZE}px ${FONT_FAMILY}`;
    ctx.fillStyle = '#000000';
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const ch = state.grid[r][c];
        if (ch !== ' ') {
          ctx.fillText(ch, c * charW, r * LINE_HEIGHT + FONT_SIZE);
        }
      }
    }

    const dataUrl = offscreen.toDataURL('image/png');
    const a = document.createElement('a');
    a.href = dataUrl;
    a.download = 'wireframe.png';
    a.click();
  }, [state.grid, state.cols, state.rows]);

  const handleCopy = useCallback(() => {
    const text = gridToText(state.grid);
    navigator.clipboard.writeText(text).catch(() => {});
  }, [state.grid]);

  return (
    <div className="app">
      <header className="app-header">
        <span className="app-title">wiretext</span>
        <div className="app-header-actions">
          <button className="btn" onClick={handleUndo} title="Undo (Ctrl+Z)">Undo</button>
          <button className="btn" onClick={handleRedo} title="Redo (Ctrl+Y)">Redo</button>
          <button className="btn" onClick={handleClear}>Clear</button>
          <button className="btn" onClick={handleCopy}>Copy</button>
          <button className="btn btn-primary" onClick={handleExport}>Export .txt</button>
          <button className="btn btn-primary" onClick={handleExportPng}>Export PNG</button>
          <button
            className="btn btn-icon-round"
            onClick={() => setDarkMode(d => !d)}
            title="Toggle dark mode"
          >
            {darkMode ? (
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <circle cx="8" cy="8" r="3.5" stroke="currentColor" strokeWidth="1.5"/>
                <line x1="8" y1="0.5" x2="8" y2="2.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="8" y1="13.5" x2="8" y2="15.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="0.5" y1="8" x2="2.5" y2="8" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="13.5" y1="8" x2="15.5" y2="8" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="2.55" y1="2.55" x2="3.96" y2="3.96" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="12.04" y1="12.04" x2="13.45" y2="13.45" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="2.55" y1="13.45" x2="3.96" y2="12.04" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                <line x1="12.04" y1="3.96" x2="13.45" y2="2.55" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
              </svg>
            ) : (
              <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                <path d="M13.5 9.5A6 6 0 0 1 6.5 2.5a6 6 0 1 0 7 7z" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            )}
          </button>
        </div>
      </header>

      <Toolbar
        selectedPreset={state.selectedPreset}
        onSelectPreset={handleSelectPreset}
      />

      <Canvas
        grid={state.grid}
        cols={state.cols}
        rows={state.rows}
        cursor={state.cursor}
        selectedPreset={state.selectedPreset}
        onPlaceComponent={handlePlaceComponent}
        onCursorMove={handleCursorMove}
        onUndo={handleUndo}
        onRedo={handleRedo}
      />

      <Inspector
        cursor={state.cursor}
        cols={state.cols}
        rows={state.rows}
        selectedPreset={state.selectedPreset}
        historyLength={state.history.length}
        futureLength={state.future.length}
        isOpen={inspectorOpen}
        onClose={() => setInspectorOpen(false)}
      />

      <button
        className="inspector-toggle"
        onClick={() => setInspectorOpen(o => !o)}
        title="Toggle inspector"
      >
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
          <rect x="2" y="4" width="16" height="2" rx="1" fill="currentColor"/>
          <rect x="2" y="9" width="10" height="2" rx="1" fill="currentColor"/>
          <rect x="2" y="14" width="13" height="2" rx="1" fill="currentColor"/>
          <circle cx="16" cy="10" r="2.5" stroke="currentColor" strokeWidth="1.5"/>
          <line x1="17.77" y1="11.77" x2="19.5" y2="13.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
        </svg>
      </button>

      {inspectorOpen && (
        <div className="inspector-backdrop" onClick={() => setInspectorOpen(false)} />
      )}
    </div>
  );
}
