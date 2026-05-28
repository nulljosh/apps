const COL_LABELS = {
  name: 'Name', sku: 'SKU', category: 'Cat', quantity: 'Qty',
  minThreshold: 'Min', cost: 'Cost', supplier: 'Supplier',
};

function SortIcon({ active, dir }) {
  if (!active) return <span className="sort-icon inactive">↕</span>;
  return <span className="sort-icon active">{dir === 'asc' ? '↑' : '↓'}</span>;
}

export default function PartList({ parts, onEdit, onDelete, onAdjustQty, sortKey, sortDir, onSort }) {
  if (!parts.length) return <p className="empty-hint">No parts match. Add one above.</p>;

  return (
    <div className="part-list glass-card">
      <div className="part-table-wrap">
        <table className="part-table">
          <thead>
            <tr>
              {Object.entries(COL_LABELS).map(([k, label]) => (
                <th key={k} onClick={() => onSort(k)} className="sortable-th">
                  {label} <SortIcon active={sortKey === k} dir={sortDir} />
                </th>
              ))}
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {parts.map(p => {
              const low = p.quantity <= p.minThreshold;
              const critical = p.quantity === 0;
              return (
                <tr key={p.id} className={critical ? 'row-critical' : low ? 'row-low' : ''}>
                  <td className="part-name-cell">
                    <span className="part-name">{p.name}</span>
                    {critical && <span className="badge badge-critical">OUT</span>}
                    {!critical && low && <span className="badge badge-low">LOW</span>}
                  </td>
                  <td className="mono">{p.sku}</td>
                  <td>{p.category}</td>
                  <td>
                    <div className="qty-controls">
                      <button className="qty-btn" onClick={() => onAdjustQty(p.id, -1)}>−</button>
                      <span className={`qty-val ${critical ? 'qty-critical' : low ? 'qty-low' : ''}`}>{p.quantity}</span>
                      <button className="qty-btn" onClick={() => onAdjustQty(p.id, 1)}>+</button>
                    </div>
                  </td>
                  <td>{p.minThreshold}</td>
                  <td>{p.cost > 0 ? `$${p.cost.toFixed(2)}` : '—'}</td>
                  <td>{p.supplier || '—'}</td>
                  <td>
                    <div className="row-actions">
                      <button className="btn-icon" title="Edit" onClick={() => onEdit(p)}>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                      </button>
                      <button className="btn-icon btn-danger" title="Delete" onClick={() => onDelete(p.id)}>
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                          <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 011-1h4a1 1 0 011 1v2"/>
                        </svg>
                      </button>
                    </div>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
