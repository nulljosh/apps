import { useState } from 'react';
import { JOB_STATUSES } from '../lib/storage';

const STATUS_COLORS = {
  Lead: '#0071e3',
  Quote: '#ff9500',
  Scheduled: '#34c759',
  Complete: '#2d6b6b',
  Paid: '#34c759',
};

export default function JobList({ jobs, onEdit, onDelete, onAdvance }) {
  const [statusFilter, setStatusFilter] = useState('All');

  const filtered = statusFilter === 'All'
    ? jobs
    : jobs.filter(j => j.status === statusFilter);

  if (jobs.length === 0) {
    return (
      <div className="empty-state animate__animated animate__fadeIn">
        <h2>No jobs yet</h2>
        <p>Add your first job to start tracking work.</p>
      </div>
    );
  }

  return (
    <div className="job-list">
      <div className="job-filter-bar">
        <select
          value={statusFilter}
          onChange={e => setStatusFilter(e.target.value)}
          className="category-select"
        >
          <option value="All">All Statuses</option>
          {JOB_STATUSES.map(s => <option key={s} value={s}>{s}</option>)}
        </select>
        <span className="job-filter-count">{filtered.length} job{filtered.length !== 1 ? 's' : ''}</span>
      </div>

      {filtered.map((j, i) => (
        <div
          key={j.id}
          className="job-row glass-card animate__animated animate__fadeInUp"
          style={{ animationDelay: `${Math.min(i * 0.03, 0.2)}s` }}
        >
          <div className="job-row-main">
            <div className="job-row-left">
              <span className="job-client">{j.client}</span>
              {j.service && <span className="job-service">{j.service}</span>}
              {j.phone && <span className="job-phone mono">{j.phone}</span>}
            </div>
            <div className="job-row-right">
              <span
                className="job-status-badge"
                style={{
                  background: `${STATUS_COLORS[j.status]}18`,
                  color: STATUS_COLORS[j.status],
                }}
              >
                {j.status}
              </span>
              {j.value > 0 && (
                <span className="job-value">${Number(j.value).toLocaleString('en-US', { minimumFractionDigits: 2 })}</span>
              )}
              {j.date && <span className="job-date mono">{j.date}</span>}
            </div>
          </div>
          {j.notes && <p className="job-notes">{j.notes}</p>}
          <div className="job-row-actions">
            {j.status !== JOB_STATUSES[JOB_STATUSES.length - 1] && (
              <button
                className="btn job-advance-btn"
                onClick={() => onAdvance(j.id)}
                title={`Advance to ${JOB_STATUSES[JOB_STATUSES.indexOf(j.status) + 1]}`}
              >
                Advance
              </button>
            )}
            <button className="btn-icon" onClick={() => onEdit(j)} title="Edit" aria-label="Edit job">
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M10.5 1.5L12.5 3.5L4.5 11.5L1.5 12.5L2.5 9.5Z" stroke="currentColor" strokeWidth="1.2" strokeLinejoin="round"/>
              </svg>
            </button>
            <button className="btn-icon btn-danger" onClick={() => onDelete(j.id)} title="Delete" aria-label="Delete job">
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <line x1="3" y1="3" x2="11" y2="11" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
                <line x1="11" y1="3" x2="3" y2="11" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
              </svg>
            </button>
          </div>
        </div>
      ))}
    </div>
  );
}
