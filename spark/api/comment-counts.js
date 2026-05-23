const { getCommentCounts } = require('./comments');

module.exports = async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const postIds = (req.query.post_ids || '').split(',').filter(Boolean);
  if (postIds.length === 0) {
    return res.status(400).json({ error: 'post_ids is required' });
  }

  try {
    const counts = await getCommentCounts(postIds);
    return res.status(200).json({ counts });
  } catch (err) {
    console.error('[COMMENT-COUNTS] Fetch failed:', err.message);
    return res.status(500).json({ error: 'Failed to fetch comment counts' });
  }
};
