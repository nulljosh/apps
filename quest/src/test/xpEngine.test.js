import { describe, it, expect } from 'vitest';
import { xpForRank, getLevel, getTitle, xpProgress } from '../store/xpEngine.js';

describe('xpForRank', () => {
  it('returns correct XP for each rank', () => {
    expect(xpForRank('F')).toBe(10);
    expect(xpForRank('D')).toBe(25);
    expect(xpForRank('C')).toBe(50);
    expect(xpForRank('B')).toBe(100);
    expect(xpForRank('A')).toBe(200);
    expect(xpForRank('S')).toBe(500);
  });

  it('returns 0 for unknown rank', () => {
    expect(xpForRank('Z')).toBe(0);
  });
});

describe('getLevel', () => {
  it('returns 0 for 0 XP', () => {
    expect(getLevel(0)).toBe(0);
  });

  it('returns 1 at 50 XP', () => {
    expect(getLevel(50)).toBe(1);
  });

  it('returns 2 at 200 XP', () => {
    expect(getLevel(200)).toBe(2);
  });

  it('returns 3 at 450 XP', () => {
    expect(getLevel(450)).toBe(3);
  });

  it('returns 10 at 5000 XP', () => {
    expect(getLevel(5000)).toBe(10);
  });
});

describe('getTitle', () => {
  it('returns Squire for level 0', () => {
    expect(getTitle(0)).toBe('Squire');
  });

  it('returns Knight for level 1', () => {
    expect(getTitle(1)).toBe('Knight');
  });

  it('returns Mythic for high levels', () => {
    expect(getTitle(100)).toBe('Mythic');
  });
});

describe('xpProgress', () => {
  it('returns correct progress for 0 XP', () => {
    const p = xpProgress(0);
    expect(p.level).toBe(0);
    expect(p.progress).toBe(0);
    expect(p.needed).toBe(50);
    expect(p.percent).toBe(0);
  });

  it('returns correct progress mid-level', () => {
    const p = xpProgress(75);
    expect(p.level).toBe(1);
    expect(p.progress).toBe(25);
    expect(p.needed).toBe(150);
  });
});
