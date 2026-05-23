import { useState } from 'react';
import { generateId, JOB_STATUSES } from '../lib/storage';

export default function JobForm({ job, onSave, onCancel }) {
  const [form, setForm] = useState(job || {
    id: generateId(),
    client: '',
    phone: '',
    service: '',
    status: JOB_STATUSES[0],
    value: 0,
    date: '',
    notes: '',
  });

  const update = (field, value) => setForm(prev => ({ ...prev, [field]: value }));

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!form.client.trim()) return;
    onSave({
      ...form,
      value: Number(form.value),
    });
  };

  return (
    <form className="part-form glass-card animate__animated animate__fadeInDown" onSubmit={handleSubmit}>
      <h3 className="form-title">{job ? 'Edit Job' : 'New Job'}</h3>

      <div className="form-grid">
        <div className="form-field">
          <label>Client Name</label>
          <input
            type="text"
            value={form.client}
            onChange={e => update('client', e.target.value)}
            placeholder="John Smith"
            required
          />
        </div>

        <div className="form-field">
          <label>Phone</label>
          <input
            type="tel"
            value={form.phone}
            onChange={e => update('phone', e.target.value)}
            placeholder="604-555-1234"
          />
        </div>

        <div className="form-field">
          <label>Service Type</label>
          <input
            type="text"
            value={form.service}
            onChange={e => update('service', e.target.value)}
            placeholder="Spring replacement"
          />
        </div>

        <div className="form-field">
          <label>Status</label>
          <select value={form.status} onChange={e => update('status', e.target.value)}>
            {JOB_STATUSES.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>

        <div className="form-field">
          <label>Estimated Value ($)</label>
          <input
            type="number"
            min="0"
            step="0.01"
            value={form.value}
            onChange={e => update('value', e.target.value)}
          />
        </div>

        <div className="form-field">
          <label>Scheduled Date</label>
          <input
            type="date"
            value={form.date}
            onChange={e => update('date', e.target.value)}
          />
        </div>

        <div className="form-field" style={{ gridColumn: '1 / -1' }}>
          <label>Notes</label>
          <textarea
            value={form.notes}
            onChange={e => update('notes', e.target.value)}
            placeholder="Additional details..."
            rows={3}
            style={{
              width: '100%',
              padding: '9px 12px',
              border: '1px solid var(--border)',
              borderRadius: 'var(--radius-sm)',
              fontSize: '0.88rem',
              fontFamily: 'inherit',
              background: 'rgba(255, 255, 255, 0.5)',
              outline: 'none',
              resize: 'vertical',
            }}
          />
        </div>
      </div>

      <div className="form-actions">
        <button type="button" className="btn btn-secondary" onClick={onCancel}>Cancel</button>
        <button type="submit" className="btn btn-primary">
          {job ? 'Save Changes' : 'Add Job'}
        </button>
      </div>
    </form>
  );
}
