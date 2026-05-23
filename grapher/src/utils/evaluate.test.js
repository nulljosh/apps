import { describe, it, expect } from 'vitest';
import { evaluate } from './evaluate.js';

describe('evaluate', () => {
  it('returns null fn for empty string', () => {
    const { fn, error } = evaluate('');
    expect(fn).toBeNull();
    expect(error).toBeNull();
  });

  it('strips y = prefix', () => {
    const { fn, error } = evaluate('y = x');
    expect(error).toBeNull();
    expect(fn(3)).toBe(3);
  });

  it('strips y= prefix without spaces', () => {
    const { fn } = evaluate('y=x');
    expect(fn(5)).toBe(5);
  });

  it('evaluates quadratic', () => {
    const { fn, error } = evaluate('x^2');
    expect(error).toBeNull();
    expect(fn(3)).toBe(9);
    expect(fn(-2)).toBe(4);
  });

  it('evaluates linear expression', () => {
    const { fn } = evaluate('2*x + 1');
    expect(fn(0)).toBe(1);
    expect(fn(4)).toBe(9);
  });

  it('evaluates constants', () => {
    const { fn } = evaluate('42');
    expect(fn(0)).toBe(42);
    expect(fn(999)).toBe(42);
  });

  it('returns error for invalid expression', () => {
    const { fn, error } = evaluate('!!invalid');
    expect(fn).toBeNull();
    expect(typeof error).toBe('string');
    expect(error.length).toBeGreaterThan(0);
  });

  it('handles whitespace-only input', () => {
    const { fn, error } = evaluate('   ');
    expect(fn).toBeNull();
    expect(error).toBeNull();
  });
});
