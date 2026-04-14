const COLUMNS = [
  { key: 'name', label: 'Part', className: 'col-name' },
  { key: 'sku', label: 'SKU', className: 'col-sku' },
  { key: 'category', label: 'Category', className: 'col-category' },
  { key: 'supplier', label: 'Supplier', className: 'col-supplier' },
  { key: 'quantity', label: 'Qty', className: 'col-qty' },
  { key: 'cost', label: 'Unit Cost', className: 'col-cost' },
  { key: null, label: 'Total', className: 'col-total' },
  { key: null, label: '', className: 'col-actions' },
];

export default function PartList({ parts, onEdit, onDelete, onAdjustQty, sortKey, sortDir, onSort }) {
  if (parts.length === 0) {
    return (
      <div className="empty-state animate__animated animate__fadeIn">
        <p>No parts match your search.</p>
      </div>
    );
  }

  return (
    <div className="part-list">
      <div className="part-list-header">
        {COLUMNS.map(col => (
          <span
            key={col.label || 'actions'}
            className={`${col.className} ${col.key ? 'sortable' : ''} ${sortKey === col.key ? 'sorted' : ''}`}
            onClick={() => col.key && onSort(col.key)}
          >
            {col.label}
            {sortKey === col.key && (
              <span className="sort-arrow">{sortDir === 'asc' ? ' \u2191' : ' \u2193'}</span>
            )}
          </span>
        ))}
      </div>

      {parts.map((p, i) => (
        <div
          key={p.id}
          className={`part-row glass-card animate__animated animate__fadeInUp ${p.quantity <= p.minThreshold ? 'low-stock' : ''}`}
          style={{ animationDelay: `${Math.min(i * 0.02, 0.2)}s` }}
        >
          <span className="col-name" data-label="Part">
            <span className="part-name">{p.name}</span>
          </span>
          <span className="col-sku mono" data-label="SKU">{p.sku}</span>
          <span className="col-category" data-label="Category">
            <span className="category-badge">{p.category}</span>
          </span>
          <span className="col-supplier" data-label="Supplier">{p.supplier}</span>
          <span className="col-qty" data-label="Qty">
            <div className="qty-controls">
              <button className="qty-btn" onClick={() => onAdjustQty(p.id, -1)} aria-label="Decrease quantity">-</button>
              <span className={`qty-value ${p.quantity <= p.minThreshold ? 'qty-low' : ''}`}>
                {p.quantity}
              </span>
              <button className="qty-btn" onClick={() => onAdjustQty(p.id, 1)} aria-label="Increase quantity">+</button>
            </div>
          </span>
          <span className="col-cost" data-label="Cost">${p.cost.toFixed(2)}</span>
          <span className="col-total" data-label="Total">
            <span className="total-value">${(Math.round(p.quantity * p.cost * 100) / 100).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
          </span>
          <span className="col-actions">
            <button className="btn-icon" onClick={() => onEdit(p)} title="Edit" aria-label="Edit part">
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M10.5 1.5L12.5 3.5L4.5 11.5L1.5 12.5L2.5 9.5Z" stroke="currentColor" strokeWidth="1.2" strokeLinejoin="round"/>
              </svg>
            </button>
            <button className="btn-icon btn-danger" onClick={() => onDelete(p.id)} title="Delete" aria-label="Delete part">
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <line x1="3" y1="3" x2="11" y2="11" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                <line x1="11" y1="3" x2="3" y2="11" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
              </svg>
            </button>
          </span>
        </div>
      ))}

      <div className="part-list-footer glass-card">
        <span>{parts.length} parts</span>
        <span>{parts.reduce((s, p) => s + p.quantity, 0).toLocaleString()} total units</span>
        <span className="footer-total">
          Total value: ${parts.reduce((s, p) => s + Math.round(p.quantity * p.cost * 100) / 100, 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
        </span>
      </div>
    </div>
  );
}
