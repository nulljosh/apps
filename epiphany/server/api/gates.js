import { getKv } from './_kv.js';

const ADMIN_EMAILS = (process.env.ADMIN_EMAILS ?? '').split(',').map(e => e.trim()).filter(Boolean);
const FREE_AI_DAILY_LIMIT = 3;

export function isAdmin(email) {
  return ADMIN_EMAILS.includes(email);
}

export async function isPro(session) {
  if (!session?.email) return false;
  if (isAdmin(session.email)) return true;

  const kv = await getKv();
  if (!kv) return false;

  const user = await kv.get(`user:${session.email}`);
  if (!user?.stripe_customer_id) return false;

  const sub = await kv.get(`sub:${user.stripe_customer_id}`);
  return sub?.status === 'active';
}

export async function checkFreeAiLimit(session) {
  const kv = await getKv();
  if (!kv) return { allowed: true };

  const day = new Date().toISOString().slice(0, 10);
  const key = `free:ai:${session.userId}:${day}`;
  const count = (await kv.get(key)) || 0;

  if (count >= FREE_AI_DAILY_LIMIT) {
    return { allowed: false, count, limit: FREE_AI_DAILY_LIMIT };
  }

  await kv.set(key, count + 1, { ex: 86400 });
  return { allowed: true, count: count + 1, limit: FREE_AI_DAILY_LIMIT };
}
