const FEEDS_KEY = 'fuse_cal_feeds'
const KEY_STORE = 'fuse_enc_key'

async function getCryptoKey() {
  const stored = localStorage.getItem(KEY_STORE)
  if (stored) {
    const raw = Uint8Array.from(atob(stored), c => c.charCodeAt(0))
    return crypto.subtle.importKey('raw', raw, 'AES-GCM', false, ['encrypt', 'decrypt'])
  }
  const key = await crypto.subtle.generateKey({ name: 'AES-GCM', length: 256 }, true, ['encrypt', 'decrypt'])
  const exported = await crypto.subtle.exportKey('raw', key)
  localStorage.setItem(KEY_STORE, btoa(String.fromCharCode(...new Uint8Array(exported))))
  return key
}

async function encryptUrl(key, url) {
  const iv = crypto.getRandomValues(new Uint8Array(12))
  const ct = await crypto.subtle.encrypt({ name: 'AES-GCM', iv }, key, new TextEncoder().encode(url))
  return {
    iv: btoa(String.fromCharCode(...iv)),
    ct: btoa(String.fromCharCode(...new Uint8Array(ct)))
  }
}

async function decryptUrl(key, { iv, ct }) {
  const ivBuf = Uint8Array.from(atob(iv), c => c.charCodeAt(0))
  const ctBuf = Uint8Array.from(atob(ct), c => c.charCodeAt(0))
  const plain = await crypto.subtle.decrypt({ name: 'AES-GCM', iv: ivBuf }, key, ctBuf)
  return new TextDecoder().decode(plain)
}

export async function loadFeeds() {
  try {
    const raw = JSON.parse(localStorage.getItem(FEEDS_KEY) || '[]')
    if (!raw.length) return []
    if (typeof raw[0].url === 'string') {
      // Legacy plaintext -- migrate to encrypted in place
      const key = await getCryptoKey()
      const encrypted = await Promise.all(raw.map(async f => ({ ...f, url: await encryptUrl(key, f.url) })))
      localStorage.setItem(FEEDS_KEY, JSON.stringify(encrypted))
      return raw
    }
    const key = await getCryptoKey()
    return Promise.all(raw.map(async f => ({ ...f, url: await decryptUrl(key, f.url) })))
  } catch {
    return []
  }
}

export async function saveFeeds(feeds) {
  const key = await getCryptoKey()
  const encrypted = await Promise.all(
    feeds.map(async f => ({ ...f, url: await encryptUrl(key, f.url) }))
  )
  localStorage.setItem(FEEDS_KEY, JSON.stringify(encrypted))
}
