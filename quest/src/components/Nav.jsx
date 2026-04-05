import './Nav.css';

const tabs = [
  { id: 'quests', label: 'Quests', icon: '\u2694' },
  { id: 'character', label: 'Character', icon: '\u2655' },
  { id: 'settings', label: 'Settings', icon: '\u2699' },
];

export default function Nav({ active, onNavigate }) {
  return (
    <nav className="quest-nav leather-bg">
      {tabs.map(tab => (
        <button
          key={tab.id}
          className={`quest-nav-tab ${active === tab.id ? 'active' : ''}`}
          onClick={() => onNavigate(tab.id)}
        >
          <span className="quest-nav-icon">{tab.icon}</span>
          <span className="quest-nav-label">{tab.label}</span>
        </button>
      ))}
    </nav>
  );
}
