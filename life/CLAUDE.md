# Life Summary Project

Personal life summary document for therapy sessions with Amanda.

## Structure
- `index.html` -- Living document. 21 sections, dual timeline (SVG desktop, HTML mobile). Auto light/dark. Print CSS for PDF export.
- `life.pdf` -- PDF export of index.html (regenerated via Chrome headless on each push)
- `timeline.svg` -- Standalone SVG timeline (deprecated, timeline now embedded in index.html)

## Design
- Cloned from heyitsmejosh.com: minimal borders, system fonts, 200-weight display heading
- Light: #fafafa bg, #000 text. Dark: #111 bg, #e8e8e8 text.
- Cards use border-top separators, no glass/blur
- Fade-up scroll animations (IntersectionObserver), prefers-reduced-motion supported
- Mobile-first: HTML timeline on mobile, horizontal SVG on desktop (600px+)
- Safe area insets for notched phones

## Notes
- Private, sensitive document
- Content covers childhood trauma, PTSD, relationships, mental health, neurodivergence, substance use, career goals, neuroscience research citations
- No em dashes in content. Match Joshua's casual writing voice.
- Timeline color coding: red = crisis, black = life event, green = positive/forward
