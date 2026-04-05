import { describe, it, expect, vi } from 'vitest';
import { rollReward } from '../store/rewardEngine.js';

describe('rollReward', () => {
  it('returns not granted with empty rewards', () => {
    const result = rollReward([]);
    expect(result.granted).toBe(false);
    expect(result.reward).toBeNull();
  });

  it('grants a reward when random < 0.8', () => {
    vi.spyOn(Math, 'random').mockReturnValue(0.5);
    const rewards = [{ id: '1', text: 'Coffee break', active: true }];
    const result = rollReward(rewards);
    expect(result.granted).toBe(true);
    expect(result.reward.text).toBe('Coffee break');
    vi.restoreAllMocks();
  });

  it('denies reward when random > 0.8', () => {
    vi.spyOn(Math, 'random').mockReturnValue(0.9);
    const rewards = [{ id: '1', text: 'Coffee break', active: true }];
    const result = rollReward(rewards);
    expect(result.granted).toBe(false);
    vi.restoreAllMocks();
  });

  it('skips inactive rewards', () => {
    vi.spyOn(Math, 'random').mockReturnValue(0.1);
    const rewards = [
      { id: '1', text: 'Inactive', active: false },
      { id: '2', text: 'Active', active: true },
    ];
    const result = rollReward(rewards);
    expect(result.granted).toBe(true);
    expect(result.reward.text).toBe('Active');
    vi.restoreAllMocks();
  });
});
