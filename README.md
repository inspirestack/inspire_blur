# inspire_blur

**A modern, high-performance progressive blur for Flutter — powered by custom GPU shaders.**

<p align="center">
  <img src="https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/readme/header.webp" width="800" />
</p>

Inspire Blur is a simple, flexible, and efficient way to add progressive blur effects in Flutter.

It comes with a clean, ready-to-use API.

Inspire Blur is designed to handle many of the common challenges of applying blur and shader-based effects in Flutter — such as performance trade-offs, layout edge cases, and rendering inconsistencies across environments.

## Demo

<div align="center">
  <table>
    <tr>
      <td align="center">
        <h4>Backdrop blur — scene effect</h4>
        <img
          src="https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/readme/backdrop_blur.gif"
          alt="Backdrop blur demo"
          width="230"
        />
        <br />
        <a href="https://inspirestack.app/inspire-blur/showcase/backdrop-blur" target="_blank" rel="noopener">
          🔗 Watch hi-res video
        </a>
      </td>
      <td align="center">
        <h4>Child blur — component effect</h4>
        <img
          src="https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/readme/child_blur.gif"
          alt="Child blur demo"
          width="500"
        />
        <br />
        <a href="https://inspirestack.app/inspire-blur/showcase/child-blur" target="_blank" rel="noopener">
          🔗 Watch hi-res video
        </a>
      </td>
    </tr>
  </table>
</div>

See the example app for interactive demos, including both backdrop and child blur in real-world scenarios.

## Blur modes

Inspire Blur supports two modes:

- **Backdrop blur** — blurs the content that’s _behind_ it.
- **Child blur** — blurs the content that’s _inside_ it.

---

**Backdrop blur** works best when applied over large, dynamic areas, such as screens, scaffolds, lists, grids, or carousels. It blurs any content rendered beneath it, making it ideal for scene-level effects.

A common use case is a top screen fade that blurs the content near the status bar and gradually fades out from top to bottom.

---

**Child blur** is ideal for standalone UI elements like cards, images, or small components. It works by wrapping the widget that should be blurred.

An example use case is a card with an image and text on top — where the blur effect improves text legibility.

## Features

- Gradient-based progressive blur
- Scene-level and component-level blur modes
- GPU-accelerated custom shader implementation
- Optimized for Impeller
- Automatic runtime fallback handling
- Flexible directional blur configuration
- Preset utilities for common blur layouts
- Handles complex UI layering (Stacks, Gradients, and Overlays)

## Choosing a blur mode

- Use **Backdrop blur** for full-screen or scene-level effects
- Use **Child blur** for individual components (cards, images, etc.)

## Usage

To get started, import the package:

```dart
import 'package:inspire_blur/inspire_blur.dart';
```

### Applying child blur

Wrap the widget that should be blurred with `Inspire.childBlur()`.

```dart
Inspire.childBlur(
  config: InspireBlurConfig(), // Blur configuration
  child: MyWidget(), // Widget to be blurred
)
```

### Applying backdrop blur

Add `Inspire.backdropBlur()` to the same `Stack` as the content that should be blurred.

The blur widget must be added after the other widgets in the stack so it renders above them.

```dart
Stack(
  children: [
    MyWidget(), // Widget(s) to be blurred
    Inspire.backdropBlur(
      config: InspireBlurConfig(), // Blur configuration
    ),
  ],
);
```

### Preload shaders (optional)

It is recommended to call `Inspire.warmUp()` during app startup to ensure blur effects render immediately when first displayed.

### Preset utilities

Inspire Blur config includes ready-to-use presets for the most typical use cases.

They provide an easy way to apply progressive blur in common directions.

```dart
InspireBlurConfig.topToBottom()
InspireBlurConfig.bottomToTop()
InspireBlurConfig.leftToRight()
InspireBlurConfig.rightToLeft()
```

There is also a factory for arbitrary directions:

```dart
InspireBlurConfig.directional()
```

Blur can also be distributed evenly using:

```dart
InspireBlurConfig.uniform()
```

The directional blur factories allow you to customize the blur extent and fade curve.

#### Sigma

Blur strength is defined by sigma values:

- `sigma` — uniform blur (both directions)
- `sigmaX` — horizontal blur
- `sigmaY` — vertical blur

Note: `sigma` cannot be combined with `sigmaX` or `sigmaY`

Using only `sigmaX` produces a horizontal blur, while using only `sigmaY` produces a vertical blur.

| Configuration   | Usage                                                    |
| :-------------- | :------------------------------------------------------- |
| **Uniform**     | Provide `sigma` for equal blur on both axes.             |
| **Directional** | Provide `sigmaX` or `sigmaY` for single-axis blur.       |
| **Asymmetric**  | Provide both `sigmaX` and `sigmaY` for varying strength. |

_Examples:_

