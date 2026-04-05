import { useState, useRef } from 'react';
import ParchmentCard from '../components/ParchmentCard.jsx';
import { createReward } from '../models/types.js';
import { exportTome, importTome } from '../store/questStore.js';
import './Settings.css';

export default function Settings({ rewards, setRewards }) {
  const [newReward, setNewReward] = useState('');
  const fileRef = useRef(null);

  function handleAddReward(e) {
    e.preventDefault();
    if (!newReward.trim()) return;
    setRewards(prev => [...prev, createReward(newReward.trim())]);
    setNewReward('');
  }

  function handleRemoveReward(id) {
    setRewards(prev => prev.filter(r => r.id !== id));
  }

  function handleExport() {
    const json = exportTome();
    const blob = new Blob([json], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `quest-tome-${new Date().toISOString().slice(0, 10)}.json`;
    a.click();
    URL.revokeObjectURL(url);
  }

  function handleImport(e) {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      try {
        importTome(reader.result);
        window.location.reload();
      } catch {
        alert('Invalid tome file.');
      }
    };
    reader.readAsText(file);
  }

  return (
    <div className="settings-page">
      <h1 className="settings-title">Settings</h1>

      <section className="settings-section">
        <h2 className="section-label">Boons & Pleasures</h2>
        <p className="settings-desc">
          When a quest is completed, the fates may bestow one of these rewards upon thee.
        </p>

        <form onSubmit={handleAddReward} className="reward-add-form">
          <input
            type="text"
            value={newReward}
            onChange={e => setNewReward(e.target.value)}
            className="sheet-input reward-input"
            placeholder="e.g. Take a coffee break"
          />
          <button type="submit" className="reward-add-btn" disabled={!newReward.trim()}>Add</button>
        </form>

        <div className="reward-list">
          {rewards.length === 0 && (
            <p className="quest-empty">No rewards configured. Add some boons above.</p>
          )}
          {rewards.map(reward => (
            <ParchmentCard key={reward.id} className="reward-item">
              <span className="reward-item-text">{reward.text}</span>
              <button
                className="reward-remove"
                onClick={() => handleRemoveReward(reward.id)}
                title="Remove"
              >
                &times;
              </button>
            </ParchmentCard>
          ))}
        </div>
      </section>

      <section className="settings-section">
        <h2 className="section-label">Tome Management</h2>
        <div className="tome-actions">
          <button className="tome-btn" onClick={handleExport}>Export Tome</button>
          <button className="tome-btn" onClick={() => fileRef.current?.click()}>Import Tome</button>
          <input
            ref={fileRef}
            type="file"
            accept=".json"
            onChange={handleImport}
            hidden
          />
        </div>
      </section>
    </div>
  );
}
