import { useState, useEffect, useRef } from 'react';

// Full-screen cycle-count overlay. Shows one part at a time. Enter saves the
// counted quantity and advances; Esc saves progress and exits. Opened with Cmd+Shift+C.
export default function CycleCountModal({ parts, index, onSet, onAdvance, onExit }) {
  const part = parts[index];
  const [value, setValue] = useState(part ? String(part.quantity) : '0');
  const inputRef = useRef(null);

  useEffect(() => {
    setValue(part ? String(part.quantity) : '0');
    inputRef.current?.focus();
    inputRef.current?.select();
  }, [index, part]);

  if (!part) return null;

  const commit = () => {
    const qty = Math.max(0, parseInt(value, 10) || 0);
    onSet(part.id, qty);
    onAdvance();
  };

  const onKeyDown = (e) => {
    if (e.key === 'Enter') { e.preventDefault(); commit(); }
    else if (e.key === 'Escape') { e.preventDefault(); onExit(); }
  };

  return (
    <div className="cycle-overlay" onKeyDown={onKeyDown}>
      <div className="cycle-card">
        <span className="cycle-progress">{index + 1} / {parts.length}</span>
        <h2 className="cycle-name">{part.name}</h2>
        {part.sku && <span className="cycle-sku">{part.sku}</span>}
        <span className="cycle-current">On record: {part.quantity}</span>
        <input
          ref={inputRef}
          type="number"
          inputMode="numeric"
          className="cycle-input"
          value={value}
          onChange={e => setValue(e.target.value)}
          autoFocus
        />
        <div className="cycle-actions">
          <button className="btn btn-secondary" onClick={onExit}>Done (Esc)</button>
          <button className="btn btn-primary" onClick={commit}>Save + Next (Enter)</button>
        </div>
      </div>
    </div>
  );
}
