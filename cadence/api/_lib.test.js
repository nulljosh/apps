import { describe, it, expect } from 'vitest';
import { repoStatus } from './_lib.js';

describe('repoStatus', () => {
  it('returns active for commits > 20', () => {
    expect(repoStatus(21)).toBe('active');
    expect(repoStatus(100)).toBe('active');
  });

  it('returns stable for commits between 6 and 20', () => {
    expect(repoStatus(6)).toBe('stable');
    expect(repoStatus(20)).toBe('stable');
  });

  it('returns slow for commits 5 or fewer', () => {
    expect(repoStatus(5)).toBe('slow');
    expect(repoStatus(0)).toBe('slow');
  });

  it('boundary: exactly 20 is stable not active', () => {
    expect(repoStatus(20)).toBe('stable');
  });

  it('boundary: exactly 5 is slow not stable', () => {
    expect(repoStatus(5)).toBe('slow');
  });
});
