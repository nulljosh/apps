import { useState, useEffect, useCallback, useRef } from 'react';
import { evaluateMath } from './lib/mathEngine';
import { suggestions } from './lib/suggestions';

const THEMES = {
  orange:   { accent: '#FF8C12' },
  red:      { accent: '#DC0000' },
  yellow:   { accent: '#F5C800' },
  green:    { accent: '#75BF21' },
  blue:     { accent: '#2A7DEB' },
  purple:   { accent: '#6103B0' },
  pink:     { accent: '#D004A1' },
  contrast: { accent: '#FFFFFF' },
};

function ThemePicker({ current, onChange }) {
  const [open, setOpen] = useState(false);
  const ref = useRef(null);
  const accent = THEMES[current].accent;

  useEffect(() => {
    if (!open) return;
    const handler = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [open]);

  return (
    <div ref={ref} style={{ position: 'relative' }}>
      <button
        onClick={() => setOpen(o => !o)}
        style={{
          width: 22, height: 22, borderRadius: '50%',
          background: accent, border: '2px solid rgba(255,255,255,0.3)',
          cursor: 'pointer', flexShrink: 0,
          transition: 'transform 0.15s cubic-bezier(0.34,1.56,0.64,1)',
        }}
        onMouseEnter={e => e.currentTarget.style.transform = 'scale(1.1)'}
        onMouseLeave={e => e.currentTarget.style.transform = 'scale(1)'}
        title="Change theme"
      />
      {open && (
        <div style={{
          position: 'absolute', bottom: 32, left: '50%', transform: 'translateX(-50%)',
          background: 'rgba(20,20,35,0.96)',
          backdropFilter: 'blur(20px)', WebkitBackdropFilter: 'blur(20px)',
          border: '1px solid rgba(255,255,255,0.1)',
          borderRadius: 10, padding: 10,
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8,
          zIndex: 200,
          animation: 'resultReveal 0.15s ease both',
        }}>
          {Object.entries(THEMES).map(([key, t]) => (
            <button key={key}
              onClick={() => { onChange(key); setOpen(false); }}
              title={key}
              style={{
                width: 22, height: 22, borderRadius: '50%',
                background: t.accent,
                border: current === key ? '2px solid #fff' : '2px solid transparent',
                cursor: 'pointer',
                transition: 'transform 0.12s cubic-bezier(0.34,1.56,0.64,1)',
              }}
              onMouseEnter={e => e.currentTarget.style.transform = 'scale(1.15)'}
              onMouseLeave={e => e.currentTarget.style.transform = 'scale(1)'}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function MathResult({ value, accent }) {
  return (
    <div style={{ padding: '18px 20px 14px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, animation: 'mathPop 0.35s cubic-bezier(0.34,1.56,0.64,1) both' }}>
      <div style={{ fontSize: 42, fontWeight: 600, color: '#fff', letterSpacing: '-0.03em', lineHeight: 1 }}>{value}</div>
      <div style={{ fontSize: 9, fontWeight: 600, letterSpacing: '0.12em', color: accent, opacity: 0.7, textTransform: 'uppercase', marginTop: 2 }}>Result</div>
    </div>
  );
}

function TextResult({ heading, body, imageURL, accent }) {
  return (
    <div style={{ padding: '14px 18px 10px', animation: 'resultReveal 0.3s cubic-bezier(0.22,1,0.36,1) both' }}>
      <div style={{ display: 'flex', gap: 14, alignItems: 'flex-start' }}>
        {imageURL && (
          <img src={imageURL} alt="" style={{ width: 56, height: 56, borderRadius: 8, objectFit: 'cover', flexShrink: 0, opacity: 0.9 }} onError={e => e.target.style.display = 'none'} />
        )}
        <div>
          {heading && <div style={{ fontSize: 13, fontWeight: 600, color: 'rgba(255,255,255,0.9)', marginBottom: 4, letterSpacing: '-0.01em' }}>{heading}</div>}
          <div style={{ fontSize: 13, color: 'rgba(255,255,255,0.55)', lineHeight: 1.55, letterSpacing: '-0.005em', display: '-webkit-box', WebkitLineClamp: 6, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>{body}</div>
        </div>
      </div>
    </div>
  );
}

function ListResult({ items, accent }) {
  return (
    <div style={{ padding: '6px 0 2px', animation: 'resultReveal 0.25s ease both' }}>
      {items.map((item, i) => (
        <div key={i}
          style={{ display: 'flex', alignItems: 'flex-start', gap: 12, padding: '9px 18px', borderTop: i > 0 ? '1px solid rgba(255,255,255,0.05)' : 'none', animation: `listItem 0.25s ${i * 0.045}s cubic-bezier(0.22,1,0.36,1) both`, transition: 'background 0.1s', cursor: 'default' }}
          onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.04)'}
          onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
        >
          <span style={{ fontSize: 9, color: accent, opacity: 0.7, fontWeight: 600, minWidth: 16, paddingTop: 2 }}>{i + 1}</span>
          <span style={{ fontSize: 13, color: 'rgba(255,255,255,0.7)', lineHeight: 1.45, letterSpacing: '-0.005em' }}>{item}</span>
        </div>
      ))}
    </div>
  );
}

function ErrorResult({ message, searchURL, accent }) {
  return (
    <div style={{ padding: '18px 20px 14px', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10, animation: 'resultReveal 0.2s ease both' }}>
      <div style={{ fontSize: 11, color: 'rgba(255,255,255,0.35)', letterSpacing: '0.02em' }}>{message}</div>
      {searchURL && (
        <a href={searchURL} target="_blank" rel="noopener noreferrer" style={{ fontSize: 11, fontWeight: 500, color: accent, background: 'none', textDecoration: 'none', padding: '4px 8px', borderRadius: 5, transition: 'background 0.1s', opacity: 0.85 }}
          onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.06)'}
          onMouseLeave={e => e.currentTarget.style.background = 'none'}>
          Search on DuckDuckGo →
        </a>
      )}
    </div>
  );
}

function LoadingSkeleton() {
  const shimmer = { background: 'linear-gradient(90deg, rgba(255,255,255,0.04) 0%, rgba(255,255,255,0.09) 50%, rgba(255,255,255,0.04) 100%)', backgroundSize: '200% 100%', animation: 'shimmer 1.4s ease-in-out infinite', borderRadius: 4 };
  return (
    <div style={{ padding: '16px 18px 14px', display: 'flex', gap: 14 }}>
      <div style={{ width: 44, height: 44, borderRadius: 8, flexShrink: 0, ...shimmer }} />
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8, paddingTop: 4 }}>
        <div style={{ height: 13, width: '45%', ...shimmer }} />
        <div style={{ height: 11, width: '90%', ...shimmer }} />
        <div style={{ height: 11, width: '75%', ...shimmer }} />
      </div>
    </div>
  );
}

function SourceFooter({ source, href }) {
  if (!source) return null;
  return (
    <div style={{ display: 'flex', justifyContent: 'flex-end', padding: '0 16px 9px' }}>
      {href ? (
        <a href={href} target="_blank" rel="noopener noreferrer" style={{ fontSize: 10, color: 'rgba(255,255,255,0.2)', textDecoration: 'none', letterSpacing: '0.01em', transition: 'color 0.15s' }}
          onMouseEnter={e => e.currentTarget.style.color = 'rgba(255,255,255,0.45)'}
          onMouseLeave={e => e.currentTarget.style.color = 'rgba(255,255,255,0.2)'}>
          {source}
        </a>
      ) : (
        <span style={{ fontSize: 10, color: 'rgba(255,255,255,0.2)', letterSpacing: '0.01em' }}>{source}</span>
      )}
    </div>
  );
}

function WebResults({ results, accent }) {
  if (!results.length) return null;
  return (
    <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)' }}>
      <div style={{ padding: '8px 18px 4px', fontSize: 9, fontWeight: 600, letterSpacing: '0.1em', color: 'rgba(255,255,255,0.25)', textTransform: 'uppercase' }}>Web</div>
      {results.map((r, i) => (
        <a key={`${r.url}-${i}`} href={r.url} target="_blank" rel="noopener noreferrer"
          style={{ display: 'block', padding: '9px 18px', borderTop: '1px solid rgba(255,255,255,0.05)', textDecoration: 'none', animation: `listItem 0.25s ${Math.min(i * 0.045, 0.4)}s cubic-bezier(0.22,1,0.36,1) both`, transition: 'background 0.1s' }}
          onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.04)'}
          onMouseLeave={e => e.currentTarget.style.background = 'transparent'}>
          <div style={{ fontSize: 10, color: accent, opacity: 0.8, marginBottom: 2 }}>{r.domain || new URL(r.url).hostname.replace(/^www\./, '')}</div>
          <div style={{ fontSize: 13, fontWeight: 500, color: 'rgba(255,255,255,0.85)', lineHeight: 1.3, marginBottom: 2, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{r.title}</div>
          {r.snippet && <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.4)', lineHeight: 1.45, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{r.snippet}</div>}
        </a>
      ))}
    </div>
  );
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
  const [theme, setTheme] = useState(() => localStorage.getItem('nimble_theme') || 'orange');
  const inputRef = useRef(null);
  const accent = THEMES[theme]?.accent || THEMES.orange.accent;

  const handleThemeChange = (t) => {
    setTheme(t);
    localStorage.setItem('nimble_theme', t);
  };

  useEffect(() => {
    setPlaceholder(suggestions[Math.floor(Math.random() * suggestions.length)]);
    const interval = setInterval(() => {
      setPlaceholder(suggestions[Math.floor(Math.random() * suggestions.length)]);
    }, 10000);
    return () => clearInterval(interval);
  }, []);

  useEffect(() => { inputRef.current?.focus(); }, []);

  const handleSearch = useCallback(async (searchQuery) => {
    const q = searchQuery.trim();
    if (!q) return;

    setLoading(true);
    setError(null);
    setHasSearched(true);

    const math = evaluateMath(q);
    setMathResult(math);
    setInstantAnswer(null);
    setResults([]);

    const encoded = encodeURIComponent(q);
    const [searchRes, instantRes] = await Promise.allSettled([
      fetch(`/api/search?q=${encoded}&limit=10`),
      !math ? fetch(`/api/instant?q=${encoded}`) : Promise.resolve(null),
    ]);

    if (searchRes.status === 'fulfilled' && searchRes.value?.ok) {
      const data = await searchRes.value.json();
      setResults(data.results || []);
    } else if (!math) {
      setError('No results found.');
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

  const copyResult = () => {
    let text = '';
    if (mathResult) text = mathResult;
    else if (instantAnswer?.body) text = instantAnswer.body;
    if (text) navigator.clipboard.writeText(text);
  };

  const hasResult = hasSearched && (mathResult || instantAnswer || results.length > 0 || error);
  const instantSource = instantAnswer?.source || (mathResult ? 'mathjs' : null);
  const instantSourceURL = instantAnswer?.sourceURL || null;

  return (
    <div className="desktop">
      <div className="desktop-bg" />

      <div className="nimble-stage" style={{ '--accent': accent }}>
        <div className="nimble-window" style={{ outline: `1px solid ${accent}18` }}>
          {/* Search bar */}
          <form onSubmit={handleSubmit} className="search-bar">
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none" style={{ flexShrink: 0 }}>
              <circle cx="8.5" cy="8.5" r="5.5" stroke={accent} strokeWidth="1.5" opacity="0.9" />
              <line x1="12.5" y1="12.5" x2="17" y2="17" stroke={accent} strokeWidth="1.5" strokeLinecap="round" />
            </svg>
            <input
              ref={inputRef}
              type="text"
              value={query}
              onChange={e => setQuery(e.target.value)}
              onKeyDown={handleKeyDown}
              placeholder={placeholder}
              className="search-input"
              autoComplete="off"
              spellCheck="false"
              style={{ caretColor: accent }}
            />
            {loading && (
              <div style={{ width: 18, height: 18, borderRadius: '50%', border: `2px solid rgba(255,255,255,0.12)`, borderTopColor: accent, animation: 'spin 0.7s linear infinite', flexShrink: 0 }} />
            )}
            {!loading && query && (
              <kbd className="return-hint">↩</kbd>
            )}
          </form>

          {/* Results */}
          {loading && !mathResult && (
            <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)' }}>
              <LoadingSkeleton />
            </div>
          )}

          {hasResult && (
            <div style={{ borderTop: '1px solid rgba(255,255,255,0.06)' }}>
              {mathResult && <MathResult value={mathResult} accent={accent} />}
              {instantAnswer?.type === 'text' && (
                <TextResult heading={instantAnswer.heading} body={instantAnswer.body} imageURL={instantAnswer.imageURL} accent={accent} />
              )}
              {instantAnswer?.type === 'list' && <ListResult items={instantAnswer.items} accent={accent} />}
              {error && !mathResult && !instantAnswer && (
                <ErrorResult message={error} searchURL={`https://duckduckgo.com/?q=${encodeURIComponent(query || placeholder)}`} accent={accent} />
              )}
              {instantSource && <SourceFooter source={instantSource} href={instantSourceURL} />}
              <WebResults results={results} accent={accent} />
            </div>
          )}

          {/* Bottom bar */}
          <div className="bottom-bar" style={{ borderTop: '1px solid rgba(255,255,255,0.05)' }}>
            <ThemePicker current={theme} onChange={handleThemeChange} />
            <span style={{ fontSize: 9, fontWeight: 500, letterSpacing: '0.08em', color: 'rgba(255,255,255,0.2)', textTransform: 'uppercase' }}>Nimble v3.0</span>
            <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
              <button title="Copy result" onClick={copyResult} className="bar-btn">⎘</button>
              <a href="https://github.com/nulljosh/apps/tree/main/nimble-web" target="_blank" rel="noopener noreferrer" className="bar-btn" title="GitHub">⚙</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
