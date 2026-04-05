import { DifficultyRank } from '../models/types.js';

const rankColors = {
  F: '#888',
  D: '#6b8f71',
  C: '#4a6741',
  B: '#c9a84c',
  A: '#c0392b',
  S: '#8b1a1a',
};

export default function DifficultyBadge({ rank }) {
  const color = rankColors[rank] || '#888';

  return (
    <span
      className="difficulty-badge"
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        width: 28,
        height: 28,
        borderRadius: '50%',
        border: `2px solid ${color}`,
        fontFamily: 'var(--font-display)',
        fontSize: '0.75rem',
        fontWeight: 700,
        color,
        background: `${color}10`,
        flexShrink: 0,
      }}
    >
      {rank}
    </span>
  );
}
