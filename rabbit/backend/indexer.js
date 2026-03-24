/**
 * Rabbit Indexer
 * Crawls local filesystem, extracts metadata, builds full-text index
 * Watches for file changes and updates index incrementally
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

class RabbitIndexer {
  constructor(indexPath = './index.json') {
    this.indexPath = indexPath;
    this.index = {
      files: {},        // filename -> { path, size, modified, tags, content }
      terms: {},        // term -> [fileIds]
      tags: {},         // tag -> [fileIds]
      metadata: {
        version: 1,
        lastIndexed: null,
        fileCount: 0,
      }
    };
    this.loadIndex();
  }

  loadIndex() {
    try {
      if (fs.existsSync(this.indexPath)) {
        const data = fs.readFileSync(this.indexPath, 'utf8');
        this.index = JSON.parse(data);
      }
    } catch (e) {
      console.error('Error loading index:', e.message);
    }
  }

  saveIndex() {
    try {
      fs.writeFileSync(this.indexPath, JSON.stringify(this.index, null, 2), 'utf8');
      console.log(`Index saved: ${this.indexPath}`);
    } catch (e) {
      console.error('Error saving index:', e.message);
    }
  }

  // Extract tags from YAML frontmatter (markdown files)
  extractFrontmatter(content) {
    const yamlRegex = /^---\n([\s\S]*?)\n---/;
    const match = content.match(yamlRegex);
    if (!match) return { tags: [], title: '' };

    const frontmatter = match[1];
    const tags = (frontmatter.match(/tags?\s*:\s*\[(.*?)\]/i) || ['', ''])[1]
      .split(',')
      .map(t => t.trim().toLowerCase())
      .filter(t => t);

    const titleMatch = frontmatter.match(/title\s*:\s*["']?([^"\n]+)["']?/i);
    const title = titleMatch ? titleMatch[1] : '';

    return { tags, title };
  }

  // Tokenize content for full-text search
  tokenize(text) {
    return text
      .toLowerCase()
      .split(/\W+/)
      .filter(token => token.length > 2);  // Skip short words
  }

  // Index a single file
  indexFile(filePath) {
    try {
      const stats = fs.statSync(filePath);
      if (stats.isDirectory()) return;

      const ext = path.extname(filePath).toLowerCase();
      const supportedExts = ['.md', '.txt', '.json', '.js', '.jsx', '.ts', '.tsx'];

      if (!supportedExts.includes(ext)) return;

      const content = fs.readFileSync(filePath, 'utf8');
      const relPath = path.relative(process.cwd(), filePath);
      const fileId = `${relPath}:${stats.mtimeMs}`;

      // Extract metadata
      let tags = [];
      let title = path.basename(filePath);

      if (ext === '.md') {
        const { tags: mdTags, title: mdTitle } = this.extractFrontmatter(content);
        tags = mdTags;
        title = mdTitle || title;
      }

      // Auto-tag by directory
      const dirTags = path.dirname(relPath).split('/').filter(d => d !== '.');
      tags = [...new Set([...tags, ...dirTags])];

      // Tokenize and index
      const tokens = this.tokenize(content);
      tokens.forEach(token => {
        if (!this.index.terms[token]) {
          this.index.terms[token] = [];
        }
        if (!this.index.terms[token].includes(fileId)) {
          this.index.terms[token].push(fileId);
        }
      });

      // Index tags
      tags.forEach(tag => {
        if (!this.index.tags[tag]) {
          this.index.tags[tag] = [];
        }
        if (!this.index.tags[tag].includes(fileId)) {
          this.index.tags[tag].push(fileId);
        }
      });

      // Store file metadata
      this.index.files[fileId] = {
        path: relPath,
        title,
        size: stats.size,
        modified: stats.mtimeMs,
        tags,
        snippet: content.substring(0, 200),
      };

      console.log(`Indexed: ${relPath}`);
    } catch (e) {
      console.error(`Error indexing ${filePath}:`, e.message);
    }
  }

  // Crawl directory recursively
  crawl(dirPath, ignore = ['.git', 'node_modules', '.vercel', 'dist']) {
    try {
      const items = fs.readdirSync(dirPath);
      items.forEach(item => {
        if (ignore.includes(item)) return;

        const fullPath = path.join(dirPath, item);
        const stats = fs.statSync(fullPath);

        if (stats.isDirectory()) {
          this.crawl(fullPath, ignore);
        } else {
          this.indexFile(fullPath);
        }
      });
    } catch (e) {
      console.error(`Error crawling ${dirPath}:`, e.message);
    }
  }

  // Search with BM25-style ranking (simplified)
  search(query, limit = 20) {
    const tokens = this.tokenize(query);
    const results = new Map();

    tokens.forEach(token => {
      const fileIds = this.index.terms[token] || [];
      fileIds.forEach(fileId => {
        const score = (results.get(fileId) || 0) + 1;
        results.set(fileId, score);
      });
    });

    // Sort by score, return with metadata
    return Array.from(results.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, limit)
      .map(([fileId, score]) => ({
        fileId,
        score,
        ...this.index.files[fileId],
      }));
  }

  // Search by tag
  searchByTag(tag, limit = 20) {
    const fileIds = this.index.tags[tag.toLowerCase()] || [];
    return fileIds
      .slice(0, limit)
      .map(fileId => ({
        fileId,
        score: 1,
        ...this.index.files[fileId],
      }));
  }

  // Get index stats
  stats() {
    return {
      files: Object.keys(this.index.files).length,
      terms: Object.keys(this.index.terms).length,
      tags: Object.keys(this.index.tags).length,
      lastIndexed: this.index.metadata.lastIndexed,
    };
  }
}

module.exports = RabbitIndexer;
