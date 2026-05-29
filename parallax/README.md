<img src="icon.svg" width="80">

# Parallax

![v0.1.0](https://img.shields.io/badge/version-0.1.0-blue) ![MIT](https://img.shields.io/badge/license-MIT-green)

Head-tracked 3D parallax for the browser. Your webcam watches your face. As you move your head, the scene shifts perspective in real time — left, right, up, down, closer, further. Pure CSS 3D transforms, no canvas, no backend.

## How it works

MediaPipe FaceLandmarker runs on-device (GPU delegate) and tracks 478 face landmarks at ~30fps. Nose tip position (landmark 1) maps to `rotateX`, `rotateY`, and `translateZ` on a `preserve-3d` scene. LERP smoothing removes jitter.

```
webcam → MediaPipe FaceLandmarker → nose x,y,z → LERP → CSS rotateX/Y + translateZ
```

## Usage

Open `index.html` in any modern browser. Grant camera permission. Move your head.

No build step. No dependencies to install. Ships as a single HTML file.

## Roadmap

- [ ] Scene editor — drag/drop layers, set depth per element
- [ ] Custom background support (image/video)
- [ ] Distance-based auto-zoom calibration
- [ ] Export scene as embeddable snippet
- [ ] Mobile support via front camera

## Architecture

![architecture](architecture.svg)

## License

MIT 2026, Joshua Trommel
