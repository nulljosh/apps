const MATH_FUNCTIONS = ['sqrt', 'sin', 'cos', 'tan', 'log', 'ln', 'abs', 'pow', 'mod', 'pi'];

const WORD_NUMBERS = {
  zero: '0', one: '1', two: '2', three: '3', four: '4',
  five: '5', six: '6', seven: '7', eight: '8', nine: '9',
  ten: '10', eleven: '11', twelve: '12', thirteen: '13',
  fourteen: '14', fifteen: '15', sixteen: '16', seventeen: '17',
  eighteen: '18', nineteen: '19', twenty: '20', thirty: '30',
  forty: '40', fifty: '50', sixty: '60', seventy: '70',
  eighty: '80', ninety: '90', hundred: '100', thousand: '1000',
  million: '1000000',
};

const WORD_OPERATORS = [
  ['multiplied by', '*'], ['divided by', '/'], ['added to', '+'],
  ['to the power of', '^'],
  ['plus', '+'], ['add', '+'], ['minus', '-'], ['subtract', '-'],
  ['less', '-'], ['times', '*'], ['over', '/'],
  ['squared', '^2'], ['cubed', '^3'],
];

const FILLER_PATTERNS = [
  'what is ', 'whats ', "what's ", 'calculate ', 'how much is ',
  'compute ', 'solve ', 'evaluate ', 'the answer to ', 'result of ',
];

function parseNaturalLanguageMath(input) {
  let text = input.toLowerCase().trim();
  const hasWordNumber = Object.keys(WORD_NUMBERS).some(w => text.includes(w));
  const hasWordOp = WORD_OPERATORS.some(([w]) => text.includes(w));
  if (!hasWordNumber || !hasWordOp) return null;

  for (const filler of FILLER_PATTERNS) {
    if (text.startsWith(filler)) text = text.slice(filler.length);
  }
  text = text.replace(/\?/g, '').trim();

  for (const [word, op] of WORD_OPERATORS) {
    text = text.replaceAll(word, ` ${op} `);
  }
  for (const [word, num] of Object.entries(WORD_NUMBERS)) {
    text = text.replace(new RegExp(`\\b${word}\\b`, 'g'), num);
  }
  text = text.replace(/\s+/g, ' ').trim();

  if (!/^[\d.+\-*/^%() ]+$/.test(text)) return null;
  return text;
}

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

function evaluateExpression(expr) {
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

export function evaluateMath(input) {
  const expr = input.trim();
  if (!expr) return null;

  if (isMathExpression(expr) && hasOperation(expr)) {
    return evaluateExpression(expr);
  }

  const natural = parseNaturalLanguageMath(expr);
  if (natural) return evaluateExpression(natural);

  return null;
}
