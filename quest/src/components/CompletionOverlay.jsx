import { useEffect } from 'react';
import WaxSeal from './WaxSeal.jsx';
import GoldCoin from './GoldCoin.jsx';
import './CompletionOverlay.css';

export default function CompletionOverlay({ quest, reward, levelUp, newLevel, newTitle, onDismiss }) {
  useEffect(() => {
    const timer = setTimeout(onDismiss, 5000);
    return () => clearTimeout(timer);
  }, [onDismiss]);

  return (
    <div className="completion-overlay" onClick={onDismiss}>
      <div className="completion-content animate-unfurl paper-grain" onClick={e => e.stopPropagation()}>
        {levelUp ? (
          <div className="level-up-display">
            <WaxSeal initials={newLevel} size={80} />
            <h2 className="level-up-title">Level Up!</h2>
            <p className="level-up-rank">{newTitle}</p>
            <p className="level-up-sub">You have reached Level {newLevel}</p>
          </div>
        ) : (
          <div className="reward-display">
            <WaxSeal initials="\u2713" size={56} animate />
            <h3 className="reward-quest-name">{quest?.title}</h3>
            <GoldCoin amount={`+${quest?.xp || 0} XP`} />
            <div className="reward-divider">
              <img src="/textures/divider.svg" alt="" />
            </div>
            {reward?.granted ? (
              <div className="reward-boon">
                <p className="section-label">The fates bestow a boon</p>
                <p className="reward-text">{reward.reward.text}</p>
              </div>
            ) : (
              <div className="reward-none">
                <p className="reward-text-none">The gods demand more... No reward this time.</p>
              </div>
            )}
          </div>
        )}
        <button className="completion-dismiss" onClick={onDismiss}>Continue</button>
      </div>
    </div>
  );
}
