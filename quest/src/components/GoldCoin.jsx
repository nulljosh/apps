import './GoldCoin.css';

export default function GoldCoin({ amount, animate = false, style }) {
  return (
    <span className={`gold-coin ${animate ? 'animate-coin' : ''}`} style={style}>
      <span className="gold-coin-icon">&#9733;</span>
      <span className="gold-coin-amount">{amount}</span>
    </span>
  );
}
