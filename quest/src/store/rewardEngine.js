const REWARD_CHANCE = 0.8;

export function rollReward(rewards) {
  const active = rewards.filter(r => r.active);
  if (active.length === 0) return { granted: false, reward: null };

  if (Math.random() > REWARD_CHANCE) {
    return { granted: false, reward: null };
  }

  const picked = active[Math.floor(Math.random() * active.length)];
  return { granted: true, reward: picked };
}
