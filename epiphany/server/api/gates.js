import { getKv } from './_kv.js';

const ADMIN_EMAILS = (process.env.ADMIN_EMAILS ?? '').split(',').map(e => e.trim()).filter(Boolean);

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
