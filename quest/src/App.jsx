import { useState, useEffect, useCallback } from 'react';
import QuestBoard from './pages/QuestBoard.jsx';
import CharacterSheet from './pages/CharacterSheet.jsx';
import Settings from './pages/Settings.jsx';
import Nav from './components/Nav.jsx';
import { loadQuests, saveQuests, loadProfile, saveProfile, loadRewards, saveRewards, updateStreak } from './store/questStore.js';
import './App.css';

export default function App() {
  const [view, setView] = useState('quests');
  const [quests, setQuests] = useState(() => loadQuests());
  const [profile, setProfile] = useState(() => {
    const p = loadProfile();
    return updateStreak(p);
  });
  const [rewards, setRewards] = useState(() => loadRewards());

  useEffect(() => { saveQuests(quests); }, [quests]);
  useEffect(() => { saveProfile(profile); }, [profile]);
  useEffect(() => { saveRewards(rewards); }, [rewards]);

  const completeQuest = useCallback((updater) => {
    setQuests(updater);
  }, []);

  return (
    <div className="app leather-bg vignette">
      {/* Desktop sidebar */}
      <aside className="app-sidebar">
        <div className="sidebar-nav">
          <button className={`sidebar-tab ${view === 'quests' ? 'active' : ''}`} onClick={() => setView('quests')}>
            Quest Board
          </button>
          <button className={`sidebar-tab ${view === 'character' ? 'active' : ''}`} onClick={() => setView('character')}>
            Character
          </button>
          <button className={`sidebar-tab ${view === 'settings' ? 'active' : ''}`} onClick={() => setView('settings')}>
            Settings
          </button>
        </div>
        <div className="sidebar-character">
          <CharacterSheet profile={profile} setProfile={setProfile} quests={quests} />
        </div>
      </aside>

      {/* Main content */}
      <main className="app-main">
        {view === 'quests' && (
          <QuestBoard
            quests={quests}
            setQuests={setQuests}
            profile={profile}
            setProfile={setProfile}
            rewards={rewards}
          />
        )}
        {view === 'character' && (
          <div className="mobile-only">
            <CharacterSheet profile={profile} setProfile={setProfile} quests={quests} />
          </div>
        )}
        {view === 'settings' && (
          <Settings rewards={rewards} setRewards={setRewards} />
        )}
      </main>

      {/* Mobile nav */}
      <Nav active={view} onNavigate={setView} />
    </div>
  );
}
