import './Inspector.css';

export default function Inspector({
  cursor,
  cols,
  rows,
  selectedPreset,
  historyLength,
  futureLength,
}) {
  return (
    <aside className="inspector">
      <div className="inspector-header">
        <span className="inspector-label">Inspector</span>
      </div>

      <section className="inspector-section">
        <div className="inspector-section-title">Cursor</div>
        <div className="inspector-row">
          <span className="inspector-key">Col</span>
          <span className="inspector-value">{cursor.col}</span>
        </div>
        <div className="inspector-row">
          <span className="inspector-key">Row</span>
          <span className="inspector-value">{cursor.row}</span>
        </div>
      </section>

      <section className="inspector-section">
        <div className="inspector-section-title">Canvas</div>
        <div className="inspector-row">
          <span className="inspector-key">Width</span>
          <span className="inspector-value">{cols} ch</span>
        </div>
        <div className="inspector-row">
          <span className="inspector-key">Height</span>
          <span className="inspector-value">{rows} ln</span>
        </div>
      </section>

      {selectedPreset && (
        <section className="inspector-section">
          <div className="inspector-section-title">Placing</div>
          <div className="inspector-row">
            <span className="inspector-key">Name</span>
            <span className="inspector-value inspector-value--green">{selectedPreset.label}</span>
          </div>
          <div className="inspector-row">
            <span className="inspector-key">Size</span>
            <span className="inspector-value">{selectedPreset.width}×{selectedPreset.height}</span>
          </div>
          <div className="inspector-preview">
            {selectedPreset.template.map((line, i) => (
              <div key={i} className="inspector-preview-line">{line}</div>
            ))}
          </div>
          <div className="inspector-hint">Click canvas to place</div>
        </section>
      )}

      <section className="inspector-section">
        <div className="inspector-section-title">History</div>
        <div className="inspector-row">
          <span className="inspector-key">Undo</span>
          <span className="inspector-value">{historyLength} steps</span>
        </div>
        <div className="inspector-row">
          <span className="inspector-key">Redo</span>
          <span className="inspector-value">{futureLength} steps</span>
        </div>
      </section>

      <section className="inspector-section">
        <div className="inspector-section-title">Shortcuts</div>
        <div className="inspector-row">
          <span className="inspector-key">Undo</span>
          <span className="inspector-value inspector-value--kbd">Ctrl+Z</span>
        </div>
        <div className="inspector-row">
          <span className="inspector-key">Redo</span>
          <span className="inspector-value inspector-value--kbd">Ctrl+Y</span>
        </div>
        <div className="inspector-row">
          <span className="inspector-key">Export</span>
          <span className="inspector-value inspector-value--muted">header btn</span>
        </div>
      </section>
    </aside>
  );
}
