const CACHE_VERSION = 'lingo-v1';

const APP_SHELL = [
    './',
    './index.html',
    './js/lingo-app.js',
    './js/lingo-data.js',
    './assets/icon.svg',
    './manifest.json'
];

const CDN_ASSETS = [
    'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_VERSION).then((cache) => {
            return cache.addAll([...APP_SHELL, ...CDN_ASSETS]);
        })
    );
    self.skipWaiting();
});

self.addEventListener('activate', (event) => {
    event.waitUntil(
        caches.keys().then((keys) => {
            return Promise.all(
                keys.filter((key) => key !== CACHE_VERSION).map((key) => caches.delete(key))
            );
        })
    );
    self.clients.claim();
});

self.addEventListener('fetch', (event) => {
    const url = new URL(event.request.url);

    if (url.origin === location.origin) {
        // App shell: cache-first, update in background
        event.respondWith(
            caches.match(event.request).then((cached) => {
                const fetched = fetch(event.request).then((response) => {
                    if (response.ok) {
                        const clone = response.clone();
                        caches.open(CACHE_VERSION).then((cache) => cache.put(event.request, clone));
                    }
                    return response;
                }).catch(() => cached);
                return cached || fetched;
            })
        );
    } else {
        // CDN: stale-while-revalidate
        event.respondWith(
            caches.match(event.request).then((cached) => {
                const fetched = fetch(event.request).then((response) => {
                    if (response.ok) {
                        const clone = response.clone();
                        caches.open(CACHE_VERSION).then((cache) => cache.put(event.request, clone));
                    }
                    return response;
                }).catch(() => cached);
                return cached || fetched;
            })
        );
    }
});
