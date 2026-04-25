import { describe, it, expect } from 'vitest';

// Auth validation logic (mirrors index.html auth form validation)
function validateSignUp(email, password, username) {
  const errors = [];
  if (!email || !email.trim()) errors.push('Email required');
  else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) errors.push('Invalid email');
  if (!password) errors.push('Password required');
  else if (password.length < 6) errors.push('Password must be 6+ characters');
  if (!username || !username.trim()) errors.push('Username required');
  else {
    if (username.length < 3) errors.push('Username must be 3+ characters');
    if (!/^[a-zA-Z0-9._]+$/.test(username)) errors.push('Username: letters, numbers, dots, underscores only');
  }
  return errors;
}

function validateSignIn(email, password) {
  const errors = [];
  if (!email || !email.trim()) errors.push('Email required');
  if (!password) errors.push('Password required');
  else if (password.length < 6) errors.push('Password must be 6+ characters');
  return errors;
}

function validateSighting(lat, lng, vibe) {
  const errors = [];
  const validVibes = ['gym', 'alt', 'artsy', 'downtown', 'night-owl'];
  if (typeof lat !== 'number' || lat < -90 || lat > 90) errors.push('Invalid latitude');
  if (typeof lng !== 'number' || lng < -180 || lng > 180) errors.push('Invalid longitude');
  if (!validVibes.includes(vibe)) errors.push('Invalid vibe');
  return errors;
}

describe('signup validation', () => {
  it('passes with valid data', () => {
    expect(validateSignUp('a@b.com', 'pass123', 'user1')).toEqual([]);
  });

  it('rejects empty email', () => {
    expect(validateSignUp('', 'pass123', 'user1')).toContain('Email required');
  });

  it('rejects invalid email', () => {
    expect(validateSignUp('notanemail', 'pass123', 'user1')).toContain('Invalid email');
  });

  it('rejects short password', () => {
    expect(validateSignUp('a@b.com', '123', 'user1')).toContain('Password must be 6+ characters');
  });

  it('rejects empty password', () => {
    expect(validateSignUp('a@b.com', '', 'user1')).toContain('Password required');
  });

  it('rejects empty username', () => {
    expect(validateSignUp('a@b.com', 'pass123', '')).toContain('Username required');
  });

  it('rejects short username', () => {
    expect(validateSignUp('a@b.com', 'pass123', 'ab')).toContain('Username must be 3+ characters');
  });

  it('rejects special chars in username', () => {
    expect(validateSignUp('a@b.com', 'pass123', 'user@name')).toContain('Username: letters, numbers, dots, underscores only');
  });

  it('allows dots and underscores in username', () => {
    expect(validateSignUp('a@b.com', 'pass123', 'user.name_1')).toEqual([]);
  });

  it('returns multiple errors at once', () => {
    const errors = validateSignUp('', '', '');
    expect(errors.length).toBeGreaterThanOrEqual(3);
  });
});

describe('signin validation', () => {
  it('passes with valid data', () => {
    expect(validateSignIn('a@b.com', 'pass123')).toEqual([]);
  });

  it('rejects empty fields', () => {
    expect(validateSignIn('', '')).toContain('Email required');
    expect(validateSignIn('', '')).toContain('Password required');
  });

  it('rejects short password', () => {
    expect(validateSignIn('a@b.com', '12')).toContain('Password must be 6+ characters');
  });
});

describe('sighting validation', () => {
  it('passes with valid coordinates and vibe', () => {
    expect(validateSighting(49.28, -123.12, 'gym')).toEqual([]);
  });

  it('rejects out-of-range latitude', () => {
    expect(validateSighting(95, -123.12, 'gym')).toContain('Invalid latitude');
    expect(validateSighting(-95, -123.12, 'gym')).toContain('Invalid latitude');
  });

  it('rejects out-of-range longitude', () => {
    expect(validateSighting(49.28, 200, 'gym')).toContain('Invalid longitude');
  });

  it('rejects invalid vibe', () => {
    expect(validateSighting(49.28, -123.12, 'invalid')).toContain('Invalid vibe');
  });

  it('rejects non-number coordinates', () => {
    expect(validateSighting('hello', -123.12, 'gym')).toContain('Invalid latitude');
  });

  it('accepts all valid vibes', () => {
    ['gym', 'alt', 'artsy', 'downtown', 'night-owl'].forEach(v => {
      expect(validateSighting(49.28, -123.12, v)).toEqual([]);
    });
  });

  it('accepts boundary coordinates', () => {
    expect(validateSighting(90, 180, 'gym')).toEqual([]);
    expect(validateSighting(-90, -180, 'gym')).toEqual([]);
    expect(validateSighting(0, 0, 'gym')).toEqual([]);
  });
});
