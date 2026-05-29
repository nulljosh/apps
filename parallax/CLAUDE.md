# Parallax

Head-tracked 3D parallax browser app. Single HTML file, no build step.

## Stack
- MediaPipe Tasks Vision (CDN) — FaceLandmarker, GPU delegate
- CSS 3D transforms — `preserve-3d`, `translateZ`, `rotateX/Y`
- No framework, no backend

## Key files
- `index.html` — entire app (detection loop + scene)

## How the tracking works
Nose tip (landmark index 1) gives normalized x,y,z. Center (0.5) maps to 0 offset.
LERP constant `SMOOTH = 0.12` — increase for snappier, decrease for smoother.
Rotation limits: rotY ±20deg, rotX ±15deg. Z shift scales by 300px.

## To run
Open `index.html` directly in Chrome/Safari. Camera permission required.
No localhost needed — MediaPipe loads from CDN.

## Roadmap
- Scene editor with depth-per-layer control
- Distance calibration for zoom
- Mobile front-camera support
