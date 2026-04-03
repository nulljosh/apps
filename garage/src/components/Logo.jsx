export default function Logo({ size = 48 }) {
  const w = size * 1.55;
  const h = size;
  return (
    <svg width={w} height={h} viewBox="0 0 310 200" xmlns="http://www.w3.org/2000/svg">
      <ellipse cx="155" cy="100" rx="154" ry="99" fill="#58595b" />
      <ellipse cx="155" cy="96" rx="126" ry="74" fill="#2d6b6b" />
      <text x="155" y="68" textAnchor="middle" fill="rgba(255,255,255,0.7)" fontSize="15" fontFamily="-apple-system, sans-serif" fontWeight="400" letterSpacing="1.5">Great Service &#9733; Great Savings</text>
      <text x="155" y="102" textAnchor="middle" fill="#fff" fontSize="34" fontFamily="Georgia, serif" fontWeight="700" fontStyle="italic">Best Choice</text>
      <text x="155" y="132" textAnchor="middle" fill="#fff" fontSize="24" fontFamily="Georgia, serif" fontWeight="700" fontStyle="italic">Garage Doors</text>
      <text x="155" y="160" textAnchor="middle" fill="rgba(255,255,255,0.5)" fontSize="10" letterSpacing="4">&#9733; &#9733; &#9733; &#9733; &#9733; &#9733; &#9733;</text>
      <text x="155" y="182" textAnchor="middle" fill="rgba(255,255,255,0.6)" fontSize="12" fontFamily="-apple-system, sans-serif" fontWeight="400">bcgaragedoors.ca</text>
    </svg>
  );
}
