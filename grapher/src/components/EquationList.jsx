import EquationRow from './EquationRow.jsx';

export default function EquationList({ equations, onChange, onRemove, onAdd }) {
  return (
    <div style={{
      background: 'rgba(255,255,255,0.05)',
      backdropFilter: 'blur(20px)',
      WebkitBackdropFilter: 'blur(20px)',
      border: '1px solid rgba(255,255,255,0.10)',
      borderRadius: 16,
      padding: '16px 16px 12px',
      display: 'flex',
      flexDirection: 'column',
    }}>
      <div style={{
        fontSize: 11, fontWeight: 600, letterSpacing: '0.08em',
        textTransform: 'uppercase', color: 'rgba(255,255,255,0.35)',
        marginBottom: 12,
      }}>Equations</div>

      {equations.map((eq) => (
        <EquationRow
          key={eq.id}
          eq={eq}
          onChange={onChange}
          onRemove={onRemove}
          showRemove={equations.length > 1}
        />
      ))}

      <button
        onClick={onAdd}
        style={{
          marginTop: 4,
          background: 'rgba(0,113,227,0.15)',
          border: '1px solid rgba(0,113,227,0.35)',
          borderRadius: 10,
          color: '#0071e3',
          fontSize: 13,
          fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", sans-serif',
          padding: '7px 0',
          cursor: 'pointer',
          transition: 'background 0.15s',
        }}
        onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(0,113,227,0.25)'}
        onMouseLeave={(e) => e.currentTarget.style.background = 'rgba(0,113,227,0.15)'}
      >+ Add equation</button>
    </div>
  );
}
