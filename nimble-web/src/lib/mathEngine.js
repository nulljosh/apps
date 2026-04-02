const MATH_FUNCTIONS = ['sqrt', 'sin', 'cos', 'tan', 'log', 'ln', 'abs', 'pow', 'mod', 'pi'];

function isMathExpression(input) {
  let test = input.toLowerCase();
  for (const fn of MATH_FUNCTIONS) {
    test = test.replaceAll(fn, '');
  }
  return /^[\d.+\-*/^%() ,eE\s]+$/.test(test);
}

function hasOperation(input) {
  const lower = input.toLowerCase();
  if (/[+\-*/^%]/.test(input)) return true;
  for (const fn of MATH_FUNCTIONS) {
    if (lower.includes(fn + '(')) return true;
  }
  if (lower === 'pi' || lower === 'e') return true;
  return false;
}

function formatResult(value) {
  if (!isFinite(value)) return String(value);
  if (value === Math.round(value) && Math.abs(value) < 1e15) {
    return String(Math.round(value));
  }
  const formatted = value.toFixed(10);
  return formatted.replace(/0+$/, '').replace(/\.$/, '');
}

function evaluateSimple(expr) {
  const cleaned = expr.trim();
  const num = parseFloat(cleaned);
  if (!isNaN(num) && String(num) === cleaned) return num;
  try {
    const safe = cleaned.replace(/[^0-9.+\-*/() ]/g, '');
    if (!safe.trim()) return null;
    const result = Function('"use strict"; return (' + safe + ')')();
    return typeof result === 'number' ? result : null;
  } catch {
    return null;
  }
}

function evaluateWithFunctions(expr) {
  const fns = [
    { pattern: /^sqrt\((.+)\)$/i, fn: (v) => Math.sqrt(v) },
    { pattern: /^sin\((.+)\)$/i, fn: (v) => Math.sin(v) },
    { pattern: /^cos\((.+)\)$/i, fn: (v) => Math.cos(v) },
    { pattern: /^tan\((.+)\)$/i, fn: (v) => Math.tan(v) },
    { pattern: /^abs\((.+)\)$/i, fn: (v) => Math.abs(v) },
    { pattern: /^ln\((.+)\)$/i, fn: (v) => Math.log(v) },
    { pattern: /^log\((.+)\)$/i, fn: (v) => Math.log10(v) },
  ];

  for (const { pattern, fn } of fns) {
    const match = expr.match(pattern);
    if (match) {
      const inner = evaluateSimple(match[1]);
      if (inner !== null) return fn(inner);
    }
  }

  if (expr.includes('^')) {
    const parts = expr.split('^');
    if (parts.length === 2) {
      const base = evaluateSimple(parts[0]);
      const exp = evaluateSimple(parts[1]);
      if (base !== null && exp !== null) return Math.pow(base, exp);
    }
  }

  if (expr.includes('%')) {
    const parts = expr.split('%');
    if (parts.length === 2) {
      const lhs = evaluateSimple(parts[0]);
      const rhs = evaluateSimple(parts[1]);
      if (lhs !== null && rhs !== null && rhs !== 0) return lhs % rhs;
    }
  }

  return null;
}

export function evaluateMath(input) {
  const expr = input.trim();
  if (!expr) return null;
  if (!isMathExpression(expr)) return null;
  if (!hasOperation(expr)) return null;

  let processed = expr.replace(/\bpi\b/gi, String(Math.PI));
  if (processed.toLowerCase() === 'e') return formatResult(Math.E);
  processed = processed.replace(/\be\b/gi, String(Math.E));

  const funcResult = evaluateWithFunctions(processed);
  if (funcResult !== null) return formatResult(funcResult);

  const cleaned = processed
    .replace(/x/gi, '*')
    .replace(/\^/g, '**');

  try {
    const safe = cleaned.replace(/[^0-9.+\-*/() ]/g, '');
    if (!safe.trim()) return null;
    const result = Function('"use strict"; return (' + safe + ')')();
    if (typeof result === 'number' && isFinite(result)) return formatResult(result);
  } catch {}

  return null;
}
