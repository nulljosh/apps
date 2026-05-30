// SnapTrade adapter — read-only brokerage sync (holdings, balances).
// Server-side only (node:crypto + fetch). Official aggregator API, ToS-clean.
// Covers Wealthsimple/Questrade (CA) + US brokers under one connection.
// Docs: https://docs.snaptrade.com — request signing is HMAC-SHA256 over
// { content, path, query }, base64-encoded, sent as the `Signature` header.
//
// This adapter is intentionally read-only: placeOrder throws. Order routing
// is a separate, opt-in step gated behind the paper-trading proving period.

import crypto from 'node:crypto';

const BASE = 'https://api.snaptrade.com';
const API = '/api/v1';

export class SnapTradeAdapter {
  constructor(config = {}) {
    this.name = 'snaptrade';
    this.clientId = config.clientId || process.env.SNAPTRADE_CLIENT_ID || null;
    this.consumerKey = config.consumerKey || process.env.SNAPTRADE_CONSUMER_KEY || null;
    this.userId = config.userId || null;
    this.userSecret = config.userSecret || null;
    this.connected = false;
  }

  static isConfigured() {
    return Boolean(process.env.SNAPTRADE_CLIENT_ID && process.env.SNAPTRADE_CONSUMER_KEY);
  }

  _sign(path, query, content) {
    const sigObject = { content: content ?? null, path, query };
    const payload = JSON.stringify(sigObject);
    return crypto.createHmac('sha256', this.consumerKey).update(payload).digest('base64');
  }

  async _request(method, path, { query = {}, body = null } = {}) {
    if (!this.clientId || !this.consumerKey) throw new Error('[SnapTrade] Missing clientId or consumerKey');

    const params = new URLSearchParams({
      clientId: this.clientId,
      timestamp: String(Math.floor(Date.now() / 1000)),
      ...query,
    });
    const queryString = params.toString();
    const fullPath = `${API}${path}`;
    const signature = this._sign(fullPath, queryString, body);

    const res = await fetch(`${BASE}${fullPath}?${queryString}`, {
      method,
      headers: { 'Content-Type': 'application/json', Signature: signature },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`[SnapTrade] ${method} ${path} failed: ${res.status} ${text}`);
    }
    return res.json();
  }

  // Register a SnapTrade user. Returns { userId, userSecret } — persist the secret.
  async registerUser(userId) {
    const data = await this._request('POST', '/snapTrade/registerUser', { body: { userId } });
    this.userId = data.userId;
    this.userSecret = data.userSecret;
    return data;
  }

  // Hosted connection portal URL for the user to link a brokerage.
  async loginLink() {
    this._requireUser();
    const data = await this._request('POST', '/snapTrade/login', {
      query: { userId: this.userId, userSecret: this.userSecret },
    });
    return data.redirectURI;
  }

  async connect() {
    this._requireUser();
    this.connected = true;
    return true;
  }

  async listAccounts() {
    this._requireUser();
    return this._request('GET', '/accounts', {
      query: { userId: this.userId, userSecret: this.userSecret },
    });
  }

  // Normalized holdings across all linked accounts: { symbol, shares, marketValue, account }.
  // Uses /positions — the combined /holdings endpoint was retired by SnapTrade (410 Gone).
  async getHoldings() {
    const accounts = await this.listAccounts();
    const holdings = [];
    for (const acct of accounts) {
      const positions = await this._request('GET', `/accounts/${acct.id}/positions`, {
        query: { userId: this.userId, userSecret: this.userSecret },
      });
      for (const pos of positions ?? []) {
        const symbol = pos.symbol?.symbol?.symbol ?? pos.symbol?.symbol ?? pos.symbol ?? null;
        if (!symbol) continue;
        holdings.push({
          symbol,
          shares: Number(pos.units ?? 0),
          marketValue: pos.price != null ? Number(pos.price) * Number(pos.units ?? 0) : null,
          account: acct.name || acct.id,
        });
      }
    }
    return holdings;
  }

  // Total cash across accounts plus per-account/currency breakdown.
  async getBalance() {
    const accounts = await this.listAccounts();
    let total = 0;
    const accountsOut = [];
    for (const acct of accounts) {
      const balances = await this._request('GET', `/accounts/${acct.id}/balances`, {
        query: { userId: this.userId, userSecret: this.userSecret },
      });
      for (const b of balances ?? []) {
        const cash = Number(b.cash ?? 0);
        total += cash;
        accountsOut.push({ account: acct.name || acct.id, currency: b.currency?.code ?? null, cash });
      }
    }
    return { total, accounts: accountsOut };
  }

  async placeOrder() {
    throw new Error('[SnapTrade] read-only adapter — order routing is not enabled');
  }

  _requireUser() {
    if (!this.userId || !this.userSecret) {
      throw new Error('[SnapTrade] No userId/userSecret — call registerUser() first');
    }
  }
}
