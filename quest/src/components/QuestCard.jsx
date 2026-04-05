import ParchmentCard from './ParchmentCard.jsx';
import DifficultyBadge from './DifficultyBadge.jsx';
import CategoryStamp from './CategoryStamp.jsx';
import GoldCoin from './GoldCoin.jsx';
import WaxSeal from './WaxSeal.jsx';
import { DifficultyRank } from '../models/types.js';
import './QuestCard.css';

export default function QuestCard({ quest, onComplete }) {
  const xp = DifficultyRank[quest.difficulty]?.xp || 0;

  return (
    <ParchmentCard className={`quest-card ${quest.completed ? 'completed' : ''}`}>
      <div className="quest-card-header">
        <DifficultyBadge rank={quest.difficulty} />
        <div className="quest-card-info">
          <h3 className="quest-card-title">{quest.title}</h3>
          <div className="quest-card-meta">
            <CategoryStamp category={quest.category} />
            <GoldCoin amount={xp} />
          </div>
        </div>
        {!quest.completed && (
          <WaxSeal initials="\u2713" size={36} onClick={() => onComplete(quest)} />
        )}
        {quest.completed && (
          <WaxSeal initials="\u2713" size={36} />
        )}
      </div>
      {quest.notes && <p className="quest-card-notes">{quest.notes}</p>}
      {quest.dueDate && (
        <p className="quest-card-due">
          Before the {new Date(quest.dueDate).toLocaleDateString('en-US', { month: 'long', day: 'numeric' })} moon
        </p>
      )}
    </ParchmentCard>
  );
}
