import { useState, useEffect, useCallback } from 'react';
import { addHistory, getSettings, saveSettings, buildReorderMailto, CATEGORIES, JOB_STATUSES, parseJobsMarkdown } from './lib/storage';
import { useAuth } from './context/AuthContext';
import { fetchParts, savePart, deletePart, fetchJobs, saveJob, deleteJob, fetchLeads, deleteLead, subscribe } from './lib/db';
import CycleCountModal from './components/CycleCountModal';
import 'animate.css';
import Logo from './components/Logo';
import Login from './components/Login';
import PartList from './components/PartList';
import PartForm from './components/PartForm';
import JobList from './components/JobList';
import JobForm from './components/JobForm';
import LeadList from './components/LeadList';
import HistoryLog from './components/HistoryLog';
import Settings from './components/Settings';
import CustomerList from './components/CustomerList';

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

function plural(n, word) {
  return `${n} ${word}${n === 1 ? '' : 's'}`;
}

export default function App() {
  const { user, orgId, loading, signOut, isConfigured } = useAuth();
  const [parts, setParts] = useState([]);
  const [jobs, setJobs] = useState([]);
  const [leads, setLeads] = useState([]);
  const [editingPart, setEditingPart] = useState(null);
  const [editingJob, setEditingJob] = useState(null);
  const [showForm, setShowForm] = useState(false);
  const [showJobForm, setShowJobForm] = useState(false);
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('All');
  const [sortKey, setSortKey] = useState('name');
  const [sortDir, setSortDir] = useState('asc');
  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [jobDeleteConfirm, setJobDeleteConfirm] = useState(null);
  const [toast, setToast] = useState(null);
  const [settings, setSettings] = useState(getSettings);
  const [showSettings, setShowSettings] = useState(false);
  const [showInventory, setShowInventory] = useState(false);
  const [showImport, setShowImport] = useState(false);
  const [importText, setImportText] = useState('');
  const [cycleCount, setCycleCount] = useState(false);
  const [cycleIndex, setCycleIndex] = useState(0);

  // Load everything from Supabase once signed in, and stay live via realtime.
  useEffect(() => {
    if (!user) { setParts([]); setJobs([]); setLeads([]); return; }
    fetchParts().then(setParts);
    fetchJobs().then(setJobs);
    fetchLeads().then(setLeads);
    const unsubs = [
      subscribe('parts', () => fetchParts().then(setParts)),
      subscribe('jobs', () => fetchJobs().then(setJobs)),
      subscribe('leads', () => fetchLeads().then(setLeads)),
    ];
    return () => unsubs.forEach(u => u());
  }, [user]);

  useEffect(() => {
    if ('Notification' in window && Notification.permission === 'default') {
      Notification.requestPermission();
    }
  }, []);

  // Keyboard shortcuts
  useEffect(() => {
    const handler = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        document.querySelector('.search-input')?.focus();
      }
      if ((e.metaKey || e.ctrlKey) && e.shiftKey && (e.key === 'c' || e.key === 'C')) {
        e.preventDefault();
        if (parts.length) { setCycleIndex(0); setCycleCount(true); }
      }
      if (e.key === 'Escape') {
        if (deleteConfirm) setDeleteConfirm(null);
        else if (jobDeleteConfirm) setJobDeleteConfirm(null);
        else if (showForm) { setShowForm(false); setEditingPart(null); }
        else if (showJobForm) { setShowJobForm(false); setEditingJob(null); }
      }
    };
    window.addEventListener('keydown', handler);
    return () => window.removeEventListener('keydown', handler);
  }, [deleteConfirm, jobDeleteConfirm, showForm, showJobForm, parts.length]);

  const showToast = useCallback((msg) => {
    setToast(msg);
    setTimeout(() => setToast(null), 2200);
  }, []);

  // ---- Part handlers ----

  const handleSave = useCallback(async (part) => {
    const exists = parts.find(p => p.id === part.id);
    try {
      await savePart(orgId, part);
      addHistory({
        action: exists ? 'updated' : 'added',
        partName: part.name,
        sku: part.sku,
        details: exists ? `Qty: ${exists.quantity} -> ${part.quantity}` : `Qty: ${part.quantity}`,
      });
      setParts(prev => exists ? prev.map(p => p.id === part.id ? part : p) : [...prev, part]);
      showToast(exists ? 'Part saved' : 'Part added');
    } catch (e) {
      showToast(`Save failed: ${e.message}`);
    }
    setEditingPart(null);
    setShowForm(false);
  }, [parts, orgId, showToast]);

  const handleDelete = useCallback(async (id) => {
    const part = parts.find(p => p.id === id);
    try {
      await deletePart(id);
      if (part) {
        addHistory({
          action: 'removed',
          partName: part.name,
          sku: part.sku,
          details: `Had ${part.quantity} in stock`,
        });
      }
      setParts(prev => prev.filter(p => p.id !== id));
      showToast('Part removed');
    } catch (e) {
      showToast(`Delete failed: ${e.message}`);
    }
    setDeleteConfirm(null);
  }, [parts, showToast]);

  const handleAdjustQty = useCallback(async (id, delta) => {
    const p = parts.find(x => x.id === id);
    if (!p) return;
    const newQty = Math.max(0, p.quantity + delta);
    const updated = { ...p, quantity: newQty };
    try {
      await savePart(orgId, updated);
      addHistory({
        action: delta > 0 ? 'restocked' : 'used',
        partName: p.name,
        sku: p.sku,
        details: `Qty: ${p.quantity} -> ${newQty}`,
      });
      setParts(prev => prev.map(x => x.id === id ? updated : x));
      if (newQty <= p.minThreshold && p.quantity > p.minThreshold && settings.alertsEnabled) {
        showToast(`Low stock: ${p.name} (${newQty}/${p.minThreshold})`);
        if ('Notification' in window && Notification.permission === 'granted') {
          new Notification('Low Stock Alert', {
            body: `${p.name} is at ${newQty} units (min: ${p.minThreshold})`,
          });
        }
      }
    } catch (e) {
      showToast(`Update failed: ${e.message}`);
    }
  }, [parts, orgId, settings.alertsEnabled, showToast]);

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

  // ---- Job handlers ----

  const handleSaveJob = useCallback(async (job) => {
    const exists = jobs.find(j => j.id === job.id);
    try {
      await saveJob(orgId, job);
      setJobs(prev => exists ? prev.map(j => j.id === job.id ? job : j) : [job, ...prev]);
      showToast('Job saved');
    } catch (e) {
      showToast(`Save failed: ${e.message}`);
    }
    setEditingJob(null);
    setShowJobForm(false);
  }, [jobs, orgId, showToast]);

  const handleDeleteJob = useCallback(async (id) => {
    try {
      await deleteJob(id);
      setJobs(prev => prev.filter(j => j.id !== id));
      showToast('Job removed');
    } catch (e) {
      showToast(`Delete failed: ${e.message}`);
    }
    setJobDeleteConfirm(null);
  }, [showToast]);

  const handleAdvanceJob = useCallback(async (id) => {
    const j = jobs.find(x => x.id === id);
    if (!j) return;
    const idx = JOB_STATUSES.indexOf(j.status);
    if (idx < 0 || idx >= JOB_STATUSES.length - 1) return;
    const updated = { ...j, status: JOB_STATUSES[idx + 1] };
    try {
      await saveJob(orgId, updated);
      setJobs(prev => prev.map(x => x.id === id ? updated : x));
      showToast('Job advanced');
    } catch (e) {
      showToast(`Update failed: ${e.message}`);
    }
  }, [jobs, orgId, showToast]);

  const handleImportJobs = useCallback(async () => {
    const parsed = parseJobsMarkdown(importText);
    if (!parsed.length) { showToast('No jobs found in text'); return; }
    try {
      await Promise.all(parsed.map(j => saveJob(orgId, j)));
      setJobs(prev => [...parsed, ...prev]);
      setImportText('');
      setShowImport(false);
      showToast(`Imported ${parsed.length} job${parsed.length === 1 ? '' : 's'}`);
    } catch (e) {
      showToast(`Import failed: ${e.message}`);
    }
  }, [importText, orgId, showToast]);

  // Cycle count: set an exact counted quantity for one part by id.
  const handleCycleSet = useCallback(async (id, newQty) => {
    const p = parts.find(x => x.id === id);
    if (!p || p.quantity === newQty) return;
    const updated = { ...p, quantity: newQty };
    try {
      await savePart(orgId, updated);
      addHistory({ action: 'counted', partName: p.name, sku: p.sku, details: `Qty: ${p.quantity} -> ${newQty}` });
      setParts(prev => prev.map(x => x.id === id ? updated : x));
    } catch (e) {
      showToast(`Update failed: ${e.message}`);
    }
  }, [parts, orgId, showToast]);

  // ---- Lead handlers ----

  // Convert a website booking request into a job (prefilled form).
  const handleConvertLead = useCallback((lead) => {
    setEditingJob({
      customer: lead.name || '', phone: lead.phone || '', email: lead.email || '',
      service: lead.service || '', status: 'Scheduled', notes: lead.message || '',
      address: '', scheduledAt: '',
    });
    setShowJobForm(true);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  const handleDismissLead = useCallback(async (id) => {
    try {
      await deleteLead(id);
      setLeads(prev => prev.filter(l => l.id !== id));
      showToast('Lead dismissed');
    } catch (e) {
      showToast(`Failed: ${e.message}`);
    }
  }, [showToast]);

  // ---- Derived data ----

  const totalUnits = parts.reduce((s, p) => s + p.quantity, 0);
  const totalValue = parts.reduce((s, p) => s + Math.round(p.quantity * p.cost * 100) / 100, 0);
  const lowStockParts = parts.filter(p => p.quantity <= p.minThreshold);
  const openLeads = leads.length;
  const scheduledJobs = jobs.filter(j => j.status === 'Scheduled').length;

  // Intelligence derived data
  const outOfStock = parts.filter(p => p.quantity === 0).length;
  const lowStockValue = lowStockParts.reduce((s, p) => s + p.quantity * p.cost, 0);
  const categoryStats = CATEGORIES.map(cat => ({
    cat,
    value: parts.filter(p => p.category === cat).reduce((s, p) => s + p.quantity * p.cost, 0),
    count: parts.filter(p => p.category === cat).length,
  })).filter(c => c.count > 0).sort((a, b) => b.value - a.value);
  const maxCatValue = Math.max(...categoryStats.map(c => c.value), 1);
  const supplierMap = new Map();
  lowStockParts.forEach(p => {
    const key = p.supplier || 'Unknown Supplier';
    if (!supplierMap.has(key)) supplierMap.set(key, []);
    supplierMap.get(key).push(p);
  });
  const reorderGroups = [...supplierMap.entries()].map(([supplier, items]) => {
    const subject = encodeURIComponent(`Reorder Request — ${items.length} items`);
    const body = encodeURIComponent(items.map(p => `${p.name} (${p.sku}) — qty ${p.quantity}, min ${p.minThreshold}`).join('\n'));
    return { supplier, items, mailto: `mailto:${settings.alertEmail}?subject=${subject}&body=${body}` };
  });

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

  // ---- Auth gate ----

  if (isConfigured && loading) {
    return (
      <div className="login-screen">
        <div className="login-card glass-card"><p className="empty-hint">Loading…</p></div>
      </div>
    );
  }

  if (!isConfigured || !user) {
    return <Login />;
  }

  return (
    <div className="app">
      <header className="app-header">
        <div className="header-left">
          <Logo size={56} />
          <div className="header-text">
            <h1 className="app-title">Best Choice Garage Doors</h1>
            <span className="app-subtitle">Operations Dashboard</span>
          </div>
        </div>
        <div className="header-actions">
          <button
            className="btn btn-secondary settings-toggle"
            onClick={() => setShowSettings(s => !s)}
          >
            {showSettings ? 'Close Settings' : 'Settings'}
          </button>
          <button className="btn btn-secondary" onClick={signOut}>Sign out</button>
        </div>
      </header>

      <main className="app-main">
        {/* ---- Stats Row ---- */}
        <div className="stats-row animate__animated animate__fadeInUp">
          <div className="stat-card glass-card">
            <span className="stat-label">Total SKUs</span>
            <span className="stat-value">{parts.length}</span>
          </div>
          <div className="stat-card glass-card">
            <span className="stat-label">Total Units</span>
            <span className="stat-value">{totalUnits.toLocaleString()}</span>
          </div>
          <div className="stat-card glass-card">
            <span className="stat-label">Inventory Value (est.)</span>
            <span className="stat-value">
              {totalValue > 0
                ? `~$${totalValue.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`
                : '--'}
            </span>
          </div>
          <div className={`stat-card glass-card ${lowStockParts.length > 0 ? 'alert' : ''}`}>
            <span className="stat-label">Low Stock</span>
            <span className="stat-value">{lowStockParts.length}</span>
          </div>
          {openLeads > 0 && (
            <div className="stat-card glass-card">
              <span className="stat-label">Open Leads</span>
              <span className="stat-value">{openLeads}</span>
            </div>
          )}
          {scheduledJobs > 0 && (
            <div className="stat-card glass-card">
              <span className="stat-label">Scheduled</span>
              <span className="stat-value">{scheduledJobs}</span>
            </div>
          )}
        </div>

        {/* ---- Booking Requests (leads inbox) ---- */}
        {leads.length > 0 && (
          <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.03s' }}>
            <h2 className="section-title">
              Booking Requests
              <span className="accordion-count">{leads.length} new</span>
            </h2>
            <LeadList leads={leads} onConvert={handleConvertLead} onDismiss={handleDismissLead} />
          </div>
        )}

        {/* ---- Low Stock Alerts ---- */}
        {lowStockParts.length > 0 && (
          <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.05s' }}>
            <h2 className="section-title">Low Stock Alerts</h2>
            <div className="alert-list glass-card">
              {lowStockParts.map(p => (
                <div key={p.id} className="alert-row">
                  <div className="alert-info" onClick={() => { setEditingPart(p); setShowForm(true); }}>
                    <span className="alert-name">{p.name}</span>
                    <span className="alert-sku">{p.sku}</span>
                  </div>
                  <div className="alert-actions">
                    <a
                      href={buildReorderMailto(p, settings.alertEmail)}
                      className="btn-reorder"
                      onClick={e => e.stopPropagation()}
                      title="Send reorder email"
                    >
                      Reorder
                    </a>
                    <div className="alert-qty">
                      <span className="qty-current">{p.quantity}</span>
                      <span className="qty-sep">/</span>
                      <span className="qty-min">{p.minThreshold}</span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* ---- Jobs ---- */}
        <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.1s' }}>
          <div className="section-header">
            <h2 className="section-title">Jobs</h2>
            <div style={{ display: 'flex', gap: '8px' }}>
              <button
                className="btn btn-secondary btn-sm"
                onClick={() => setShowImport(v => !v)}
              >
                Import
              </button>
              <button
                className="btn btn-primary btn-sm"
                onClick={() => { setEditingJob(null); setShowJobForm(true); }}
              >
                + New Job
              </button>
            </div>
          </div>

          {showImport && (
            <div className="import-box">
              <textarea
                className="import-textarea"
                value={importText}
                onChange={e => setImportText(e.target.value)}
                rows={6}
                placeholder={"One job per line:\n- Customer | Service | Status | YYYY-MM-DD | Phone | Notes\n\nSmith Residence | Spring Replacement | Scheduled | 2026-06-02 | 604-555-0100\nHenderson | Opener Repair | Lead | | | LiftMaster 8500"}
              />
              <div className="import-actions">
                <button className="btn btn-secondary btn-sm" onClick={() => { setShowImport(false); setImportText(''); }}>Cancel</button>
                <button className="btn btn-primary btn-sm" onClick={handleImportJobs}>Import jobs</button>
              </div>
            </div>
          )}

          {showJobForm && (
            <JobForm
              job={editingJob}
              onSave={handleSaveJob}
              onCancel={() => { setShowJobForm(false); setEditingJob(null); }}
            />
          )}

          {jobs.length > 0 ? (
            <JobList
              jobs={jobs}
              onEdit={(j) => { setEditingJob(j); setShowJobForm(true); }}
              onDelete={(id) => setJobDeleteConfirm(id)}
              onAdvance={handleAdvanceJob}
            />
          ) : (
            <p className="empty-hint">No jobs yet. Create one to start tracking your pipeline.</p>
          )}
        </div>

        {/* ---- Inventory ---- */}
        <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.15s' }}>
          <div className="section-header accordion-toggle" onClick={() => setShowInventory(v => !v)}>
            <h2 className="section-title">
              Inventory
              <span className="accordion-count">{filteredParts.length} parts</span>
            </h2>
            <div className="section-actions" onClick={e => e.stopPropagation()}>
              <button
                className="btn btn-secondary btn-sm"
                onClick={() => exportCSV(filteredParts)}
                title="Export filtered inventory as CSV"
              >
                Export CSV
              </button>
              <button
                className="btn btn-primary btn-sm"
                onClick={() => { setEditingPart(null); setShowForm(true); setShowInventory(true); }}
              >
                + Add Part
              </button>
            </div>
            <span className={`accordion-chevron${showInventory ? ' open' : ''}`}>▼</span>
          </div>

          {showInventory && (
            <>
              <div className="inventory-toolbar">
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
        </div>

        {/* ---- Customers ---- */}
        {jobs.length > 0 && (
          <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.18s' }}>
            <h2 className="section-title">Customers</h2>
            <CustomerList jobs={jobs} />
          </div>
        )}

        {/* ---- Inventory Intelligence ---- */}
        {parts.length > 0 && (
          <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.22s' }}>
            <div className="section-header">
              <h2 className="section-title">Inventory Intelligence</h2>
            </div>
            <div className="intel-grid">
              <div className="intel-card glass-card">
                <div className="intel-card-title">Value by Category</div>
                <div className="bar-chart">
                  {categoryStats.map(({ cat, value }) => (
                    <div key={cat} className="bar-row">
                      <span className="bar-label">{cat}</span>
                      <div className="bar-track">
                        <div className="bar-fill" style={{ width: `${(value / maxCatValue) * 100}%` }}/>
                      </div>
                      <span className="bar-value">${value.toFixed(0)}</span>
                    </div>
                  ))}
                  {categoryStats.length === 0 && <p className="empty-hint">Add parts with costs to see breakdown.</p>}
                </div>
              </div>
              <div className="intel-card glass-card">
                <div className="intel-card-title">Value Summary</div>
                <div className="value-at-risk">
                  <div className="var-row">
                    <span className="var-label">Total inventory</span>
                    <span className="var-value">${totalValue.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
                  </div>
                  <div className="var-row">
                    <span className="var-label">At-risk value</span>
                    <span className={`var-value ${lowStockValue > 0 ? 'danger' : ''}`}>${lowStockValue.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
                  </div>
                  <div className="var-row">
                    <span className="var-label">SKUs at threshold</span>
                    <span className={`var-value ${lowStockParts.length > 0 ? 'danger' : ''}`}>{lowStockParts.length}</span>
                  </div>
                  <div className="var-row">
                    <span className="var-label">Out of stock</span>
                    <span className={`var-value ${outOfStock > 0 ? 'danger' : ''}`}>{outOfStock}</span>
                  </div>
                </div>
              </div>
              {reorderGroups.length > 0 && (
                <div className="intel-card glass-card" style={{ gridColumn: '1 / -1' }}>
                  <div className="intel-card-title">Reorder Queue — {lowStockParts.length} item{lowStockParts.length !== 1 ? 's' : ''} need restocking</div>
                  <div className="reorder-queue">
                    {reorderGroups.map(({ supplier, items, mailto }) => (
                      <div key={supplier}>
                        <div className="reorder-group-title">
                          <span>{supplier}</span>
                          <a href={mailto} className="btn-reorder">{items.length} item{items.length !== 1 ? 's' : ''} — Email Reorder</a>
                        </div>
                        {items.map(p => (
                          <div key={p.id} className="reorder-item">
                            <span className="reorder-item-name">{p.name} <span className="mono">{p.sku}</span></span>
                            <span className="reorder-item-qty">{p.quantity} on hand / {p.minThreshold} min</span>
                          </div>
                        ))}
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {/* ---- Recent Activity ---- */}
        <div className="section animate__animated animate__fadeInUp" style={{ animationDelay: '0.2s' }}>
          <h2 className="section-title">Recent Activity</h2>
          <HistoryLog limit={10} />
        </div>

        {/* ---- Settings (collapsible) ---- */}
        {showSettings && (
          <div className="section animate__animated animate__fadeInUp">
            <Settings
              settings={settings}
              onSave={(s) => { setSettings(s); saveSettings(s); showToast('Settings saved'); }}
            />
          </div>
        )}
      </main>

      {/* Delete confirmation modal -- parts */}
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

      {/* Delete confirmation modal -- jobs */}
      {jobDeleteConfirm && (
        <div className="modal-overlay" onClick={() => setJobDeleteConfirm(null)}>
          <div className="modal glass-card animate__animated animate__fadeInUp animate__faster" onClick={e => e.stopPropagation()}>
            <h3>Remove this job?</h3>
            <p>This will permanently delete this job and cannot be undone.</p>
            <div className="modal-actions">
              <button className="btn btn-secondary" onClick={() => setJobDeleteConfirm(null)}>Cancel</button>
              <button className="btn btn-delete" onClick={() => handleDeleteJob(jobDeleteConfirm)}>Remove</button>
            </div>
          </div>
        </div>
      )}

      {/* Cycle count overlay */}
      {cycleCount && parts.length > 0 && (
        <CycleCountModal
          parts={parts}
          index={cycleIndex}
          onSet={handleCycleSet}
          onAdvance={() => setCycleIndex(i => {
            if (i + 1 >= parts.length) { setCycleCount(false); showToast('Cycle count complete'); return 0; }
            return i + 1;
          })}
          onExit={() => { setCycleCount(false); showToast('Cycle count saved'); }}
        />
      )}

      {/* Toast notification */}
      {toast && (
        <div className="toast animate__animated animate__fadeInUp animate__faster">{toast}</div>
      )}

      {/* App footer */}
      <footer className="app-footer">
        <div className="footer-left">
          <span>&copy; 2026 Best Choice Garage Doors</span>
          <span className="footer-sep">|</span>
          <a href="https://bcgaragedoors.ca" target="_blank" rel="noopener noreferrer">bcgaragedoors.ca</a>
        </div>
        <div className="footer-shortcuts">
          <span className="shortcut-hint">Cmd+K Search</span>
          <span className="shortcut-hint">Cmd+Shift+C Cycle Count</span>
          <span className="shortcut-hint">Esc Close</span>
        </div>
      </footer>
    </div>
  );
}
