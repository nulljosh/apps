# Charters

v1.1.0 — Constitutional Rights Reference

## Deploy

```bash
cd apps/charters && npx vercel --prod
# or from monorepo root:
npx vercel --prod --cwd apps/charters
```

Domain: charters.heyitsmejosh.com  
Vercel project: charters (output dir: ., no build step)

## Structure

Single-file web app: `index.html`  
iOS companion: `../charters-ios/`

## Data format

```js
D = [{
  id: 'CA',           // ISO country code
  name: 'Canada',
  region: 'North America',
  docs: [{
    id: 'charter',
    title: 'Canadian Charter of Rights and Freedoms',
    year: 1982,
    parent: 'Constitution Act, 1982',
    arts: [{
      ref: 'Section 2',
      title: 'Fundamental Freedoms',
      tags: ['civil', 'political'],
      text: '...'
    }]
  }]
}]
```

Tags: `civil`, `political`, `economic`, `social`, `cultural`

## Map

SVG world map at viewBox="0 0 960 500". Country paths use class `co` (has data) or `eu` (EU outline).  
Map labels use class `ml`. Adding a country requires: SVG `<path>` + `<text>` + data entry in `D[]`.

## Views

- `CV = 'map'` — world map
- `CV = 'list'` — card grid
- `CV = 'compare'` — two-column side-by-side

## URL state

- `#CA` → open panel for country CA
- `#compare/CA,US` → compare view

## iOS

See `../charters-ios/CLAUDE.md`
