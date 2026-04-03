export default function Logo({ size = 44 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <rect width="100" height="100" rx="22" fill="#58595b" />
      <rect x="4" y="2" width="92" height="92" rx="18" fill="#2d6b6b" />
      <text x="50" y="42" textAnchor="middle" fill="#fff" fontSize="16" fontFamily="Georgia, serif" fontWeight="700" fontStyle="italic">Best Choice</text>
      <text x="50" y="60" textAnchor="middle" fill="#fff" fontSize="11.5" fontFamily="Georgia, serif" fontWeight="700" fontStyle="italic">Garage Doors</text>
      <text x="50" y="78" textAnchor="middle" fill="rgba(255,255,255,0.4)" fontSize="5" letterSpacing="2">&#9733; &#9733; &#9733; &#9733; &#9733;</text>
    </svg>
  );
}
