#!/usr/bin/env node
// One-shot: split the legacy inline question bank (js/lingo-data.js) into
// content/catalog.json + content/courses/<id>.json course packs.
// Idempotent: re-running regenerates from the same source. Safe to delete after cutover.

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import vm from 'node:vm';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const LESSON_SIZE = 7;

// BCP-47 tags for speech/TTS. Mirrors LANG_CODES in js/lingo-app.js.
const LANG_CODES = {
  spanish: 'es-ES', french: 'fr-FR', german: 'de-DE', italian: 'it-IT',
  portuguese: 'pt-BR', japanese: 'ja-JP', chinese: 'zh-CN', korean: 'ko-KR',
  russian: 'ru-RU', arabic: 'ar-SA', hindi: 'hi-IN', dutch: 'nl-NL'
};

// Run the browser data file in a sandbox to capture its globals.
// Top-level const/let bindings are NOT attached to the vm context, so append an
// explicit export. lingo-data.js is sloppy-mode, so `categories`/`questions` are
// in scope for the appended assignment.
const src = readFileSync(join(root, 'js/lingo-data.js'), 'utf8')
  + '\n;__capture.categories = categories; __capture.questions = questions;';
const ctx = { console, __capture: {} };
vm.createContext(ctx);
vm.runInContext(src, ctx);
const { categories, questions } = ctx.__capture;
if (!categories || !questions) throw new Error('Failed to load categories/questions from js/lingo-data.js');

const chunk = (arr, n) => {
  const out = [];
  for (let i = 0; i < arr.length; i += n) out.push(arr.slice(i, i + n));
  return out;
};

// Build catalog from the live categories object, stamping packPath + lang.
const subjectMeta = {};
const catalog = { version: 1, categories: {} };
for (const [catId, cat] of Object.entries(categories)) {
  catalog.categories[catId] = {
    title: cat.title,
    subjects: cat.subjects.map((s) => {
      const hasPack = Array.isArray(questions[s.id]) && questions[s.id].length > 0;
      const meta = { ...s, packPath: hasPack ? `content/courses/${s.id}.json` : null };
      if (LANG_CODES[s.id]) meta.lang = LANG_CODES[s.id];
      subjectMeta[s.id] = { name: s.name, icon: s.icon, level: s.level, category: catId };
      return meta;
    })
  };
}

// A subject only appears in the catalog if it has a real pack (no empty shells).
for (const catId of Object.keys(catalog.categories)) {
  catalog.categories[catId].subjects = catalog.categories[catId].subjects.filter((s) => s.packPath);
}

mkdirSync(join(root, 'content/courses'), { recursive: true });
writeFileSync(join(root, 'content/catalog.json'), JSON.stringify(catalog, null, 2) + '\n');

// Emit one pack per subject. Phase 1: a single unit "All", lessons chunked.
let packCount = 0;
for (const [id, exercises] of Object.entries(questions)) {
  if (!Array.isArray(exercises) || exercises.length === 0) continue;
  const meta = subjectMeta[id] || { name: id, icon: 'fa-solid fa-book', level: '', category: 'skills' };
  const lessons = chunk(exercises, LESSON_SIZE).map((ex, i) => ({
    id: `u1l${i + 1}`,
    title: `Lesson ${i + 1}`,
    exercises: ex
  }));
  const pack = {
    id,
    name: meta.name,
    category: meta.category,
    icon: meta.icon,
    level: meta.level,
    version: 1,
    units: [{ id: 'u1', title: 'All', lessons }]
  };
  if (LANG_CODES[id]) pack.lang = LANG_CODES[id];
  writeFileSync(join(root, `content/courses/${id}.json`), JSON.stringify(pack, null, 2) + '\n');
  packCount += 1;
}

console.log(`Wrote content/catalog.json and ${packCount} packs to content/courses/`);
