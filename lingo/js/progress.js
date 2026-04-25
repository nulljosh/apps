function calculateProgress(lessons) {
  if (!lessons || lessons.length === 0) return { completed: 0, total: 0, percent: 0 };
  const completed = lessons.filter(l => l.completed).length;
  return {
    completed,
    total: lessons.length,
    percent: Math.round((completed / lessons.length) * 100),
  };
}
