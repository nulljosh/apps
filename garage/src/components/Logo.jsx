export default function Logo({ size = 48 }) {
  return (
    <svg width={size} height={size * 0.65} viewBox="0 0 320 208" xmlns="http://www.w3.org/2000/svg">
      {/* Outer grey ellipse */}
      <ellipse cx="160" cy="104" rx="158" ry="102" fill="#58595b" />
      {/* Inner teal ellipse */}
      <ellipse cx="160" cy="100" rx="130" ry="78" fill="#2d6b6b" />
      {/* Top arc text: Great Service / Great Savings */}
      <path id="topArc" d="M 55,100 A 120,75 0 0,1 265,100" fill="none" />
      <text fill="#fff" fontSize="14" fontFamily="-apple-system, sans-serif" fontWeight="400" letterSpacing="1">
        <textPath href="#topArc" startOffset="50%" textAnchor="middle">
          Great Service &#9733; Great Savings
        </textPath>
      </text>
      {/* Main text line 1 */}
      <text x="160" y="108" textAnchor="middle" fill="#fff" fontSize="32" fontFamily="Georgia, 'Times New Roman', serif" fontWeight="700" fontStyle="italic">
        Best Choice
      </text>
      {/* Main text line 2 */}
      <text x="160" y="140" textAnchor="middle" fill="#fff" fontSize="26" fontFamily="Georgia, 'Times New Roman', serif" fontWeight="700" fontStyle="italic">
        Garage Doors
      </text>
      {/* Stars row */}
      <text x="160" y="170" textAnchor="middle" fill="#fff" fontSize="12" letterSpacing="6">
        &#9733; &#9733; &#9733; &#9733; &#9733; &#9733; &#9733;
      </text>
      {/* Website */}
      <text x="160" y="190" textAnchor="middle" fill="#fff" fontSize="11" fontFamily="-apple-system, sans-serif" fontWeight="400">
        bcgaragedoors.ca
      </text>
    </svg>
  );
}
