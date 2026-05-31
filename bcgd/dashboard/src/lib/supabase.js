import { createClient } from '@supabase/supabase-js';

// Reads Vite env vars. When unset (e.g. local checkout without keys), the app
// runs in "not configured" mode and shows a setup notice instead of crashing.
const url = import.meta.env.VITE_SUPABASE_URL;
const key = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const isConfigured = Boolean(url && key);

if (!isConfigured) {
  console.warn('[bcgd] Supabase not configured — set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY');
}

export const supabase = isConfigured ? createClient(url, key) : null;
