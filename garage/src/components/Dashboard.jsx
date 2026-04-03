import { CATEGORIES } from '../lib/storage';

export default function Dashboard({ parts, lowStockParts, onViewInventory, onEditPart }) {
  const totalParts = parts.length;
  const totalUnits = parts.reduce((s, p) => s + p.quantity, 0);
  const totalValue = parts.reduce((s, p) => s + p.quantity * p.cost, 0);

  const categoryBreakdown = CATEGORIES.map(cat => {
    const catParts = parts.filter(p => p.category === cat);
    return {
      name: cat,
      count: catParts.length,
      units: catParts.reduce((s, p) => s + p.quantity, 0),
    };
  }).filter(c => c.count > 0);

  return (
    <div className="dashboard">
      <div className="stats-row animate__animated animate__fadeInUp">
        <div className="stat-card glass-card">
          <span className="stat-label">Total SKUs</span>
          <span className="stat-value">{totalParts}</span>
        </div>
        <div className="stat-card glass-card">
          <span className="stat-label">Total Units</span>
          <span className="stat-value">{totalUnits.toLocaleString()}</span>
        </div>
        <div className="stat-card glass-card">
          <span className="stat-label">Inventory Value</span>
          <span className="stat-value">${totalValue.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
        </div>
        <div className={`stat-card glass-card ${lowStockParts.length > 0 ? 'alert' : ''}`}>
          <span className="stat-label">Low Stock Alerts</span>
          <span className="stat-value">{lowStockParts.length}</span>
        </div>
      </div>

      {lowStockParts.length > 0 && (
        <div className="alert-section animate__animated animate__fadeInUp" style={{ animationDelay: '0.1s' }}>
          <h2 className="section-title">Low Stock Alerts</h2>
          <div className="alert-list glass-card">
            {lowStockParts.map(p => (
              <div key={p.id} className="alert-row" onClick={() => onEditPart(p)}>
                <div className="alert-info">
                  <span className="alert-name">{p.name}</span>
                  <span className="alert-sku">{p.sku}</span>
                </div>
                <div className="alert-qty">
                  <span className="qty-current">{p.quantity}</span>
                  <span className="qty-sep">/</span>
                  <span className="qty-min">{p.minThreshold}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {categoryBreakdown.length > 0 && (
        <div className="category-section animate__animated animate__fadeInUp" style={{ animationDelay: '0.2s' }}>
          <h2 className="section-title">Categories</h2>
          <div className="category-grid">
            {categoryBreakdown.map(cat => (
              <div key={cat.name} className="category-card glass-card" onClick={onViewInventory}>
                <span className="category-name">{cat.name}</span>
                <span className="category-count">{cat.count} SKUs</span>
                <span className="category-units">{cat.units} units</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {totalParts === 0 && (
        <div className="empty-state animate__animated animate__fadeIn">
          <h2>No inventory yet</h2>
          <p>Add your first part to get started tracking stock.</p>
          <button className="btn btn-primary" onClick={onViewInventory}>
            Go to Inventory
          </button>
        </div>
      )}
    </div>
  );
}
