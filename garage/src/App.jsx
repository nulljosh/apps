import { useState, useEffect, useCallback } from 'react';
import { getParts, saveParts, addHistory, CATEGORIES } from './lib/storage';
import Logo from './components/Logo';
import Dashboard from './components/Dashboard';
import PartList from './components/PartList';
import PartForm from './components/PartForm';
import HistoryLog from './components/HistoryLog';

const VIEWS = ['Dashboard', 'Inventory', 'History'];

function exportCSV(parts) {
  const headers = ['Name', 'SKU', 'Category', 'Quantity', 'Min Threshold', 'Unit Cost', 'Supplier', 'Total Value'];
  const rows = parts.map(p => [
    `"${p.name}"`, p.sku, p.category, p.quantity, p.minThreshold,
    p.cost.toFixed(2), `"${p.supplier}"`, (p.quantity * p.cost).toFixed(2),
  ]);
  const csv = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
  const blob = new Blob([csv], { type: 'text/csv' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `garage-inventory-${new Date().toISOString().split('T')[0]}.csv`;
  a.click();
  URL.revokeObjectURL(url);
}

export default function App() {
  const [parts, setParts] = useState(getParts);
  const [view, setView] = useState('Dashboard');
  const [editingPart, setEditingPart] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('All');
  const [sortKey, setSortKey] = useState('name');
  const [sortDir, setSortDir] = useState('asc');
  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [toast, setToast] = useState(null);

  useEffect(() => {
    saveParts(parts);
  }, [parts]);

  // Keyboard shortcuts
  useEffect(() => {
    const handler = (e) => {
      // Cmd+K or Ctrl+K to focus search
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        setView('Inventory');
        setTimeout(() => document.querySelector('.search-input')?.focus(), 50);
      }
      // Escape to close form/modal
      if (e.key === 'Escape') {
        if (deleteConfirm) setDeleteConfirm(null);
        else if (showForm) { setShowForm(false); setEditingPart(null); }
      }
      // 1/2/3 for views
      if (e.altKey && e.key === '1') setView('Dashboard');
      if (e.altKey && e.key === '2') setView('Inventory');
      if (e.altKey && e.key === '3') setView('History');
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [deleteConfirm, showForm]);

  const showToast = useCallback((msg) => {
    setToast(msg);
    setTimeout(() => setToast(null), 2200);
  }, []);

  const handleSave = useCallback((part) => {
    setParts(prev => {
      const exists = prev.find(p => p.id === part.id);
      if (exists) {
        addHistory({
          action: 'updated',
          partName: part.name,
          sku: part.sku,
          details: `Qty: ${exists.quantity} -> ${part.quantity}`,
        });
        return prev.map(p => p.id === part.id ? part : p);
      }
      addHistory({
        action: 'added',
        partName: part.name,
        sku: part.sku,
        details: `Qty: ${part.quantity}`,
      });
      return [...prev, part];
    });
    setEditingPart(null);
    setShowForm(false);
    showToast(part ? 'Part saved' : 'Part added');
  }, [showToast]);

  const handleDelete = useCallback((id) => {
    setParts(prev => {
      const part = prev.find(p => p.id === id);
      if (part) {
        addHistory({
          action: 'removed',
          partName: part.name,
          sku: part.sku,
          details: `Had ${part.quantity} in stock`,
        });
      }
      return prev.filter(p => p.id !== id);
    });
    setDeleteConfirm(null);
    showToast('Part removed');
  }, [showToast]);

  const handleAdjustQty = useCallback((id, delta) => {
    setParts(prev => prev.map(p => {
      if (p.id !== id) return p;
      const newQty = Math.max(0, p.quantity + delta);
      addHistory({
        action: delta > 0 ? 'restocked' : 'used',
        partName: p.name,
        sku: p.sku,
        details: `Qty: ${p.quantity} -> ${newQty}`,
      });
      return { ...p, quantity: newQty };
    }));
  }, []);

  const handleSort = useCallback((key) => {
    setSortKey(prev => {
      if (prev === key) {
        setSortDir(d => d === 'asc' ? 'desc' : 'asc');
        return key;
      }
      setSortDir('asc');
      return key;
    });
  }, []);

  const lowStockParts = parts.filter(p => p.quantity <= p.minThreshold);

  const filteredParts = parts
    .filter(p => {
      const matchesSearch = !search ||
        p.name.toLowerCase().includes(search.toLowerCase()) ||
        p.sku.toLowerCase().includes(search.toLowerCase()) ||
        p.supplier.toLowerCase().includes(search.toLowerCase());
      const matchesCategory = categoryFilter === 'All' || p.category === categoryFilter;
      return matchesSearch && matchesCategory;
    })
    .sort((a, b) => {
      let av = a[sortKey];
      let bv = b[sortKey];
      if (typeof av === 'string') { av = av.toLowerCase(); bv = bv.toLowerCase(); }
      if (av < bv) return sortDir === 'asc' ? -1 : 1;
      if (av > bv) return sortDir === 'asc' ? 1 : -1;
      return 0;
    });

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-left">
          <Logo size={56} />
          <div className="header-text">
            <h1 className="app-title">Best Choice Garage Doors</h1>
            <span className="app-subtitle">Inventory Management</span>
          </div>
        </div>
        <nav className="nav-tabs">
          {VIEWS.map((v, i) => (
            <button
              key={v}
              className={`nav-tab ${view === v ? 'active' : ''}`}
              onClick={() => { setView(v); setShowForm(false); setEditingPart(null); }}
              title={`Alt+${i + 1}`}
            >
              {v}
            </button>
          ))}
        </nav>
      </header>

      <main className="app-main">
        {view === 'Dashboard' && (
          <Dashboard
            parts={parts}
            lowStockParts={lowStockParts}
            onViewInventory={() => setView('Inventory')}
            onEditPart={(p) => { setEditingPart(p); setShowForm(true); setView('Inventory'); }}
          />
        )}

        {view === 'Inventory' && (
          <>
            <div className="inventory-toolbar animate__animated animate__fadeIn">
              <div className="search-bar">
                <svg className="search-icon" width="16" height="16" viewBox="0 0 16 16" fill="none">
                  <circle cx="6.5" cy="6.5" r="5.5" stroke="currentColor" strokeWidth="1.5"/>
                  <line x1="10.5" y1="10.5" x2="15" y2="15" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
                </svg>
                <input
                  type="text"
                  placeholder="Search parts, SKUs, suppliers... (Cmd+K)"
                  value={search}
                  onChange={e => setSearch(e.target.value)}
                  className="search-input"
                />
              </div>
              <select
                value={categoryFilter}
                onChange={e => setCategoryFilter(e.target.value)}
                className="category-select"
              >
                <option value="All">All Categories</option>
                {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
              </select>
              <button
                className="btn btn-secondary"
                onClick={() => exportCSV(filteredParts)}
                title="Export filtered inventory as CSV"
              >
                Export CSV
              </button>
              <button
                className="btn btn-primary"
                onClick={() => { setEditingPart(null); setShowForm(true); }}
              >
                + Add Part
              </button>
            </div>

            {showForm && (
              <PartForm
                part={editingPart}
                onSave={handleSave}
                onCancel={() => { setShowForm(false); setEditingPart(null); }}
              />
            )}

            <PartList
              parts={filteredParts}
              onEdit={(p) => { setEditingPart(p); setShowForm(true); }}
              onDelete={(id) => setDeleteConfirm(id)}
              onAdjustQty={handleAdjustQty}
              sortKey={sortKey}
              sortDir={sortDir}
              onSort={handleSort}
            />
          </>
        )}

        {view === 'History' && <HistoryLog />}
      </main>

      {/* Delete confirmation modal */}
      {deleteConfirm && (
        <div className="modal-overlay" onClick={() => setDeleteConfirm(null)}>
          <div className="modal glass-card animate__animated animate__fadeInUp animate__faster" onClick={e => e.stopPropagation()}>
            <h3>Remove this part?</h3>
            <p>This will permanently delete it from inventory and cannot be undone.</p>
            <div className="modal-actions">
              <button className="btn btn-secondary" onClick={() => setDeleteConfirm(null)}>Cancel</button>
              <button className="btn btn-delete" onClick={() => handleDelete(deleteConfirm)}>Remove</button>
            </div>
          </div>
        </div>
      )}

      {/* Toast notification */}
      {toast && (
        <div className="toast animate__animated animate__fadeInUp animate__faster">{toast}</div>
      )}

      {/* Keyboard shortcuts footer */}
      <footer className="shortcuts-bar">
        <span className="shortcut-hint">Cmd+K Search</span>
        <span className="shortcut-hint">Alt+1/2/3 Navigate</span>
        <span className="shortcut-hint">Esc Close</span>
      </footer>
    </div>
  );
}
