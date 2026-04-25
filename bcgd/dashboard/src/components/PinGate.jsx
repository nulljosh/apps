import { useState } from 'react';
import { checkPin } from '../lib/storage';
import Logo from './Logo';

export default function PinGate({ onAuthenticated }) {
  const [pin, setPin] = useState('');
  const [error, setError] = useState(false);
  const [shaking, setShaking] = useState(false);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (checkPin(pin)) {
      onAuthenticated();
    } else {
      setError(true);
      setShaking(true);
      setPin('');
      setTimeout(() => setShaking(false), 500);
    }
  };

  return (
    <div className="pin-gate">
      <form
        className={`pin-card glass-card ${shaking ? 'pin-shake' : ''}`}
        onSubmit={handleSubmit}
      >
        <Logo size={48} />
        <h1 className="pin-title">Best Choice Garage Doors</h1>
        <p className="pin-subtitle">Enter PIN</p>
        <input
          type="password"
          maxLength={4}
          value={pin}
          onChange={e => {
            setPin(e.target.value.replace(/\D/g, ''));
            setError(false);
          }}
          className="pin-input"
          autoFocus
          inputMode="numeric"
          pattern="[0-9]*"
          placeholder="----"
        />
        {error && <p className="pin-error">Incorrect PIN</p>}
        <button type="submit" className="btn btn-primary pin-submit">
          Unlock
        </button>
      </form>
    </div>
  );
}
