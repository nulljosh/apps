import { useState, useRef } from 'react';
import { getPin, setPin as savePin, exportAll, importAll } from '../lib/storage';

export default function Settings({ settings, onSave }) {
  const [form, setForm] = useState(settings);
  const [pinInput, setPinInput] = useState('');
  const [pinMsg, setPinMsg] = useState('');
  const [hasPin, setHasPin] = useState(!!getPin());
  const [backupMsg, setBackupMsg] = useState('');
  const fileRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(form);
  };

  const handleSetPin = () => {
    if (pinInput.length !== 4 || !/^\d{4}$/.test(pinInput)) {
      setPinMsg('PIN must be exactly 4 digits');
      return;
    }
    savePin(pinInput);
    setHasPin(true);
    setPinInput('');
    setPinMsg('PIN set');
    setTimeout(() => setPinMsg(''), 2000);
  };

  const handleRemovePin = () => {
    savePin(null);
    setHasPin(false);
    setPinInput('');
    setPinMsg('PIN removed');
    setTimeout(() => setPinMsg(''), 2000);
  };

  const handleDownloadBackup = () => {
    const json = exportAll();
    const blob = new Blob([json], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `bcgd-backup-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleRestoreBackup = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => {
      try {
        importAll(ev.target.result);
        setBackupMsg('Backup restored. Reloading...');
        setTimeout(() => window.location.reload(), 1000);
      } catch {
        setBackupMsg('Invalid backup file');
        setTimeout(() => setBackupMsg(''), 3000);
      }
    };
    reader.readAsText(file);
  };

  return (
    <div className="settings animate__animated animate__fadeIn">
      <h2 className="section-title">Alert Settings</h2>
      <form className="settings-form glass-card" onSubmit={handleSubmit}>
        <div className="form-field">
          <label>Alert Email</label>
          <input
            type="email"
            value={form.alertEmail}
            onChange={e => setForm(prev => ({ ...prev, alertEmail: e.target.value }))}
            placeholder="expert@bcgaragedoors.ca"
          />
          <span className="form-hint">Reorder emails will be pre-addressed to this recipient</span>
        </div>

        <div className="form-field">
          <label className="toggle-label">
            <input
              type="checkbox"
              checked={form.alertsEnabled}
              onChange={e => setForm(prev => ({ ...prev, alertsEnabled: e.target.checked }))}
            />
            <span>Show low-stock reorder prompts</span>
          </label>
        </div>

        <div className="form-actions">
          <button type="submit" className="btn btn-primary">Save Settings</button>
        </div>
      </form>

      <h2 className="section-title" style={{ marginTop: '28px' }}>Security</h2>
      <div className="settings-form glass-card">
        <div className="form-field">
          <label>{hasPin ? 'Change PIN' : 'Set PIN'}</label>
          <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
            <input
              type="password"
              maxLength={4}
              value={pinInput}
              onChange={e => setPinInput(e.target.value.replace(/\D/g, ''))}
              placeholder="4-digit PIN"
              inputMode="numeric"
              pattern="[0-9]*"
              style={{ maxWidth: '140px' }}
            />
            <button type="button" className="btn btn-primary" onClick={handleSetPin}>
              {hasPin ? 'Update' : 'Set PIN'}
            </button>
            {hasPin && (
              <button type="button" className="btn btn-delete" onClick={handleRemovePin}>
                Remove PIN
              </button>
            )}
          </div>
          {pinMsg && <span className="form-hint" style={{ color: pinMsg.includes('must') ? 'var(--red)' : 'var(--green)' }}>{pinMsg}</span>}
          <span className="form-hint">When set, a PIN is required to access the dashboard</span>
        </div>
      </div>

      <h2 className="section-title" style={{ marginTop: '28px' }}>Data</h2>
      <div className="settings-form glass-card">
        <div className="form-field">
          <label>Backup</label>
          <div style={{ display: 'flex', gap: '8px', alignItems: 'center', flexWrap: 'wrap' }}>
            <button type="button" className="btn btn-primary" onClick={handleDownloadBackup}>
              Download Backup
            </button>
            <button type="button" className="btn btn-secondary" onClick={() => fileRef.current?.click()}>
              Restore from Backup
            </button>
            <input
              ref={fileRef}
              type="file"
              accept=".json"
              onChange={handleRestoreBackup}
              style={{ display: 'none' }}
            />
          </div>
          {backupMsg && <span className="form-hint" style={{ color: backupMsg.includes('Invalid') ? 'var(--red)' : 'var(--green)' }}>{backupMsg}</span>}
          <span className="form-hint">Export all inventory, jobs, history, and settings as JSON</span>
        </div>
      </div>
    </div>
  );
}
