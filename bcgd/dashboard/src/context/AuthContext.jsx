import { createContext, useContext, useState, useEffect } from 'react';
import { supabase, isConfigured } from '../lib/supabase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [orgId, setOrgId] = useState(null);
  const [loading, setLoading] = useState(isConfigured);

  // Track the auth session.
  useEffect(() => {
    if (!supabase) { setLoading(false); return; }
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null);
    });
    return () => subscription.unsubscribe();
  }, []);

  // Resolve the caller's org from their profile (used to stamp org_id on inserts).
  useEffect(() => {
    if (!supabase || !user) { setOrgId(null); return; }
    supabase.from('profiles').select('org_id').eq('id', user.id).single()
      .then(({ data }) => setOrgId(data?.org_id ?? null));
  }, [user]);

  async function signOut() {
    if (supabase) await supabase.auth.signOut();
  }

  return (
    <AuthContext.Provider value={{ user, orgId, loading, signOut, isConfigured }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}
