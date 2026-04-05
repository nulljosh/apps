export const DifficultyRank = {
  F: { label: 'F', xp: 10 },
  D: { label: 'D', xp: 25 },
  C: { label: 'C', xp: 50 },
  B: { label: 'B', xp: 100 },
  A: { label: 'A', xp: 200 },
  S: { label: 'S', xp: 500 },
};

export const QuestCategory = {
  fitness: { label: 'Fitness', className: 'Warrior', color: '#c0392b' },
  study: { label: 'Study', className: 'Mage', color: '#2d4a8b' },
  work: { label: 'Work', className: 'Rogue', color: '#4a6741' },
  personal: { label: 'Personal', className: 'Ranger', color: '#8b6914' },
  creative: { label: 'Creative', className: 'Bard', color: '#6b3fa0' },
  errand: { label: 'Errand', className: 'Merchant', color: '#8b4513' },
};

export const LevelTitles = [
  'Squire',
  'Knight',
  'Champion',
  'Hero',
  'Legend',
  'Mythic',
];

export function createQuest({ title, difficulty = 'C', category = 'personal', notes = '', dueDate = null }) {
  return {
    id: crypto.randomUUID(),
    title,
    difficulty,
    category,
    notes,
    dueDate,
    completed: false,
    completedAt: null,
    createdAt: new Date().toISOString(),
  };
}

export function createReward(text) {
  return {
    id: crypto.randomUUID(),
    text,
    active: true,
  };
}

export function createProfile(name = 'Adventurer') {
  return {
    name,
    totalXP: 0,
    currentStreak: 0,
    lastActiveDate: null,
  };
}
