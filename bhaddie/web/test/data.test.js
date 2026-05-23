import { describe, it, expect } from 'vitest';

// Test the vibe color mapping and data generation logic
const VIBE_COLORS = {
  gym: '#ff2d78',
  alt: '#8b5cf6',
  artsy: '#06b6d4',
  downtown: '#f59e0b',
  'night-owl': '#10b981',
};

function vibeColor(vibes) { return VIBE_COLORS[vibes[0]] || '#8b5cf6'; }

const VENUE_VIBE_MAP = {
  fitness_centre: 'gym', gym: 'gym', sports_centre: 'gym',
  bar: 'alt', nightclub: 'alt', music_venue: 'alt',
  gallery: 'artsy', museum: 'artsy', arts_centre: 'artsy', theatre: 'artsy',
  cafe: 'downtown', restaurant: 'downtown', fast_food: 'downtown',
  pub: 'night-owl', lounge: 'night-owl', biergarten: 'night-owl',
};

function venueToVibe(tags) {
  for (const key of ['leisure', 'amenity', 'tourism']) {
    const val = tags[key];
    if (val && VENUE_VIBE_MAP[val]) return VENUE_VIBE_MAP[val];
  }
  return 'downtown';
}

const NAME_SUFFIXES = ['.x','.wav','fit','.dream','.vibes','.xo','.noir','.glow','.jpeg','.raw','.q','.png'];

function generateHandle(name) {
  if (!name) return 'anon' + NAME_SUFFIXES[Math.floor(Math.random() * NAME_SUFFIXES.length)];
  const base = name.toLowerCase().replace(/[^a-z0-9]/g, '').slice(0, 8);
  return base + NAME_SUFFIXES[Math.floor(Math.random() * NAME_SUFFIXES.length)];
}

describe('vibeColor', () => {
  it('maps gym to pink', () => {
    expect(vibeColor(['gym'])).toBe('#ff2d78');
  });

  it('maps alt to violet', () => {
    expect(vibeColor(['alt'])).toBe('#8b5cf6');
  });

  it('maps artsy to cyan', () => {
    expect(vibeColor(['artsy'])).toBe('#06b6d4');
  });

  it('maps downtown to amber', () => {
    expect(vibeColor(['downtown'])).toBe('#f59e0b');
  });

  it('maps night-owl to green', () => {
    expect(vibeColor(['night-owl'])).toBe('#10b981');
  });

  it('uses first vibe for multi-vibe arrays', () => {
    expect(vibeColor(['gym', 'alt'])).toBe('#ff2d78');
    expect(vibeColor(['artsy', 'downtown'])).toBe('#06b6d4');
  });

  it('falls back to violet for unknown vibes', () => {
    expect(vibeColor(['unknown'])).toBe('#8b5cf6');
  });
});

describe('venueToVibe', () => {
  it('maps fitness_centre to gym', () => {
    expect(venueToVibe({ leisure: 'fitness_centre' })).toBe('gym');
  });

  it('maps bar to alt', () => {
    expect(venueToVibe({ amenity: 'bar' })).toBe('alt');
  });

  it('maps nightclub to alt', () => {
    expect(venueToVibe({ amenity: 'nightclub' })).toBe('alt');
  });

  it('maps gallery to artsy', () => {
    expect(venueToVibe({ tourism: 'gallery' })).toBe('artsy');
  });

  it('maps museum to artsy', () => {
    expect(venueToVibe({ tourism: 'museum' })).toBe('artsy');
  });

  it('maps cafe to downtown', () => {
    expect(venueToVibe({ amenity: 'cafe' })).toBe('downtown');
  });

  it('maps restaurant to downtown', () => {
    expect(venueToVibe({ amenity: 'restaurant' })).toBe('downtown');
  });

  it('maps pub to night-owl', () => {
    expect(venueToVibe({ amenity: 'pub' })).toBe('night-owl');
  });

  it('defaults to downtown for unknown tags', () => {
    expect(venueToVibe({ amenity: 'library' })).toBe('downtown');
    expect(venueToVibe({})).toBe('downtown');
  });

  it('prioritizes leisure over amenity', () => {
    expect(venueToVibe({ leisure: 'fitness_centre', amenity: 'bar' })).toBe('gym');
  });
});

describe('generateHandle', () => {
  it('generates handle from venue name', () => {
    const handle = generateHandle('Starbucks');
    expect(handle).toMatch(/^starbuck/);
    expect(NAME_SUFFIXES.some(s => handle.endsWith(s))).toBe(true);
  });

  it('strips non-alphanumeric characters', () => {
    const handle = generateHandle("Joe's Cafe & Bar");
    expect(handle).toMatch(/^joescafe/);
  });

  it('truncates long names to 8 chars', () => {
    const handle = generateHandle('Superlongrestaurantname');
    const base = handle.replace(/\.[a-z]+$/, '');
    expect(base.length).toBeLessThanOrEqual(8);
  });

  it('handles null/empty name', () => {
    const handle = generateHandle(null);
    expect(handle).toMatch(/^anon/);
  });

  it('handles empty string', () => {
    const handle = generateHandle('');
    expect(handle).toMatch(/^anon/);
  });
});

describe('vibe color completeness', () => {
  it('every vibe has a color', () => {
    const allVibes = ['gym', 'alt', 'artsy', 'downtown', 'night-owl'];
    allVibes.forEach(v => {
      expect(VIBE_COLORS[v]).toBeDefined();
      expect(VIBE_COLORS[v]).toMatch(/^#[0-9a-f]{6}$/);
    });
  });

  it('every venue type maps to a valid vibe', () => {
    const validVibes = new Set(['gym', 'alt', 'artsy', 'downtown', 'night-owl']);
    Object.values(VENUE_VIBE_MAP).forEach(vibe => {
      expect(validVibes.has(vibe)).toBe(true);
    });
  });
});

describe('edge cases', () => {
  it('vibeColor handles single-element array', () => {
    expect(() => vibeColor(['gym'])).not.toThrow();
  });

  it('vibeColor handles empty array gracefully', () => {
    expect(vibeColor([undefined])).toBe('#8b5cf6');
  });

  it('venueToVibe handles missing keys', () => {
    expect(venueToVibe({ name: 'Test' })).toBe('downtown');
  });
});
