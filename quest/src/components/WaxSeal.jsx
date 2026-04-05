import './WaxSeal.css';

export default function WaxSeal({ initials = '?', size = 48, animate = false, onClick }) {
  return (
    <div
      className={`wax-seal ${animate ? 'animate-seal' : ''}`}
      style={{ width: size, height: size, fontSize: size * 0.35 }}
      onClick={onClick}
      role={onClick ? 'button' : undefined}
      tabIndex={onClick ? 0 : undefined}
    >
      <span className="wax-seal-text">{initials}</span>
    </div>
  );
}
