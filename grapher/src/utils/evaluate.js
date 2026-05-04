import { parse } from 'mathjs';

export function evaluate(expr) {
  const cleaned = expr.replace(/^y\s*=\s*/i, '').trim();
  if (!cleaned) return { fn: null, error: null };
  try {
    const compiled = parse(cleaned).compile();
    return { fn: (x) => compiled.evaluate({ x }), error: null };
  } catch (e) {
    return { fn: null, error: e.message };
  }
}
