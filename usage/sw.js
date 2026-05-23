const CACHE_NAME = 'usage-v1';
const ASSETS = [
  '/',
  '/index.html',
  '/css/usage.css',
  '/js/store.js',
  '/js/stats.js',
  '/js/charts.js',
  '/js/app.js',
  '/manifest.json',
  '/icon.svg'
];

self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(ASSETS))
      .then(() => self.skipWaiting())
      .catch((err) => console.error('SW install failed:', err))
  );
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(
        keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (e) => {
  if (e.request.method !== 'GET') return;
  e.respondWith(
    caches.match(e.request)
      .then((cached) => cached || fetch(e.request))
      .catch(() => caches.match('/index.html'))
  );
});
