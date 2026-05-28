import { useState } from 'react';
import { CATEGORIES, generateId } from '../lib/storage';

const EMPTY = { name: '', sku: '', category: 'Springs', quantity: 0, minThreshold: 2, cost: 0, supplier: '' };

export default function PartForm({ part, onSave, onCancel }) {
  const [form, setForm] = useState(part || EMPTY);

  function set(k, v) { setForm(f => ({ ...f, [k]: v })); }

  function submit(e) {
    e.preventDefault();
    onSave({ ...form, id: form.id || generateId(), quantity: +form.quantity, minThreshold: +form.minThreshold, cost: +form.cost });
  }

  return (
    <form className="part-form glass-card" onSubmit={submit}>
      <div className="form-grid">
        <div className="form-field">
          <label>Name</label>
          <input required value={form.name} onChange={e => set('name', e.target.value)} placeholder="e.g. Torsion Spring 2-inch"/>
        </div>
        <div className="form-field">
          <label>SKU</label>
          <input value={form.sku} onChange={e => set('sku', e.target.value)} placeholder="e.g. SPR-2T-200"/>
        </div>
        <div className="form-field">
          <label>Category</label>
          <select value={form.category} onChange={e => set('category', e.target.value)}>
            {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
          </select>
        </div>
        <div className="form-field">
          <label>Quantity</label>
          <input type="number" min="0" value={form.quantity} onChange={e => set('quantity', e.target.value)}/>
        </div>
        <div className="form-field">
          <label>Min Threshold</label>
          <input type="number" min="0" value={form.minThreshold} onChange={e => set('minThreshold', e.target.value)}/>
        </div>
        <div className="form-field">
          <label>Unit Cost ($)</label>
          <input type="number" min="0" step="0.01" value={form.cost} onChange={e => set('cost', e.target.value)}/>
        </div>
        <div className="form-field form-field-full">
          <label>Supplier</label>
          <input value={form.supplier} onChange={e => set('supplier', e.target.value)} placeholder="e.g. LiftMaster Canada"/>
        </div>
      </div>
      <div className="form-actions">
        <button type="button" className="btn btn-secondary" onClick={onCancel}>Cancel</button>
        <button type="submit" className="btn btn-primary">{part ? 'Save Changes' : 'Add Part'}</button>
      </div>
    </form>
  );
}
