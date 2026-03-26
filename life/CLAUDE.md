# Life Summary Project

Personal life summary document for therapy sessions with Amanda.

## Structure
- `index.html` -- Living document. 20 sections, dual timeline (SVG desktop, HTML mobile), 10 inline SVG charts, 3 pull quotes, stats dashboard, geography map. Auto light/dark. Print CSS for PDF export.
- `life.pdf` -- PDF export of index.html (regenerated via Chrome headless on each push)
- `timeline.svg` -- Standalone SVG timeline (deprecated, timeline now embedded in index.html)

## Visual Elements (15 total)
- Timeline (horizontal SVG desktop, vertical HTML mobile)
- Stability over time (line chart)
- Events by life phase (bar chart)
- Aggression timeline (segmented bar)
- Trigger intensity (bubble chart)
- Diagnosis gap (dot timeline with 17-year gap)
- Relationship periods (span bars)
- Social circle over time (decline line chart)
- Housing stability (step chart)
- Coping mechanisms (diverging bar chart)
- Daily routine (stacked bar)
- 3 pull quotes (isolated large text)
- Key figures stats grid (6 big numbers)
- Geography map (BC + off-map locations)

## Design
- Cloned from heyitsmejosh.com: minimal borders, system fonts, 200-weight display heading
- Light: #fafafa bg, #000 text. Dark: #111 bg, #e8e8e8 text.
- Cards use border-top separators, no glass/blur
- Fade-up scroll animations (IntersectionObserver), prefers-reduced-motion supported
- Mobile-first: HTML timeline on mobile, horizontal SVG on desktop (600px+)
- Safe area insets for notched phones
- 50/50 split between text sections and visual elements

## Notes
- Private, sensitive document
- Content covers childhood trauma, PTSD, relationships, mental health, neurodivergence, substance use, career goals, neuroscience research citations
- No em dashes in content. Match Joshua's casual writing voice.
- Timeline color coding: red = crisis, black = life event, green = positive/forward
- Charts use same color system, CSS variables for light/dark, responsive viewBox
