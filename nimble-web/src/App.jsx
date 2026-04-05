import { useState, useEffect, useCallback, useRef } from 'react';
import { evaluateMath } from './lib/mathEngine';
import { suggestions } from './lib/suggestions';

function extractDomain(url) {
  try {
    return new URL(url).hostname.replace(/^www\./, '');
  } catch {
    return '';
  }
}

export default function App() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);
  const [mathResult, setMathResult] = useState(null);
  const [instantAnswer, setInstantAnswer] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [hasSearched, setHasSearched] = useState(false);
  const [placeholder, setPlaceholder] = useState('');
  const inputRef = useRef(null);

  useEffect(() => {
    setPlaceholder(suggestions[Math.floor(Math.random() * suggestions.length)]);
    const interval = setInterval(() => {
      setPlaceholder(suggestions[Math.floor(Math.random() * suggestions.length)]);
    }, 10000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  const handleSearch = useCallback(async (searchQuery) => {
    const q = searchQuery.trim();
    if (!q) return;

    setLoading(true);
    setError(null);
    setHasSearched(true);

    const math = evaluateMath(q);
    setMathResult(math);
    setInstantAnswer(null);

    const encoded = encodeURIComponent(q);
    const [searchRes, instantRes] = await Promise.allSettled([
      fetch(`/api/search?q=${encoded}&limit=20`),
      !math ? fetch(`/api/instant?q=${encoded}`) : Promise.resolve(null),
    ]);

    if (searchRes.status === 'fulfilled' && searchRes.value?.ok) {
      const data = await searchRes.value.json();
      setResults(data.results || []);
    } else if (!math) {
      setError('Search failed. Try again.');
      setResults([]);
    }

    if (!math && instantRes.status === 'fulfilled' && instantRes.value?.ok) {
      const data = await instantRes.value.json();
      if (data.type) setInstantAnswer(data);
    }

    setLoading(false);
  }, []);

  const handleSubmit = useCallback((e) => {
    e.preventDefault();
    handleSearch(query || placeholder);
  }, [query, placeholder, handleSearch]);

  const handleKeyDown = useCallback((e) => {
    if (e.key === 'Tab' && !query) {
      e.preventDefault();
      setQuery(placeholder);
    }
  }, [query, placeholder]);

  const showResults = hasSearched && (mathResult || instantAnswer || results.length > 0 || error);

  return (
    <div className={`app ${showResults ? 'has-results' : ''}`}>
      <div className="noise" />

      <div className="search-area">
        <div className="brand">
          <h1 className="brand-title">Nimble</h1>
          <p className="brand-sub">Instant answers</p>
        </div>

        <form onSubmit={handleSubmit} className="search-form">
          <div className="search-input-wrap">
            <svg className="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
            <input
              ref={inputRef}
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder={placeholder}
              className="search-input"
              autoComplete="off"
              spellCheck="false"
            />
            {query && (
              <button
                type="button"
                className="search-clear"
                onClick={() => { setQuery(''); inputRef.current?.focus(); }}
                aria-label="Clear search"
              >
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round">
                  <line x1="18" y1="6" x2="6" y2="18" />
                  <line x1="6" y1="6" x2="18" y2="18" />
                </svg>
              </button>
            )}
          </div>
          <button type="submit" className="search-btn" disabled={loading}>
            {loading ? (
              <span className="loading-dots">
                <span /><span /><span />
              </span>
            ) : 'Search'}
          </button>
        </form>
      </div>

      {showResults && (
        <div className="results-area">
          {mathResult && (
            <div className="result-card math-card animate__animated animate__fadeInUp" style={{ animationDuration: '0.35s' }}>
              <div className="math-value">{mathResult}</div>
              <div className="math-label">Result</div>
            </div>
          )}

          {instantAnswer && instantAnswer.type === 'text' && (
            <div className="result-card instant-card animate__animated animate__fadeInUp" style={{ animationDuration: '0.35s' }}>
              {instantAnswer.imageURL && (
                <img src={instantAnswer.imageURL} alt="" className="instant-image" />
              )}
              {instantAnswer.heading && (
                <div className="instant-heading">{instantAnswer.heading}</div>
              )}
              <div className="instant-body">{instantAnswer.body}</div>
              {instantAnswer.source && (
                <div className="instant-source">
                  {instantAnswer.sourceURL ? (
                    <a href={instantAnswer.sourceURL} target="_blank" rel="noopener noreferrer">
                      {instantAnswer.source}
                    </a>
                  ) : instantAnswer.source}
                </div>
              )}
            </div>
          )}

          {instantAnswer && instantAnswer.type === 'list' && (
            <div className="result-card instant-card animate__animated animate__fadeInUp" style={{ animationDuration: '0.35s' }}>
              <ul className="instant-list">
                {instantAnswer.items.map((item, i) => (
                  <li key={i}>{item}</li>
                ))}
              </ul>
              {instantAnswer.source && (
                <div className="instant-source">{instantAnswer.source}</div>
              )}
            </div>
          )}

          {error && (
            <div className="result-card error-card animate__animated animate__fadeInUp">
              <span className="error-text">{error}</span>
            </div>
          )}

          {results.map((r, i) => (
            <a
              key={`${r.url}-${i}`}
              href={r.url}
              target="_blank"
              rel="noopener noreferrer"
              className="result-card animate__animated animate__fadeInUp"
              style={{ animationDelay: `${Math.min(i * 0.04, 0.4)}s`, animationDuration: '0.35s' }}
            >
              <div className="result-header">
                <span className="result-domain">{extractDomain(r.url)}</span>
              </div>
              <div className="result-title">{r.title}</div>
              {r.snippet && <div className="result-snippet">{r.snippet}</div>}
            </a>
          ))}

          {!loading && results.length === 0 && !mathResult && !error && (
            <div className="no-results">No results found.</div>
          )}
        </div>
      )}

      {loading && !mathResult && results.length === 0 && (
        <div className="results-area">
          {[0, 1, 2, 3, 4].map((i) => (
            <div key={i} className="skeleton-card" style={{ animationDelay: `${i * 0.08}s` }}>
              <div className="skeleton-line short" />
              <div className="skeleton-line" />
              <div className="skeleton-line med" />
            </div>
          ))}
        </div>
      )}

      <footer className="footer">
        <span>&copy; {new Date().getFullYear()} Nimble. <a href="https://opensource.org/licenses/Apache-2.0" target="_blank" rel="noopener noreferrer">Apache 2.0</a></span>
        <span>Inspired by <a href="https://maybulb.com" target="_blank" rel="noopener noreferrer">Maybulb</a></span>
      </footer>
    </div>
  );
}
