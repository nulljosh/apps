import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!url || !key) {
  console.warn('[pulse] Supabase not configured -- running in demo mode');
}

export const supabase = (url && key) ? createClient(url, key) : null;
export const isDemoMode = !supabase;

export async function getSession() {
  if (!supabase) return null;
  const { data } = await supabase.auth.getSession();
  return data?.session ?? null;
}

export async function getUser() {
  const session = await getSession();
  return session?.user ?? null;
}

export async function signUp(email, password, username) {
  if (!supabase) throw new Error('Supabase not configured');
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { username } }
  });
  if (error) throw error;
  return data;
}

export async function signIn(email, password) {
  if (!supabase) throw new Error('Supabase not configured');
  const { data, error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) throw error;
  return data;
}

export async function signOut() {
  if (!supabase) return;
  const { error } = await supabase.auth.signOut();
  if (error) throw error;
}

export async function fetchSightings(center, radiusKm = 1.5) {
  if (!supabase) return null;

  const degLat = radiusKm / 111;
  const degLng = radiusKm / (111 * Math.cos(center.lat * Math.PI / 180));

  const { data, error } = await supabase
    .from('sightings')
    .select('*, profiles(username, avatar_color, clout)')
    .gte('lat', center.lat - degLat)
    .lte('lat', center.lat + degLat)
    .gte('lng', center.lng - degLng)
    .lte('lng', center.lng + degLng)
    .gt('expires_at', new Date().toISOString())
    .order('created_at', { ascending: false })
    .limit(30);

  if (error) { console.error('[pulse] fetch sightings:', error); return null; }
  return data;
}

export async function submitSighting({ lat, lng, vibe, description }) {
  if (!supabase) throw new Error('Supabase not configured');

  const user = await getUser();
  if (!user) throw new Error('Not authenticated');

  const { data: profile } = await supabase
    .from('profiles')
    .select('username')
    .eq('id', user.id)
    .single();

  const { data, error } = await supabase
    .from('sightings')
    .insert({
      user_id: user.id,
      username: profile?.username || 'anon',
      lat, lng, vibe,
      description: description || '',
    })
    .select()
    .single();

  if (error) throw error;

  await supabase.rpc('award_drop', { p_user_id: user.id }).catch(() => {});

  return data;
}

export async function deleteSighting(id) {
  if (!supabase) throw new Error('Supabase not configured');
  const { error } = await supabase.from('sightings').delete().eq('id', id);
  if (error) throw error;
}

export async function upvoteSighting(id) {
  if (!supabase) throw new Error('Supabase not configured');
  const { error } = await supabase.rpc('upvote_sighting', { sighting_id: id });
  if (error) throw error;
}

export function onAuthChange(callback) {
  if (!supabase) return () => {};
  const { data } = supabase.auth.onAuthStateChange((_event, session) => {
    callback(session);
  });
  return data.subscription.unsubscribe;
}

export async function fetchProfile() {
  if (!supabase) return null;
  const user = await getUser();
  if (!user) return null;
  const { data } = await supabase
    .from('profiles')
    .select('username, avatar_color, clout, beacon_on, beacon_mode, tokens, live_hours')
    .eq('id', user.id)
    .single();
  return data;
}

export async function updateBeacon({ on, mode, lat = null, lng = null }) {
  if (!supabase) return;
  const { error } = await supabase.rpc('update_beacon', {
    p_on: on, p_mode: mode, p_lat: lat, p_lng: lng,
  });
  if (error) throw error;
}

export async function fetchBroadcasters(center) {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc('nearby_broadcasters', {
    p_lat: center.lat, p_lng: center.lng,
  });
  if (error) { console.error('[pulse] broadcasters:', error); return null; }
  return data;
}

export async function fetchLeaderboard(limit = 10) {
  if (!supabase) return null;
  const { data, error } = await supabase.rpc('leaderboard', { p_limit: limit });
  if (error) { console.error('[pulse] leaderboard:', error); return null; }
  return data;
}

export async function saveLiveHours(hours) {
  if (!supabase) return;
  await supabase.rpc('save_live_hours', { p_hours: hours }).catch(() => {});
}

export function subscribeToDrops(center, callback) {
  if (!supabase) return null;
  const degLat = 1.5 / 111;
  const degLng = 1.5 / (111 * Math.cos(center.lat * Math.PI / 180));
  return supabase
    .channel('drops')
    .on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'sightings' }, payload => {
      const s = payload.new;
      if (Math.abs(s.lat - center.lat) < degLat && Math.abs(s.lng - center.lng) < degLng) {
        callback(s);
      }
    })
    .subscribe();
}
