# Life Summary Project

Personal life summary document for therapy sessions with Amanda.

## Structure
- `index.html` -- Living document. 32 sections, dual timeline (SVG desktop, HTML mobile), 21 inline SVG charts, 4 pull quotes, stats dashboard (12 figures), geography map. Auto light/dark. Print CSS for PDF export.
- `life.pdf` -- PDF export of index.html (regenerated via Chrome headless on each push)
- `timeline.svg` -- Standalone SVG timeline (deprecated, timeline now embedded in index.html)

## Sections (32 total)
1. Early Childhood & Family
2. Pull Quote A (aggression chart follows)
3. Anger & Conflict
4. Intrusive Memories, Nightmares, and Shame (trigger chart follows)
5. Sleep (sleep quality chart follows)
6. Siblings
7. Extended Family
8. Pets & Loss
9. Grief & Accumulated Loss (loss clustering chart follows)
10. School
11. Religion
12. ADHD and Autism
13. Sensory Profile (sensory heatmap follows)
14. Masking & Burnout
15. Medication
16. Previous Therapy (diagnosis gap chart follows)
17. Relationships (relationship periods chart follows)
18. Trust & Attachment (attachment spectrum chart follows)
19. Sexuality
20. Boundaries
21. Friendships (social circle chart follows)
22. Housing (pull quote B, housing chart follows)
23. Mental Health (pull quote C follows)
24. Substances (pull quote D, substance trajectory chart follows)
25. Coping (coping mechanisms chart follows)
26. Physical Health & Body
27. Identity & Worldview (stats grid follows)
28. Screen Time & Digital Life (screen time chart follows)
29. Current Life (daily routine chart follows)
30. Financial Reality (financial timeline chart follows)
31. Work History
32. Career & Projects (geography map follows)
33. Strengths & What Keeps You Going (strength bars chart follows)
34. What I Want from Therapy

## Visual Elements (27 total)
- Timeline (horizontal SVG desktop, vertical HTML mobile)
- Stability over time (line chart)
- Events by life phase (bar chart)
- Aggression timeline (segmented bar)
- Trigger intensity (bubble chart)
- Sleep quality over time (line chart)
- Loss event clustering (scatter/marker chart)
- Sensory sensitivity (heatmap grid)
- Diagnosis gap (dot timeline with 17-year gap)
- Relationship periods (span bars)
- Attachment spectrum (horizontal scale)
- Social circle over time (decline line chart)
- Housing stability (step chart)
- Substance use trajectory (area/line chart, weed + vaping)
- Coping mechanisms (diverging bar chart)
- Screen time by type (stacked bar)
- Daily routine (stacked bar)
- Financial support timeline (segmented bar)
- Strength bars (horizontal bars)
- Boundaries (horizontal bar, set vs respected)
- Energy budget (stacked horizontal bar, masking/coding/other)
- Same body (diverging bar, self-harm vs gym PRs)
- 4 pull quotes (isolated large text)
- Key figures stats grid (12 big numbers)
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
