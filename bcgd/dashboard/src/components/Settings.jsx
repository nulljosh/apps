import { useState } from 'react';
import { getPin, savePin } from '../lib/storage';

export default function Settings({ settings, onSave }) {
  const [form, setForm] = useState(settings);
  const [newPin, setNewPin] = useState('');
  const [pinMsg, setPinMsg] = useState('');

  function set(k, v) { setForm(f => ({ ...f, [k]: v })); }

  function submit(e) {
    e.preventDefault();
    onSave(form);
  }

  function saveNewPin() {
    if (newPin.length !== 4 || !/^\d{4}$/.test(newPin)) {
      setPinMsg('PIN must be 4 digits');
      return;
    }
    savePin(newPin);
    setNewPin('');
    setPinMsg('PIN updated');
    setTimeout(() => setPinMsg(''), 2000);
  }

  function clearPin() {
    savePin('');
    setPinMsg('PIN removed');
    setTimeout(() => setPinMsg(''), 2000);
  }

  return (
    <form className="settings-form glass-card" onSubmit={submit}>
      <div className="settings-section">
        <h3 className="settings-heading">Alerts</h3>
        <div className="settings-row">
          <label>
            <input type="checkbox" checked={form.alertsEnabled} onChange={e => set('alertsEnabled', e.target.checked)}/>
            Enable low-stock alerts
          </label>
        </div>
        <div className="form-field">
          <label>Alert Email</label>
          <input type="email" value={form.alertEmail} onChange={e => set('alertEmail', e.target.value)} placeholder="parts@bcgaragedoors.ca"/>
        </div>
      </div>
      <div className="settings-section">
        <h3 className="settings-heading">PIN Lock</h3>
        <div className="form-field">
          <label>New PIN (4 digits)</label>
          <div className="pin-input-row">
            <input
              type="password"
              maxLength={4}
              pattern="\d{4}"
              value={newPin}
              onChange={e => setNewPin(e.target.value)}
              placeholder="••••"
              style={{ width: 80 }}
            />
            <button type="button" className="btn btn-secondary btn-sm" onClick={saveNewPin}>Set PIN</button>
            {getPin() && <button type="button" className="btn btn-secondary btn-sm" onClick={clearPin}>Remove PIN</button>}
          </div>
          {pinMsg && <span className="pin-msg">{pinMsg}</span>}
        </div>
      </div>
      <div className="form-actions">
        <button type="submit" className="btn btn-primary">Save Settings</button>
      </div>
    </form>
  );
}
