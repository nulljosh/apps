import { useState } from 'react';

const KEY = 'dose:profile';

const DEFAULT_PROFILE = {
  substances: [
    { name: 'Coffee', frequency: 'daily', notes: 'Probably affecting stomach pH' },
    { name: 'Cannabis', frequency: 'daily', notes: 'Daily use, vaping. Started ~10 years ago.' },
    { name: 'Tobacco/Vape', frequency: 'daily', notes: 'Lung health concern. Spirometry pending.' },
    { name: 'Sertraline', frequency: 'daily', notes: '50mg nightly' },
    { name: 'Psilocybin', frequency: 'microdosing', notes: 'Intermittent microdosing' },
    { name: 'L-Theanine', frequency: 'daily', notes: '200mg with coffee' },
  ],
  conditions: [
    { name: 'ADHD', status: 'diagnosed', notes: '' },
    { name: 'Autism', status: 'diagnosed', notes: '' },
    { name: 'Bunion (big toe)', status: 'active', notes: 'Right foot' },
    { name: 'Low SpO2', status: 'monitoring', notes: '92-100% range. Possibly smoking related.' },
    { name: 'Stomach pH / acid', status: 'concern', notes: 'Coffee + smoking likely contributing' },
  ],
  pendingTests: [
    { name: 'Liver Panel', location: 'LifeLabs', status: 'pending', notes: '' },
    { name: 'Thyroid Panel', location: 'LifeLabs', status: 'pending', notes: '' },
    { name: 'Full Blood Panel (CBC, lipids, heart markers)', location: 'LifeLabs', status: 'pending', notes: '' },
    { name: 'Spirometry (lung function)', location: 'TBD', status: 'pending', notes: 'Smoking-related lung function concern' },
    { name: 'Cognitive / brain health baseline', location: 'TBD', status: 'pending', notes: 'Weed/vape since ~age 16' },
  ],
  notes: 'Currently tracking blood pressure and resting heart rate trends. Cessation support options exist for smoking — ask doctor.',
};

function loadProfile() {
  try {
    const raw = localStorage.getItem(KEY);
    if (!raw) return DEFAULT_PROFILE;
    return { ...DEFAULT_PROFILE, ...JSON.parse(raw) };
  } catch {
    return DEFAULT_PROFILE;
  }
}

function saveProfile(data) {
  try { localStorage.setItem(KEY, JSON.stringify(data)); } catch {}
}

const STATUS_COLORS = {
  diagnosed: 'var(--accent)',
  active: 'var(--danger)',
  monitoring: 'var(--warning)',
  concern: 'var(--warning)',
  pending: 'var(--text-tertiary)',
  done: 'var(--success)',
};

