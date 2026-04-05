import { createProfile } from '../models/types.js';

const KEYS = {
  quests: 'quest:quests',
  profile: 'quest:profile',
  rewards: 'quest:rewards',
};

function load(key, fallback) {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch {
    return fallback;
  }
}

function save(key, data) {
  localStorage.setItem(key, JSON.stringify(data));
}

export function loadQuests() {
  return load(KEYS.quests, []);
}

export function saveQuests(quests) {
  save(KEYS.quests, quests);
}

export function loadProfile() {
  return load(KEYS.profile, createProfile());
}

export function saveProfile(profile) {
  save(KEYS.profile, profile);
}

export function loadRewards() {
  return load(KEYS.rewards, []);
}

export function saveRewards(rewards) {
  save(KEYS.rewards, rewards);
}

export function updateStreak(profile) {
  const today = new Date().toISOString().slice(0, 10);
  const last = profile.lastActiveDate;

  if (last === today) return profile;

  const yesterday = new Date(Date.now() - 86400000).toISOString().slice(0, 10);
  const newStreak = last === yesterday ? profile.currentStreak + 1 : 1;

  return {
    ...profile,
    currentStreak: newStreak,
    lastActiveDate: today,
  };
}

export function exportTome() {
  return JSON.stringify({
    quests: loadQuests(),
    profile: loadProfile(),
    rewards: loadRewards(),
    exportedAt: new Date().toISOString(),
  }, null, 2);
}

export function importTome(json) {
  const data = JSON.parse(json);
  if (data.quests) saveQuests(data.quests);
  if (data.profile) saveProfile(data.profile);
  if (data.rewards) saveRewards(data.rewards);
  return data;
}
