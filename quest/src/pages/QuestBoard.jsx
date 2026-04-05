import { useState } from 'react';
import QuestCard from '../components/QuestCard.jsx';
import AddQuestSheet from '../components/AddQuestSheet.jsx';
import CompletionOverlay from '../components/CompletionOverlay.jsx';
import WaxSeal from '../components/WaxSeal.jsx';
import { createQuest, DifficultyRank } from '../models/types.js';
import { xpForRank, getLevel, getTitle } from '../store/xpEngine.js';
import { rollReward } from '../store/rewardEngine.js';
import './QuestBoard.css';

export default function QuestBoard({ quests, setQuests, profile, setProfile, rewards }) {
  const [showAdd, setShowAdd] = useState(false);
  const [completion, setCompletion] = useState(null);

  const active = quests.filter(q => !q.completed);
  const completed = quests.filter(q => q.completed);
  const [showCompleted, setShowCompleted] = useState(false);

  function handleAdd(data) {
    const quest = createQuest(data);
    setQuests(prev => [quest, ...prev]);
  }

  function handleComplete(quest) {
    const xp = xpForRank(quest.difficulty);
    const oldLevel = getLevel(profile.totalXP);
    const newTotalXP = profile.totalXP + xp;
    const newLevel = getLevel(newTotalXP);
    const levelUp = newLevel > oldLevel;

    setQuests(prev =>
      prev.map(q =>
        q.id === quest.id
          ? { ...q, completed: true, completedAt: new Date().toISOString() }
          : q
      )
    );

    setProfile(prev => ({ ...prev, totalXP: newTotalXP }));

    const rewardResult = rollReward(rewards);

    setCompletion({
      quest: { ...quest, xp },
      reward: rewardResult,
      levelUp,
      newLevel,
      newTitle: getTitle(newLevel),
    });
  }

  return (
    <div className="quest-board">
      <div className="quest-board-header">
        <h1 className="quest-board-title">Quest Board</h1>
        <button className="quest-add-fab" onClick={() => setShowAdd(true)} title="New Quest">
          <WaxSeal initials="+" size={48} onClick={() => setShowAdd(true)} />
        </button>
      </div>

      <section className="quest-section">
        <h2 className="section-label">Active Quests ({active.length})</h2>
        <div className="quest-list">
          {active.length === 0 && (
            <p className="quest-empty">No active quests. The realm is at peace... for now.</p>
          )}
          {active.map(quest => (
            <QuestCard key={quest.id} quest={quest} onComplete={handleComplete} />
          ))}
        </div>
      </section>

      {completed.length > 0 && (
        <section className="quest-section">
          <button
            className="section-label quest-completed-toggle"
            onClick={() => setShowCompleted(v => !v)}
          >
            Completed Quests ({completed.length}) {showCompleted ? '\u25B2' : '\u25BC'}
          </button>
          {showCompleted && (
            <div className="quest-list">
              {completed.map(quest => (
                <QuestCard key={quest.id} quest={quest} onComplete={() => {}} />
              ))}
            </div>
          )}
        </section>
      )}

      {showAdd && <AddQuestSheet onAdd={handleAdd} onClose={() => setShowAdd(false)} />}

      {completion && (
        <CompletionOverlay
          quest={completion.quest}
          reward={completion.reward}
          levelUp={completion.levelUp}
          newLevel={completion.newLevel}
          newTitle={completion.newTitle}
          onDismiss={() => setCompletion(null)}
        />
      )}
    </div>
  );
}
