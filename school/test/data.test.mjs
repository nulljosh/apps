import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const read = (p) => JSON.parse(readFileSync(fileURLToPath(new URL(p, import.meta.url)), 'utf8'));

test('grades.json schema', () => {
  const { grades } = read('../api/grades.json');
  assert.ok(Array.isArray(grades.courses) && grades.courses.length > 0, 'courses non-empty');
  for (const c of grades.courses) {
    assert.equal(typeof c.course, 'string');
    assert.ok(Array.isArray(c.categories), `${c.course} has categories array`);
  }
});

test('quizzes.json units stay in Subject range (math 1-7, science 1-9)', () => {
  const q = read('../api/quizzes.json');
  const ranges = { math: 7, science: 9 };
  for (const [subject, max] of Object.entries(ranges)) {
    assert.equal(typeof q[subject], 'object', `${subject} present`);
    for (const key of Object.keys(q[subject])) {
      const n = Number(key);
      assert.ok(Number.isInteger(n) && n >= 1 && n <= max, `${subject} unit ${key} in 1-${max}`);
    }
  }
});
