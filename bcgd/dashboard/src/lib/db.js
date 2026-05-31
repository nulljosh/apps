import { supabase } from './supabase';

// Data access for the dashboard. The DB uses snake_case columns; these mappers
// keep the in-app object shape (minThreshold, scheduledAt, createdAt) unchanged
// so PartList / JobList / forms / totals don't have to touch a thing.

const partFromRow = (r) => ({
  id: r.id, org_id: r.org_id, name: r.name, sku: r.sku, category: r.category,
  quantity: r.quantity, minThreshold: r.min_threshold, cost: Number(r.cost), supplier: r.supplier,
});

const partToRow = (orgId, p) => ({
  id: p.id, org_id: orgId, name: p.name, sku: p.sku, category: p.category,
  quantity: p.quantity, min_threshold: p.minThreshold, cost: p.cost, supplier: p.supplier,
  updated_at: new Date().toISOString(),
});

const jobFromRow = (r) => ({
  id: r.id, customer_id: r.customer_id, customer: r.customer, phone: r.phone, address: r.address,
  email: r.email, service: r.service, status: r.status, scheduledAt: r.scheduled_at,
  notes: r.notes, createdAt: r.created_at,
});

const jobToRow = (orgId, j) => ({
  id: j.id, org_id: orgId, customer_id: j.customer_id ?? null, customer: j.customer,
  phone: j.phone || '', address: j.address || '', email: j.email || '', service: j.service || '',
  status: j.status, scheduled_at: j.scheduledAt || '', notes: j.notes || '',
  created_at: j.createdAt || new Date().toISOString(),
});

// ---- Parts ----

export async function fetchParts() {
  if (!supabase) return [];
  const { data, error } = await supabase.from('parts').select('*').order('name');
  if (error) { console.error('[bcgd] fetchParts', error.message); return []; }
  return (data || []).map(partFromRow);
}

export async function savePart(orgId, part) {
  if (!supabase) return;
  const { error } = await supabase.from('parts').upsert(partToRow(orgId, part));
  if (error) throw new Error(error.message);
}

export async function deletePart(id) {
  if (!supabase) return;
  const { error } = await supabase.from('parts').delete().eq('id', id);
  if (error) throw new Error(error.message);
}

// ---- Jobs ----

export async function fetchJobs() {
  if (!supabase) return [];
  const { data, error } = await supabase.from('jobs').select('*').order('created_at', { ascending: false });
  if (error) { console.error('[bcgd] fetchJobs', error.message); return []; }
  return (data || []).map(jobFromRow);
}

export async function saveJob(orgId, job) {
  if (!supabase) return;
  const { error } = await supabase.from('jobs').upsert(jobToRow(orgId, job));
  if (error) throw new Error(error.message);
}

export async function deleteJob(id) {
  if (!supabase) return;
  const { error } = await supabase.from('jobs').delete().eq('id', id);
  if (error) throw new Error(error.message);
}

// ---- Leads (read-only inbox of website booking submissions) ----

export async function fetchLeads() {
  if (!supabase) return [];
  const { data, error } = await supabase.from('leads').select('*').order('created_at', { ascending: false });
  if (error) { console.error('[bcgd] fetchLeads', error.message); return []; }
  return data || [];
}

export async function deleteLead(id) {
  if (!supabase) return;
  const { error } = await supabase.from('leads').delete().eq('id', id);
  if (error) throw new Error(error.message);
}

// ---- Realtime ----

// Subscribe to any change on a table; returns an unsubscribe function.
export function subscribe(table, onChange) {
  if (!supabase) return () => {};
  const channel = supabase
    .channel(`bcgd:${table}`)
    .on('postgres_changes', { event: '*', schema: 'public', table }, onChange)
    .subscribe();
  return () => { supabase.removeChannel(channel); };
}
