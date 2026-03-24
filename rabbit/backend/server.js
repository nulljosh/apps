/**
 * Rabbit API Server
 * Exposes search and indexing APIs via HTTP
 * Runs locally for development, can be deployed to handle queries
 */

const express = require('express');
const cors = require('cors');
const RabbitIndexer = require('./indexer');
const chokidar = require('chokidar');
const path = require('path');

const app = express();
const indexer = new RabbitIndexer('./index.json');

app.use(cors({ origin: ['http://localhost:3000', 'http://localhost:5173'] }));
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', stats: indexer.stats() });
});

// Full-text search
app.get('/api/search', (req, res) => {
  const query = req.query.q || '';
  if (!query.trim()) {
    return res.json({ results: [], query });
  }

  const results = indexer.search(
    query,
    Math.min(Math.max(parseInt(req.query.limit) || 20, 1), 100)
  );
  res.json({ results, query });
});

// Tag search
app.get('/api/search/tag/:tag', (req, res) => {
  const tag = req.params.tag;
  const results = indexer.searchByTag(
    tag,
    Math.min(Math.max(parseInt(req.query.limit) || 20, 1), 100)
  );
  res.json({ results, tag });
});

// List all available tags
app.get('/api/tags', (req, res) => {
  const tags = Object.keys(indexer.index.tags).sort();
  res.json({ tags });
});

// Get file content by fileId
app.get('/api/file/:fileId', (req, res) => {
  const fileId = decodeURIComponent(req.params.fileId);
  const file = indexer.index.files[fileId];

  if (!file) {
    return res.status(404).json({ error: 'File not found' });
  }

  const resolvedPath = path.resolve(file.path);
  const allowedDir = path.resolve(process.cwd());
  if (!resolvedPath.startsWith(allowedDir + path.sep)) {
    return res.status(403).json({ error: 'Access denied' });
  }

  try {
    const content = require('fs').readFileSync(file.path, 'utf8');
    res.json({ file, content });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Rebuild index
app.post('/api/reindex', (req, res) => {
  const startDir = req.body.dir || '.';
  const resolvedDir = path.resolve(startDir);
  if (!resolvedDir.startsWith(path.resolve(process.cwd()) + path.sep)) {
    return res.status(403).json({ error: 'Invalid directory' });
  }
  console.log(`Reindexing from: ${startDir}`);
  indexer.index = {
    files: {},
    terms: {},
    tags: {},
    metadata: { version: 1, lastIndexed: new Date().toISOString(), fileCount: 0 },
  };
  indexer.crawl(startDir);
  indexer.saveIndex();
  res.json({ stats: indexer.stats() });
});

// Watch for file changes (incremental indexing)
function watchDirectory(dirPath) {
  const watcher = chokidar.watch(dirPath, {
    ignored: /(^|[/\\])\.|node_modules|\.git|\.vercel|dist/,
    persistent: true,
  });

  watcher.on('change', (filePath) => {
    console.log(`File changed: ${filePath}`);
    indexer.indexFile(filePath);
    indexer.saveIndex();
  });

  watcher.on('add', (filePath) => {
    console.log(`File added: ${filePath}`);
    indexer.indexFile(filePath);
    indexer.saveIndex();
  });
}

// Start server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Rabbit Indexer running on http://localhost:${PORT}`);
  console.log(`Stats: ${JSON.stringify(indexer.stats())}`);

  // Watch current directory for changes
  watchDirectory(process.cwd());
});
