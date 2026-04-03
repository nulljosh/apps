export default function Logo({ size = 48 }) {
  const w = size;
  const h = size * 0.65;
  return (
    <svg width={w} height={h} viewBox="0 0 200 130" xmlns="http://www.w3.org/2000/svg">
      {/* Outer grey ellipse */}
      <ellipse cx="100" cy="65" rx="99" ry="64" fill="#58595b" />
      {/* Inner teal ellipse */}
      <ellipse cx="100" cy="62" rx="82" ry="50" fill="#2d6b6b" />
      {/* Best Choice */}
      <text x="100" y="62" textAnchor="middle" fill="#fff" fontSize="22" fontFamily="Georgia, serif" fontWeight="700" fontStyle="italic">Best Choice</text>
      {/* Garage Doors */}
      <text x="100" y="84" textAnchor="middle" fill="#fff" fontSize="16" fontFamily="Georgia, serif" fontWeight="700" fontStyle="italic">Garage Doors</text>
      {/* Stars */}
      <text x="100" y="118" textAnchor="middle" fill="#fff" fontSize="8" letterSpacing="3">&#9733; &#9733; &#9733; &#9733; &#9733;</text>
    </svg>
  );
}
