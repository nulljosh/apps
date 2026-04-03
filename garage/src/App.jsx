import { useState, useEffect, useCallback } from 'react';
import { getParts, saveParts, addHistory, CATEGORIES } from './lib/storage';
import Dashboard from './components/Dashboard';
import PartList from './components/PartList';
import PartForm from './components/PartForm';
import HistoryLog from './components/HistoryLog';

const VIEWS = ['Dashboard', 'Inventory', 'History'];

export default function App() {
  const [parts, setParts] = useState(getParts);
  const [view, setView] = useState('Dashboard');
  const [editingPart, setEditingPart] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('All');

  useEffect(() => {
    saveParts(parts);
  }, [parts]);

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
  }, []);

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
  }, []);

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

  const lowStockParts = parts.filter(p => p.quantity <= p.minThreshold);

  const filteredParts = parts.filter(p => {
    const matchesSearch = !search ||
      p.name.toLowerCase().includes(search.toLowerCase()) ||
      p.sku.toLowerCase().includes(search.toLowerCase()) ||
      p.supplier.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = categoryFilter === 'All' || p.category === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-left">
          <h1 className="app-title">Garage Door Services</h1>
          <span className="app-subtitle">Inventory Management</span>
        </div>
        <nav className="nav-tabs">
          {VIEWS.map(v => (
            <button
              key={v}
              className={`nav-tab ${view === v ? 'active' : ''}`}
              onClick={() => { setView(v); setShowForm(false); setEditingPart(null); }}
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
                  placeholder="Search parts, SKUs, suppliers..."
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
              onDelete={handleDelete}
              onAdjustQty={handleAdjustQty}
            />
          </>
        )}

        {view === 'History' && <HistoryLog />}
      </main>
    </div>
  );
}
