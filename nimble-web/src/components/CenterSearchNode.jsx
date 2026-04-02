import { useState, useEffect, useCallback } from 'react';
import { suggestions } from '../lib/suggestions';

export default function CenterSearchNode({ data }) {
  const { onSearch, error, loading } = data;
  const [query, setQuery] = useState('');
  const [placeholder, setPlaceholder] = useState('');

  useEffect(() => {
    setPlaceholder(suggestions[Math.floor(Math.random() * suggestions.length)]);
    const interval = setInterval(() => {
      setPlaceholder(suggestions[Math.floor(Math.random() * suggestions.length)]);
    }, 10000);
    return () => clearInterval(interval);
  }, []);

  const handleSubmit = useCallback((e) => {
    e.preventDefault();
    const q = query.trim() || placeholder;
    if (q) onSearch(q);
  }, [query, placeholder, onSearch]);

  const handleKeyDown = useCallback((e) => {
    if (e.key === 'Tab' && !query) {
      e.preventDefault();
      setQuery(placeholder);
    }
  }, [query, placeholder]);

  return (
    <div className="center-node">
      <div className="center-title">Nimble</div>
      <form onSubmit={handleSubmit} className="center-form">
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder={placeholder}
          className="center-input"
          autoFocus
        />
        <button type="submit" className="center-btn" disabled={loading}>
          {loading ? '...' : 'Go'}
        </button>
      </form>
      {error && <div className="center-error">{error}</div>}
    </div>
  );
}
