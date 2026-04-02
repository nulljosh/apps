export default function ResultNode({ data }) {
  const { title, url, snippet, isMath } = data;

  if (isMath) {
    return (
      <div className="result-node math-node">
        <div className="result-math-value">{title}</div>
        <div className="result-math-label">Math Result</div>
      </div>
    );
  }

  return (
    <a
      href={url}
      target="_blank"
      rel="noopener noreferrer"
      className="result-node"
      title={url}
    >
      <div className="result-title">{title}</div>
      {snippet && <div className="result-snippet">{snippet}</div>}
      {url && <div className="result-domain">{extractDomain(url)}</div>}
    </a>
  );
}

function extractDomain(url) {
  try {
    return new URL(url).hostname.replace(/^www\./, '');
  } catch {
    return '';
  }
}
