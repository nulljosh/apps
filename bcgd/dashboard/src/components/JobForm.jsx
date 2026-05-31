import { useState } from 'react';
import { generateId, JOB_STATUSES } from '../lib/storage';

const SERVICES = [
  'Garage Door Repair', 'Spring Replacement', 'Cable Repair', 'Maintenance',
  'Emergency Repair', 'Hinge Replacement', 'Keypad / Remote', 'Panel Repair',
  'Weather Strip', 'Roller Replacement', 'Opener Repair', 'Other',
];

const EMPTY = {
  customer: '', address: '', phone: '', email: '',
  service: '', status: 'Scheduled', notes: '', scheduledAt: '',
};

export default function JobForm({ job, onSave, onCancel }) {
  const [form, setForm] = useState(job || EMPTY);

  function set(k, v) { setForm(f => ({ ...f, [k]: v })); }

  function submit(e) {
    e.preventDefault();
    onSave({ ...form, id: form.id || generateId(), createdAt: form.createdAt || new Date().toISOString() });
  }

  return (
    <form className="part-form glass-card" onSubmit={submit}>
      <div className="form-grid">
        <div className="form-field">
          <label>Customer Name</label>
          <input required value={form.customer} onChange={e => set('customer', e.target.value)} placeholder="John Smith"/>
        </div>
        <div className="form-field">
          <label>Phone</label>
          <input type="tel" value={form.phone} onChange={e => set('phone', e.target.value)} placeholder="(604) 555-0100"/>
        </div>
        <div className="form-field form-field-full">
          <label>Address</label>
          <input value={form.address} onChange={e => set('address', e.target.value)} placeholder="123 Main St, Langley, BC"/>
        </div>
        <div className="form-field">
          <label>Service Type</label>
          <select value={form.service} onChange={e => set('service', e.target.value)}>
            <option value="">Select...</option>
            {SERVICES.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>
        <div className="form-field">
          <label>Status</label>
          <select value={form.status} onChange={e => set('status', e.target.value)}>
            {JOB_STATUSES.map(s => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>
        <div className="form-field">
          <label>Scheduled Date</label>
          <input type="date" value={form.scheduledAt ? form.scheduledAt.slice(0, 10) : ''} onChange={e => set('scheduledAt', e.target.value)}/>
        </div>
        <div className="form-field form-field-full">
          <label>Notes</label>
          <textarea value={form.notes} onChange={e => set('notes', e.target.value)} placeholder="Door stuck open, possible spring issue..." rows={3}/>
        </div>
      </div>
      <div className="form-actions">
        <button type="button" className="btn btn-secondary" onClick={onCancel}>Cancel</button>
        <button type="submit" className="btn btn-primary">{job ? 'Save Changes' : 'Create Job'}</button>
      </div>
    </form>
  );
}
