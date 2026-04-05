import { describe, it, expect, beforeEach } from 'vitest';
import { loadQuests, saveQuests, loadProfile, saveProfile, updateStreak, exportTome, importTome } from '../store/questStore.js';

beforeEach(() => {
  localStorage.clear();
});

describe('quest persistence', () => {
  it('returns empty array when no quests saved', () => {
    expect(loadQuests()).toEqual([]);
  });

  it('round-trips quests', () => {
    const quests = [{ id: '1', title: 'Test', completed: false }];
    saveQuests(quests);
    expect(loadQuests()).toEqual(quests);
  });
});

describe('profile persistence', () => {
  it('returns default profile when none saved', () => {
    const p = loadProfile();
    expect(p.name).toBe('Adventurer');
    expect(p.totalXP).toBe(0);
  });

  it('round-trips profile', () => {
    const profile = { name: 'Hero', totalXP: 500, currentStreak: 3, lastActiveDate: '2026-04-04' };
    saveProfile(profile);
    expect(loadProfile()).toEqual(profile);
  });
});

describe('updateStreak', () => {
  it('starts streak at 1 for first activity', () => {
    const p = updateStreak({ name: 'X', totalXP: 0, currentStreak: 0, lastActiveDate: null });
    expect(p.currentStreak).toBe(1);
    expect(p.lastActiveDate).toBe(new Date().toISOString().slice(0, 10));
  });

  it('does not change streak if already active today', () => {
    const today = new Date().toISOString().slice(0, 10);
    const p = updateStreak({ name: 'X', totalXP: 0, currentStreak: 5, lastActiveDate: today });
    expect(p.currentStreak).toBe(5);
  });
});

describe('export/import', () => {
  it('exports and imports tome', () => {
    saveQuests([{ id: '1', title: 'Test' }]);
    saveProfile({ name: 'Hero', totalXP: 100, currentStreak: 1, lastActiveDate: '2026-04-04' });
    const json = exportTome();
    localStorage.clear();
    importTome(json);
    expect(loadQuests()).toEqual([{ id: '1', title: 'Test' }]);
    expect(loadProfile().name).toBe('Hero');
  });
});
