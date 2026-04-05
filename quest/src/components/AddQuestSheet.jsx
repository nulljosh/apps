import { useState } from 'react';
import { DifficultyRank, QuestCategory } from '../models/types.js';
import './AddQuestSheet.css';

export default function AddQuestSheet({ onAdd, onClose }) {
  const [title, setTitle] = useState('');
  const [difficulty, setDifficulty] = useState('C');
  const [category, setCategory] = useState('personal');
  const [dueDate, setDueDate] = useState('');
  const [notes, setNotes] = useState('');

  function handleSubmit(e) {
    e.preventDefault();
    if (!title.trim()) return;
    onAdd({
      title: title.trim(),
      difficulty,
      category,
      dueDate: dueDate || null,
      notes: notes.trim(),
    });
    onClose();
  }

  return (
    <div className="sheet-backdrop" onClick={onClose}>
      <div className="sheet-scroll animate-scroll-unroll paper-grain" onClick={e => e.stopPropagation()}>
        <h2 className="sheet-title">Inscribe New Quest</h2>
        <img src="/textures/divider.svg" alt="" className="sheet-divider" />

        <form onSubmit={handleSubmit} className="sheet-form">
          <label className="sheet-label">
            <span className="section-label">Quest Name</span>
            <input
              type="text"
              value={title}
              onChange={e => setTitle(e.target.value)}
              className="sheet-input"
              placeholder="Slay the dragon..."
              autoFocus
            />
          </label>

          <label className="sheet-label">
            <span className="section-label">Difficulty</span>
            <div className="difficulty-selector">
              {Object.keys(DifficultyRank).map(rank => (
                <button
                  key={rank}
                  type="button"
                  className={`diff-btn ${difficulty === rank ? 'active' : ''}`}
                  onClick={() => setDifficulty(rank)}
                >
                  {rank}
                  <span className="diff-xp">{DifficultyRank[rank].xp}</span>
                </button>
              ))}
            </div>
          </label>

          <label className="sheet-label">
            <span className="section-label">Category</span>
            <div className="category-selector">
              {Object.entries(QuestCategory).map(([key, cat]) => (
                <button
                  key={key}
                  type="button"
                  className={`cat-btn ${category === key ? 'active' : ''}`}
                  style={{ '--cat-color': cat.color }}
                  onClick={() => setCategory(key)}
                >
                  {cat.label}
                </button>
              ))}
            </div>
          </label>

          <label className="sheet-label">
            <span className="section-label">Due Date (optional)</span>
            <input
              type="date"
              value={dueDate}
              onChange={e => setDueDate(e.target.value)}
              className="sheet-input"
            />
          </label>

          <label className="sheet-label">
            <span className="section-label">Notes</span>
            <textarea
              value={notes}
              onChange={e => setNotes(e.target.value)}
              className="sheet-input sheet-textarea"
              rows={3}
              placeholder="Additional details..."
            />
          </label>

          <div className="sheet-actions">
            <button type="button" className="sheet-cancel" onClick={onClose}>Discard</button>
            <button type="submit" className="sheet-submit" disabled={!title.trim()}>
              Inscribe Quest
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
