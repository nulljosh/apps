import { useState } from 'react';
import { getPin, savePin } from '../lib/storage';

export default function PinGate({ onAuthenticated }) {
  const stored = getPin();
  const [mode, setMode] = useState(stored ? 'enter' : 'set');
  const [input, setInput] = useState('');
  const [confirm, setConfirm] = useState('');
  const [step, setStep] = useState('pin'); // 'pin' | 'confirm'
  const [error, setError] = useState('');

  function press(digit) {
    if (mode === 'enter') {
      const next = input + digit;
      setInput(next);
      if (next.length === 4) {
        if (next === stored) {
          onAuthenticated();
        } else {
          setError('Wrong PIN');
          setTimeout(() => { setInput(''); setError(''); }, 800);
        }
      }
    } else {
      if (step === 'pin') {
        const next = input + digit;
        setInput(next);
        if (next.length === 4) { setStep('confirm'); setInput(''); }
      } else {
        const next = confirm + digit;
        setConfirm(next);
        if (next.length === 4) {
          if (next === input.length === 0 ? confirm : input) {
            savePin(next);
            onAuthenticated();
          }
        }
      }
    }
  }

  function pressBack() {
    if (mode === 'enter') {
      setInput(p => p.slice(0, -1));
    } else if (step === 'pin') {
      setInput(p => p.slice(0, -1));
    } else {
      setConfirm(p => p.slice(0, -1));
    }
  }

  // For set mode, re-check confirm after 4 digits
  function handleSetPin(digit) {
    if (step === 'pin') {
      const next = input + digit;
      setInput(next);
      if (next.length === 4) {
        setTimeout(() => { setStep('confirm'); }, 100);
      }
    } else {
      const next = confirm + digit;
      setConfirm(next);
      if (next.length === 4) {
        if (next === input) {
          savePin(next);
          onAuthenticated();
        } else {
          setError('PINs do not match');
          setTimeout(() => { setConfirm(''); setError(''); }, 800);
        }
      }
    }
  }

  const dots = mode === 'enter' ? input : (step === 'pin' ? input : confirm);

  return (
    <div className="pin-gate-overlay">
      <div className="pin-gate glass-card">
        <div className="pin-gate-title">
          {mode === 'enter' ? 'Dashboard PIN' : step === 'pin' ? 'Set a PIN' : 'Confirm PIN'}
        </div>
        <div className="pin-dots">
          {[0,1,2,3].map(i => (
            <div key={i} className={`pin-dot ${dots.length > i ? 'filled' : ''} ${error ? 'error' : ''}`}/>
          ))}
        </div>
        {error && <div className="pin-error">{error}</div>}
        <div className="pin-keypad">
          {['1','2','3','4','5','6','7','8','9','','0','⌫'].map((k, i) => (
            <button
              key={i}
              className={`pin-key ${k === '' ? 'pin-key-empty' : ''}`}
              onClick={() => k === '⌫' ? pressBack() : k !== '' ? (mode === 'enter' ? press(k) : handleSetPin(k)) : null}
              disabled={k === ''}
            >
              {k}
            </button>
          ))}
        </div>
        {mode === 'enter' && (
          <button className="pin-skip" onClick={onAuthenticated}>Skip (no PIN)</button>
        )}
      </div>
    </div>
  );
}
