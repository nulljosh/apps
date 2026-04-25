import { useState } from 'react';
import { generateId, CATEGORIES } from '../lib/storage';

export default function PartForm({ part, onSave, onCancel }) {
  const [form, setForm] = useState(part || {
    id: generateId(),
    name: '',
    sku: '',
    category: CATEGORIES[0],
    quantity: 0,
    minThreshold: 5,
    cost: 0,
    supplier: '',
  });

  const update = (field, value) => setForm(prev => ({ ...prev, [field]: value }));

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!form.name.trim() || !form.sku.trim()) return;
    onSave({
      ...form,
      quantity: Number(form.quantity),
      minThreshold: Number(form.minThreshold),
      cost: Number(form.cost),
    });
  };

  return (
    <form className="part-form glass-card animate__animated animate__fadeInDown" onSubmit={handleSubmit}>
      <h3 className="form-title">{part ? 'Edit Part' : 'Add New Part'}</h3>

      <div className="form-grid">
        <div className="form-field">
          <label>Part Name</label>
          <input
            type="text"
            value={form.name}
            onChange={e => update('name', e.target.value)}
            placeholder="Torsion Spring 2in"
            required
          />
        </div>

        <div className="form-field">
          <label>SKU</label>
          <input
            type="text"
            value={form.sku}
            onChange={e => update('sku', e.target.value)}
            placeholder="SPR-TOR-200"
            required
          />
        </div>

        <div className="form-field">
          <label>Category</label>
          <select value={form.category} onChange={e => update('category', e.target.value)}>
            {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>

        <div className="form-field">
          <label>Supplier</label>
          <input
            type="text"
            value={form.supplier}
            onChange={e => update('supplier', e.target.value)}
            placeholder="Clopay"
          />
        </div>

        <div className="form-field">
          <label>Quantity</label>
          <input
            type="number"
            min="0"
            value={form.quantity}
            onChange={e => update('quantity', e.target.value)}
          />
        </div>

        <div className="form-field">
          <label>Min Threshold</label>
          <input
            type="number"
            min="0"
            value={form.minThreshold}
            onChange={e => update('minThreshold', e.target.value)}
          />
        </div>

        <div className="form-field">
          <label>Unit Cost ($)</label>
          <input
            type="number"
            min="0"
            step="0.01"
            value={form.cost}
            onChange={e => update('cost', e.target.value)}
          />
        </div>
      </div>

      <div className="form-actions">
        <button type="button" className="btn btn-secondary" onClick={onCancel}>Cancel</button>
        <button type="submit" className="btn btn-primary">
          {part ? 'Save Changes' : 'Add Part'}
        </button>
      </div>
    </form>
  );
}