export default function Profile() {
  const [profile, setProfile] = useState(loadProfile);
  const [editingNotes, setEditingNotes] = useState(false);
  const [notesVal, setNotesVal] = useState(profile.notes);

  function saveNotes() {
    const next = { ...profile, notes: notesVal };
    setProfile(next);
    saveProfile(next);
    setEditingNotes(false);
  }

  function toggleTestStatus(i) {
    const tests = [...profile.pendingTests];
    tests[i] = { ...tests[i], status: tests[i].status === 'pending' ? 'done' : 'pending' };
    const next = { ...profile, pendingTests: tests };
    setProfile(next);
    saveProfile(next);
  }

  return (
    <div className="page" style={{ maxWidth: 600 }}>
      <h1 className="page-title">Health Profile</h1>
      <p className="page-subtitle">Background, conditions, and pending medical actions.</p>

      {/* Pending Tests */}
      <div className="section-label" style={{ marginBottom: 10 }}>Pending Tests</div>
      <div className="card" style={{ marginBottom: 20 }}>
        {profile.pendingTests.map((t, i) => (
          <div
            key={i}
            style={{
              display: 'flex', alignItems: 'flex-start', gap: 12,
              padding: '10px 0',
              borderBottom: i < profile.pendingTests.length - 1 ? '1px solid var(--border-muted)' : 'none',
              opacity: t.status === 'done' ? 0.45 : 1,
            }}
          >
            <button
              onClick={() => toggleTestStatus(i)}
              style={{
                width: 18, height: 18, flexShrink: 0, marginTop: 2,
                borderRadius: 4, border: `2px solid ${t.status === 'done' ? 'var(--success)' : 'var(--border)'}`,
                background: t.status === 'done' ? 'var(--success)' : 'transparent',
                cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}
            >
              {t.status === 'done' && (
                <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
                  <path d="M2 5l2.5 2.5 4-4" stroke="#000" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              )}
            </button>
            <div style={{ flex: 1 }}>
              <div style={{ fontWeight: 500, fontSize: '0.88rem', textDecoration: t.status === 'done' ? 'line-through' : 'none' }}>
                {t.name}
              </div>
              <div style={{ fontSize: '0.75rem', color: 'var(--text-tertiary)', marginTop: 2 }}>
                {t.location}{t.notes ? ` — ${t.notes}` : ''}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Conditions */}
      <div className="section-label" style={{ marginBottom: 10 }}>Conditions & Concerns</div>
      <div className="card" style={{ marginBottom: 20 }}>
        {profile.conditions.map((c, i) => (
          <div
            key={i}
            style={{
              display: 'flex', alignItems: 'center', gap: 12,
              padding: '10px 0',
              borderBottom: i < profile.conditions.length - 1 ? '1px solid var(--border-muted)' : 'none',
            }}
          >
            <div style={{
              width: 8, height: 8, borderRadius: '50%', flexShrink: 0,
              background: STATUS_COLORS[c.status] || 'var(--text-tertiary)',
            }} />
            <div style={{ flex: 1 }}>
              <div style={{ fontWeight: 500, fontSize: '0.88rem' }}>{c.name}</div>
              {c.notes && <div style={{ fontSize: '0.75rem', color: 'var(--text-tertiary)', marginTop: 2 }}>{c.notes}</div>}
            </div>
            <span style={{
              fontSize: '0.68rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em',
              color: STATUS_COLORS[c.status] || 'var(--text-tertiary)',
            }}>
              {c.status}
            </span>
          </div>
        ))}
      </div>

      {/* Current Substances */}
      <div className="section-label" style={{ marginBottom: 10 }}>Current Substances</div>
      <div className="card" style={{ marginBottom: 20 }}>
        {profile.substances.map((s, i) => (
          <div
            key={i}
            style={{
              display: 'flex', alignItems: 'flex-start', gap: 12,
              padding: '10px 0',
              borderBottom: i < profile.substances.length - 1 ? '1px solid var(--border-muted)' : 'none',
            }}
          >
            <div style={{ flex: 1 }}>
              <div style={{ fontWeight: 500, fontSize: '0.88rem' }}>{s.name}</div>
              {s.notes && <div style={{ fontSize: '0.75rem', color: 'var(--text-tertiary)', marginTop: 2 }}>{s.notes}</div>}
            </div>
            <span style={{
              fontSize: '0.72rem', color: 'var(--text-tertiary)',
              background: 'var(--bg-tertiary)', padding: '3px 8px', borderRadius: 100,
              flexShrink: 0,
            }}>
              {s.frequency}
            </span>
          </div>
        ))}
      </div>

      {/* Notes */}
      <div className="section-label" style={{ marginBottom: 10 }}>Notes</div>
      <div className="card" style={{ marginBottom: 20 }}>
        {editingNotes ? (
          <>
            <textarea
              value={notesVal}
              onChange={e => setNotesVal(e.target.value)}
              rows={4}
              className="input"
              style={{ resize: 'vertical', marginBottom: 12 }}
            />
            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn-primary" onClick={saveNotes}>Save</button>
              <button className="btn-ghost" onClick={() => { setEditingNotes(false); setNotesVal(profile.notes); }}>Cancel</button>
            </div>
          </>
        ) : (
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12 }}>
            <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', margin: 0, lineHeight: 1.6 }}>
              {profile.notes || 'No notes.'}
            </p>
            <button className="btn-ghost" onClick={() => setEditingNotes(true)} style={{ flexShrink: 0 }}>Edit</button>
          </div>
        )}
      </div>
    </div>
  );
}
