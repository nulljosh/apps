import WaxSeal from '../components/WaxSeal.jsx';
import XPBar from '../components/XPBar.jsx';
import CandleFlicker from '../components/CandleFlicker.jsx';
import GoldCoin from '../components/GoldCoin.jsx';
import { getLevel, getTitle } from '../store/xpEngine.js';
import { QuestCategory } from '../models/types.js';
import './CharacterSheet.css';

function getDominantClass(quests) {
  const counts = {};
  quests.filter(q => q.completed).forEach(q => {
    counts[q.category] = (counts[q.category] || 0) + 1;
  });
  const top = Object.entries(counts).sort((a, b) => b[1] - a[1])[0];
  if (!top) return 'Adventurer';
  return QuestCategory[top[0]]?.className || 'Adventurer';
}

export default function CharacterSheet({ profile, setProfile, quests }) {
  const level = getLevel(profile.totalXP);
  const title = getTitle(level);
  const className = getDominantClass(quests);
  const completedCount = quests.filter(q => q.completed).length;
  const activeCount = quests.filter(q => !q.completed).length;
  const initials = profile.name
    .split(' ')
    .map(w => w[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();

  return (
    <div className="character-sheet">
      <div className="character-portrait">
        <WaxSeal initials={initials} size={80} />
      </div>

      <input
        type="text"
        value={profile.name}
        onChange={e => setProfile(prev => ({ ...prev, name: e.target.value }))}
        className="character-name"
      />

      <p className="character-class">{className}</p>

      <div className="character-level">
        <span className="character-level-num">Lvl {level}</span>
        <span className="character-title">{title}</span>
      </div>

      <XPBar totalXP={profile.totalXP} />

      <div className="character-divider">
        <img src="/textures/divider.svg" alt="" />
      </div>

      <div className="character-stats">
        <div className="stat-block">
          <span className="stat-value">{completedCount}</span>
          <span className="stat-label section-label">Completed</span>
        </div>
        <div className="stat-block">
          <span className="stat-value">{activeCount}</span>
          <span className="stat-label section-label">Active</span>
        </div>
        <div className="stat-block">
          <CandleFlicker streak={profile.currentStreak} />
          <span className="stat-label section-label">Streak</span>
        </div>
      </div>

      <div className="character-divider">
        <img src="/textures/divider.svg" alt="" />
      </div>

      <div className="character-total-xp">
        <GoldCoin amount={`${profile.totalXP} Total XP`} />
      </div>
    </div>
  );
}
