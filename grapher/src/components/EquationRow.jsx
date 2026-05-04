export default function EquationRow({ eq, onChange, onRemove, showRemove }) {
  return (
    <div style={{ marginBottom: 10 }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <div style={{
          width: 12, height: 12, borderRadius: '50%',
          background: eq.color, flexShrink: 0,
          boxShadow: `0 0 6px ${eq.color}88`,
        }} />
        <input
          value={eq.expr}
          onChange={(e) => onChange(eq.id, e.target.value)}
          placeholder="y = x^2"
          spellCheck={false}
          style={{
            flex: 1,
            background: 'rgba(255,255,255,0.07)',
            border: `1px solid ${eq.error ? 'rgba(255,69,58,0.6)' : 'rgba(255,255,255,0.12)'}`,
            borderRadius: 10,
            padding: '8px 12px',
            color: '#f5f5f7',
            fontSize: 14,
            fontFamily: '"SF Mono", "Menlo", monospace',
            outline: 'none',
            transition: 'border-color 0.15s',
          }}
          onFocus={(e) => {
            if (!eq.error) e.target.style.borderColor = 'rgba(0,113,227,0.7)';
          }}
          onBlur={(e) => {
            e.target.style.borderColor = eq.error ? 'rgba(255,69,58,0.6)' : 'rgba(255,255,255,0.12)';
          }}
        />
        {showRemove && (
          <button
            onClick={() => onRemove(eq.id)}
            style={{
              background: 'none', border: 'none', color: 'rgba(255,255,255,0.3)',
              cursor: 'pointer', fontSize: 18, lineHeight: 1, padding: '0 2px',
              flexShrink: 0,
            }}
          >×</button>
        )}
      </div>
      {eq.error && (
        <div style={{
          marginTop: 4, marginLeft: 20,
          fontSize: 11, color: 'rgba(255,69,58,0.85)',
          fontFamily: '"SF Mono", "Menlo", monospace',
        }}>{eq.error}</div>
      )}
    </div>
  );
}
