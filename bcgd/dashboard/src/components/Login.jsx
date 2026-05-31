import { useState } from 'react';
import { supabase, isConfigured } from '../lib/supabase';
import Logo from './Logo';

export default function Login() {
  const [mode, setMode] = useState('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(false);

  async function submit(e) {
    e.preventDefault();
    setError(''); setMessage(''); setLoading(true);
    try {
      if (mode === 'login') {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) setError(error.message);
      } else {
        const { error } = await supabase.auth.signUp({ email, password });
        if (error) setError(error.message);
        else setMessage('Account created. If email confirmation is on, confirm then sign in.');
      }
    } catch (err) {
      setError(err.message || 'Something went wrong');
    }
    setLoading(false);
  }

  return (
    <div className="login-screen">
      <div className="login-card glass-card animate__animated animate__fadeInUp">
        <div className="login-head">
          <Logo size={56} />
          <h1 className="app-title">Best Choice Garage Doors</h1>
          <span className="app-subtitle">Operations Dashboard</span>
        </div>

        {!isConfigured ? (
          <div className="login-notice">
            <strong>Backend not configured.</strong>
            <span>
              Set <code>VITE_SUPABASE_URL</code> and <code>VITE_SUPABASE_ANON_KEY</code> in
              {' '}<code>.env</code>, then restart the dev server. See the bcgd README for the
              full Supabase setup runbook.
            </span>
          </div>
        ) : (
          <>
            <div className="login-tabs">
              {['login', 'register'].map(t => (
                <button
                  key={t}
                  type="button"
                  className={`login-tab${mode === t ? ' active' : ''}`}
                  onClick={() => { setMode(t); setError(''); setMessage(''); }}
                >
                  {t === 'login' ? 'Sign in' : 'Register'}
                </button>
              ))}
            </div>

            <form onSubmit={submit} className="login-form">
              <input
                className="login-input"
                type="email"
                placeholder="Email"
                value={email}
                onChange={e => setEmail(e.target.value)}
                required
                autoComplete="email"
              />
              <input
                className="login-input"
                type="password"
                placeholder="Password"
                value={password}
                onChange={e => setPassword(e.target.value)}
                required
                minLength={6}
                autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
              />
              {error && <p className="login-error">{error}</p>}
              {message && <p className="login-message">{message}</p>}
              <button type="submit" className="btn btn-primary" disabled={loading}>
                {loading ? 'Loading…' : mode === 'login' ? 'Sign in' : 'Create account'}
              </button>
            </form>
          </>
        )}
      </div>
    </div>
  );
}
