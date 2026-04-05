import './CandleFlicker.css';

export default function CandleFlicker({ streak }) {
  const height = Math.min(24 + streak * 4, 60);

  return (
    <div className="candle-container">
      <div className="candle-flame animate-candle" style={{ height }} />
      <div className="candle-body" />
      <span className="candle-streak">{streak}</span>
    </div>
  );
}
