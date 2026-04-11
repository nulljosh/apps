import './Toolbar.css';
import { PRESETS, CATEGORIES } from '../lib/presets.js';

export default function Toolbar({ selectedPreset, onSelectPreset }) {
  return (
    <aside className="toolbar">
      <div className="toolbar-header">
        <span className="toolbar-label">Components</span>
      </div>
      <div className="toolbar-body">
        {CATEGORIES.map(category => (
          <section key={category} className="toolbar-section">
            <div className="toolbar-category">{category}</div>
            {PRESETS.filter(p => p.category === category).map(preset => (
              <button
                key={preset.id}
                className={`toolbar-item${selectedPreset?.id === preset.id ? ' toolbar-item--active' : ''}`}
                onClick={() => onSelectPreset(preset)}
                title={`${preset.template.join('\n')}`}
              >
                <span className="toolbar-item-preview">{preset.template[0].slice(0, 12)}</span>
                <span className="toolbar-item-label">{preset.label}</span>
              </button>
            ))}
          </section>
        ))}
      </div>
    </aside>
  );
}
