import { DifficultyRank, LevelTitles } from '../models/types.js';

export function xpForRank(rank) {
  return DifficultyRank[rank]?.xp ?? 0;
}

export function getLevel(totalXP) {
  return Math.floor(Math.sqrt(totalXP / 50));
}

export function getTitle(level) {
  const index = Math.min(Math.max(level, 0), LevelTitles.length - 1);
  return LevelTitles[index];
}

export function xpForNextLevel(currentLevel) {
  const next = currentLevel + 1;
  return next * next * 50;
}

export function xpProgress(totalXP) {
  const level = getLevel(totalXP);
  const currentThreshold = level * level * 50;
  const nextThreshold = (level + 1) * (level + 1) * 50;
  const progress = totalXP - currentThreshold;
  const needed = nextThreshold - currentThreshold;
  return { level, progress, needed, percent: needed > 0 ? (progress / needed) * 100 : 0 };
}
