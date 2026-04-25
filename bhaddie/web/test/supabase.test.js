import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock import.meta.env before importing
vi.stubEnv('VITE_SUPABASE_URL', '');
vi.stubEnv('VITE_SUPABASE_ANON_KEY', '');

describe('supabase module (demo mode)', () => {
  let mod;

  beforeEach(async () => {
    vi.resetModules();
    vi.stubEnv('VITE_SUPABASE_URL', '');
    vi.stubEnv('VITE_SUPABASE_ANON_KEY', '');
    mod = await import('../src/supabase.js');
  });

  it('runs in demo mode when env vars are empty', () => {
    expect(mod.isDemoMode).toBe(true);
    expect(mod.supabase).toBe(null);
  });

  it('getSession returns null in demo mode', async () => {
    const session = await mod.getSession();
    expect(session).toBe(null);
  });

  it('getUser returns null in demo mode', async () => {
    const user = await mod.getUser();
    expect(user).toBe(null);
  });

  it('signUp throws in demo mode', async () => {
    await expect(mod.signUp('a@b.com', 'pass123', 'user1'))
      .rejects.toThrow('Supabase not configured');
  });

  it('signIn throws in demo mode', async () => {
    await expect(mod.signIn('a@b.com', 'pass123'))
      .rejects.toThrow('Supabase not configured');
  });

  it('signOut resolves in demo mode', async () => {
    await expect(mod.signOut()).resolves.toBeUndefined();
  });

  it('fetchSightings returns null in demo mode', async () => {
    const result = await mod.fetchSightings({ lat: 49.28, lng: -123.12 });
    expect(result).toBe(null);
  });

  it('submitSighting throws in demo mode', async () => {
    await expect(mod.submitSighting({ lat: 49.28, lng: -123.12, vibe: 'gym' }))
      .rejects.toThrow('Supabase not configured');
  });

  it('deleteSighting throws in demo mode', async () => {
    await expect(mod.deleteSighting('some-id'))
      .rejects.toThrow('Supabase not configured');
  });

  it('upvoteSighting throws in demo mode', async () => {
    await expect(mod.upvoteSighting('some-id'))
      .rejects.toThrow('Supabase not configured');
  });

  it('onAuthChange returns noop unsubscribe in demo mode', () => {
    const unsub = mod.onAuthChange(() => {});
    expect(typeof unsub).toBe('function');
    expect(() => unsub()).not.toThrow();
  });
});

describe('supabase module (configured mode)', () => {
  it('creates client when env vars are set', async () => {
    vi.resetModules();
    vi.stubEnv('VITE_SUPABASE_URL', 'https://test.supabase.co');
    vi.stubEnv('VITE_SUPABASE_ANON_KEY', 'test-key-123');
    const mod = await import('../src/supabase.js');
    expect(mod.isDemoMode).toBe(false);
    expect(mod.supabase).not.toBe(null);
  });
});
