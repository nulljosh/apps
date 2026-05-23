import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!url || !key) {
  console.warn('[bhaddie] Supabase not configured -- running in demo mode');
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

  if (error) { console.error('[bhaddie] fetch sightings:', error); return null; }
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
