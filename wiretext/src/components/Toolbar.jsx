import { useState } from 'react';
import './Toolbar.css';
import { PRESETS, CATEGORIES } from '../lib/presets.js';

export default function Toolbar({ selectedPreset, onSelectPreset }) {
  const [search, setSearch] = useState('');

  const query = search.trim().toLowerCase();
  const filtered = query
    ? PRESETS.filter(p => p.label.toLowerCase().includes(query))
    : null;

  return (
    <aside className="toolbar">
      <div className="toolbar-search">
        <input
          className="toolbar-search-input"
          type="text"
          placeholder="Search..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          aria-label="Search components"
        />
        {search && (
          <button
            className="toolbar-search-clear"
            onClick={() => setSearch('')}
            aria-label="Clear search"
          >
            ×
          </button>
        )}
      </div>
      <div className="toolbar-body">
        {filtered ? (
          filtered.length > 0 ? (
            <section className="toolbar-section">
              {filtered.map(preset => (
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
          ) : (
            <div className="toolbar-no-results">No results</div>
          )
        ) : (
          CATEGORIES.map(category => (
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
          ))
        )}
      </div>
    </aside>
  );
}
