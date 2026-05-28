export default function CustomerList({ jobs }) {
  const seen = new Map();
  jobs.forEach(j => {
    if (!j.customer) return;
    const key = j.customer.toLowerCase().trim();
    if (!seen.has(key)) {
      seen.set(key, { name: j.customer, phone: j.phone, jobs: [] });
    }
    seen.get(key).jobs.push(j);
  });

  const customers = [...seen.values()].sort((a, b) => a.name.localeCompare(b.name));

  if (!customers.length) return null;

  return (
    <div className="customer-list glass-card">
      {customers.map((c, i) => (
        <div key={i} className="customer-row">
          <div className="customer-info">
            <span className="customer-name">{c.name}</span>
            {c.phone && <a href={`tel:${c.phone}`} className="customer-phone">{c.phone}</a>}
          </div>
          <div className="customer-meta">
            <span className="customer-job-count">{c.jobs.length} job{c.jobs.length !== 1 ? 's' : ''}</span>
            <div className="customer-job-statuses">
              {c.jobs.map(j => (
                <span key={j.id} className="customer-job-service">{j.service || j.status}</span>
              ))}
            </div>
          </div>
        </div>
      ))}
    </div>
  );
}
