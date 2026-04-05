import { QuestCategory } from '../models/types.js';

export default function CategoryStamp({ category }) {
  const cat = QuestCategory[category];
  if (!cat) return null;

  return (
    <span
      className="category-stamp"
      style={{
        display: 'inline-block',
        padding: '2px 8px',
        borderRadius: '50%',
        border: `2px solid ${cat.color}`,
        fontFamily: 'var(--font-stats)',
        fontSize: '0.65rem',
        letterSpacing: '0.05em',
        textTransform: 'uppercase',
        color: cat.color,
        background: `${cat.color}15`,
      }}
    >
      {cat.label}
    </span>
  );
}
