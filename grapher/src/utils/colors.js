export const COLORS = [
  '#0071e3',
  '#ff453a',
  '#30d158',
  '#ffd60a',
  '#bf5af2',
  '#ff9f0a',
  '#64d2ff',
  '#ff375f',
];

export function colorAt(index) {
  return COLORS[index % COLORS.length];
}
