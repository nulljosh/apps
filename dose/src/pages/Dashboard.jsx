import { useState } from 'react';
import { useDoseLog } from '../hooks/useDoseLog';
import { useSubstances } from '../hooks/useSubstances';
import LogEntry from '../components/LogEntry';
import AddEntryModal from '../components/AddEntryModal';
import { CATEGORY_COLORS } from '../constants/colors';

export default function Dashboard() {
  const { addEntry, deleteEntry, getEntries, getActive } = useDoseLog();
  const { getById } = useSubstances();
  const [showModal, setShowModal] = useState(false);

  const active = getActive();
  const recent = getEntries().slice(0, 5);
  const activeSubIds = [...new Set(active.map(e => e.substanceId))];

  const hour = new Date().getHours();
  let greeting = 'Good evening';
  if (hour < 12) greeting = 'Good morning';
  else if (hour < 17) greeting = 'Good afternoon';

  return (
    <main className="page">
      <div style={{ marginBottom: 32 }}>
        <div className="date-label">
          {new Date().toLocaleDateString('en-CA', { weekday: 'long', month: 'long', day: 'numeric' })}
        </div>
        <h1 className="page-title" style={{ fontSize: 'clamp(2rem, 8vw, 2.8rem)', marginBottom: 6 }}>
          {greeting}.
        </h1>
        <p style={{ color: 'var(--text-secondary)', fontSize: '0.9rem', margin: 0 }}>
          {active.length === 0
            ? 'Nothing logged in the last 24 hours.'
            : `${active.length} dose${active.length !== 1 ? 's' : ''} logged today.`}
        </p>
      </div>

      {activeSubIds.length > 0 && (
        <section style={{ marginBottom: 28 }}>
          <div className="section-label">Active Stack -- last 24h</div>
          <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
            {activeSubIds.map(id => {
              const sub = getById(id);
              if (!sub) return null;
              const color = CATEGORY_COLORS[sub.category] || '#4e9cd7';
              return (
                <div key={id} className="active-pill" style={{ background: color + '14', border: `1px solid ${color}44` }}>
                  <div className="active-dot" style={{ background: color }} />
                  <span style={{ fontSize: '0.88rem', fontWeight: 600 }}>{sub.name}</span>
                  <span style={{ fontSize: '0.7rem', color: 'var(--text-secondary)' }}>
                    \u00d7{active.filter(e => e.substanceId === id).length}
                  </span>
                </div>
              );
            })}
          </div>
        </section>
      )}

      <button className="btn-primary" onClick={() => setShowModal(true)} style={{ marginBottom: 32 }}>
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
          <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
        </svg>
        Log a Dose
      </button>

      <section>
        <div className="section-label">Recent Entries</div>
        {recent.length === 0 ? (
          <div className="card-empty">No entries yet. Start logging your doses above.</div>
        ) : (
          <div className="entry-list">
            {recent.map(entry => (
              <LogEntry key={entry.id} entry={entry} onDelete={deleteEntry} />
            ))}
          </div>
        )}
      </section>

      {showModal && (
        <AddEntryModal onAdd={addEntry} onClose={() => setShowModal(false)} />
      )}
    </main>
  );
}
