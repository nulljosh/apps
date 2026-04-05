import { xpProgress } from '../store/xpEngine.js';
import './XPBar.css';

export default function XPBar({ totalXP }) {
  const { level, progress, needed, percent } = xpProgress(totalXP);

  return (
    <div className="xp-bar-container">
      <div className="xp-bar-track">
        <div className="xp-bar-rivet left" />
        <div className="xp-bar-fill" style={{ width: `${Math.min(percent, 100)}%` }} />
        <div className="xp-bar-rivet right" />
      </div>
      <div className="xp-bar-label">
        <span className="xp-bar-numbers">{progress} / {needed} XP</span>
      </div>
    </div>
  );
}
