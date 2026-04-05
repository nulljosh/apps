import './ParchmentCard.css';

export default function ParchmentCard({ children, className = '', animate = false }) {
  return (
    <div className={`parchment-card paper-grain ${animate ? 'animate-fade-up' : ''} ${className}`}>
      {children}
    </div>
  );
}
