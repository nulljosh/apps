export default function PartList({ parts, onEdit, onDelete, onAdjustQty }) {
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
        <span className="col-name">Part</span>
        <span className="col-sku">SKU</span>
        <span className="col-category">Category</span>
        <span className="col-supplier">Supplier</span>
        <span className="col-qty">Qty</span>
        <span className="col-cost">Cost</span>
        <span className="col-actions">Actions</span>
      </div>

      {parts.map((p, i) => (
        <div
          key={p.id}
          className={`part-row glass-card animate__animated animate__fadeInUp ${p.quantity <= p.minThreshold ? 'low-stock' : ''}`}
          style={{ animationDelay: `${Math.min(i * 0.03, 0.3)}s` }}
        >
          <span className="col-name">
            <span className="part-name">{p.name}</span>
          </span>
          <span className="col-sku mono">{p.sku}</span>
          <span className="col-category">
            <span className="category-badge">{p.category}</span>
          </span>
          <span className="col-supplier">{p.supplier}</span>
          <span className="col-qty">
            <div className="qty-controls">
              <button className="qty-btn" onClick={() => onAdjustQty(p.id, -1)}>-</button>
              <span className={`qty-value ${p.quantity <= p.minThreshold ? 'qty-low' : ''}`}>
                {p.quantity}
              </span>
              <button className="qty-btn" onClick={() => onAdjustQty(p.id, 1)}>+</button>
            </div>
          </span>
          <span className="col-cost">${p.cost.toFixed(2)}</span>
          <span className="col-actions">
            <button className="btn-icon" onClick={() => onEdit(p)} title="Edit">
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M10.5 1.5L12.5 3.5L4.5 11.5L1.5 12.5L2.5 9.5Z" stroke="currentColor" strokeWidth="1.2" strokeLinejoin="round"/>
              </svg>
            </button>
            <button className="btn-icon btn-danger" onClick={() => onDelete(p.id)} title="Delete">
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <line x1="3" y1="3" x2="11" y2="11" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                <line x1="11" y1="3" x2="3" y2="11" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
              </svg>
            </button>
          </span>
        </div>
      ))}
    </div>
  );
}
