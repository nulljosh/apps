import { useReducer, useCallback } from 'react';
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
      />
    </div>
  );
}