```dart
// Correct:
InspireBlurConfig.topToBottom(sigma: 8) // Same strength on both axes
InspireBlurConfig.topToBottom(sigmaX: 8) // Horizontal blur
InspireBlurConfig.topToBottom(sigmaY: 8) // Vertical blur
InspireBlurConfig.topToBottom(sigmaX: 8, sigmaY: 5) // More horizontal strength

// Incorrect:
InspireBlurConfig.topToBottom() // No sigma values provided
InspireBlurConfig.topToBottom(sigma: 5, sigmaX: 3) // 2D and 1D sigma cannot be used together

// Not recommended:
InspireBlurConfig.topToBottom(sigmaX: 5, sigmaY: 5) // Same as `sigma: 5`
```

#### Blur extent

Progressive blur does not have to span the entire area. To shorten the spread of the blur effect, use the `extent` property. It specifies the point at which the blur effect stops.

For example:

- 0.0 → no blur is visible
- 0.5 → blur stops halfway
- 1.0 → blur spans the entire area

#### Fade curve

The blur strength is distributed according to the selected fade curve, allowing you to fine-tune how quickly the blur intensity increases across the area.

The default is `Curves.easeInSine`, which produces a natural, gradual fade compared to the standard linear curve.

## How it works

### Backdrop blur

`Inspire.backdropBlur()` is a widget that blurs everything displayed beneath it.

It is built on top of Flutter’s `BackdropFilter` widget. It applies the custom blur shader via `ImageFilter.shader`.

A typical way to use `Inspire.backdropBlur()` is to add it to a `Stack` on top of the content that needs to be blurred. Make sure it is the last widget in the stack so it renders above the content.

### Child blur

`Inspire.childBlur()` is a widget that blurs everything inside it.

It has two modes:

- `InspireBlurMode.imageFilter`
- `InspireBlurMode.animatedSampler`

Each one uses a different underlying mechanism to render the blur effect.

These two modes have different trade-offs in terms of rendering accuracy, performance, and compatibility.

To let Inspire Blur choose the best mode automatically, use the default `InspireBlurMode.auto` which will determine the most suitable mode at runtime.

- The `imageFilter` is advised for static and complex layouts. It is more tightly integrated with the rendering pipeline, making it more stable for complex layouts with stacks, shadows, and layered effects.
- The `animatedSampler` is advised for scrollable content and simple layouts. It provides better accuracy for elements of lists, grids, carousels, etc. It may produce less accurate results for complex widgets, especially those using stacks and shadows.

_Note that `imageFilter` is only supported on Impeller. If it’s chosen and Impeller is not available, `animatedSampler` will be used instead._

## Performance

Designed with performance in mind, Inspire Blur minimizes GPU cost while maintaining high visual quality.

Inspire Blur relies on custom GPU shaders to achieve efficient blur rendering while allowing a high degree of customization. Each shader uses a lightweight one-dimensional convolution kernel, making the implementation GPU-friendly.

For uniform blur, horizontal and vertical passes are combined to approximate a 2D blur effect. Stacking two 1D blur passes is typically more efficient than a single 2D blur pass, especially for large sigma values. The resulting visual quality is generally on par with full 2D convolution.

### Performance precautions

Both Backdrop blur and Child blur can be used together within the same screen. They will render correctly even when overlapping.

However, this comes with an associated performance cost. Using a large number of blur effects in a single scene may impact performance due to the need to allocate additional resources, such as framebuffers or save layers. This is particularly relevant in complex layouts or scrollable content where multiple layers are recomposited frequently.

If you encounter performance issues, consider reducing the blur sigma or limiting the area where the effect is applied. Additionally, limit the number of distinct blur effects displayed at once.

### Troubleshooting

#### My blur effect is too slow or starts lagging

Limit the number of distinct blur effects used on a single screen. Each additional blur increases GPU workload and rendering cost. Combining backdrop blur and child blur on the same screen may also introduce additional overhead. If you still experience bad performance, consider lowering the sigma value.

#### There is jank when blur is first rendered

Make sure to call `Inspire.warmUp()` before rendering blur effects. A recommended place is during app startup, such as a splash screen.

#### I'm getting visual artifacts, such as overblown shadows

Try using child blur with `InspireBlurMode.imageFilter`. This mode provides more accurate rendering in certain scenarios, but is currently only available on the Impeller engine.

#### Child blur appears inaccurate while scrolling

Try using `InspireBlurMode.animatedSampler`, which works better in scrollable widgets and dynamically changing layouts.

### Best practices

#### Optimize first launch

It is recommended to call `Inspire.warmUp()` during app startup, for example on a splash screen. This function preloads the shaders used by the effects.

While not required, this is a useful optimization that ensures the blur effect renders immediately when first used, avoiding potential frame drops — especially on lower-end devices.

#### Reduce sigma on lower-end devices

Consider choosing lower sigma values for better performance. On lower-end devices, sigma values above `8–13` may become expensive depending on the layout complexity and number of active blur effects.

#### Scale sigma with screen resolution

Blur strength is perceived differently depending on the screen resolution. On smaller screens, lower sigma values may produce a visually similar result to higher sigma values on larger screens.
