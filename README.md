# inspire_blur

A modern, high-performance, GPU-friendly progressive blur for Flutter.

## Features

- Gradient-based blur
- Directional blur
- Impeller-optimized

## Usage

```dart
Inspire.childBlur(
  config: InspireBlurConfig.topToBottom(sigma: 10),
  child: Image(...),
)
```
