# inspire_blur

**A modern, high-performance progressive blur for Flutter — powered by custom GPU shaders.**

<p align="center">
  <img src="https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/readme/header.webp" width="800">
</p>

Inspire Blur is a simple, flexible, and efficient way to add gradually fading blur effects in Flutter.

It comes with a clean, ready-to-use API.

Inspire Blur is designed to handle many of the common challenges of applying variable blur and shader-based effects in Flutter — such as performance trade-offs, layout edge cases, and rendering inconsistencies across environments.

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
        >
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
        >
        <br />
        <a href="https://inspirestack.app/inspire-blur/showcase/child-blur" target="_blank" rel="noopener">
          🔗 Watch hi-res video
        </a>
      </td>
    </tr>
  </table>
</div>

Run the example app to see interactive demos, including both backdrop and child blur in real-world scenarios.

## Features

- Gradient-based smoothly fading blur
- Scene-level and component-level blur modes
- GPU-accelerated custom shader implementation
- Optimized for Impeller — with automatic fallback
- Presets for common variable blur shapes
- Flexible configuration for advanced use cases
- Handling for complex UI layering setups (Stacks, Gradients, Shadows, Overlays, etc.)

## Why another blur package?

Flutter currently does not provide a built-in progressive blur widget.
Inspire Blur provides:

- Progressive variable blur
- Directional, radial and rectangular distributions
- Child and backdrop blur modes
- GPU shaders optimized for Impeller
- Automatic fallback for wider compatibility

## Blur Modes

Inspire Blur supports two ways of applying blur:

- **Backdrop blur** — blurs the content that’s _behind_ it.
- **Child blur** — blurs the content that’s _inside_ it.

---

**Backdrop blur** works best when applied over large, dynamic areas, such as screens, scaffolds, lists, grids, or carousels. It blurs any content rendered beneath it, making it ideal for scene-level effects.

A common use case is a top screen fade, where the blur effect starts under the status bar, and gradually fades out.

---

**Child blur** is ideal for standalone UI elements like cards, images, or small components. It works by wrapping the widget that should be blurred.

One common use case is a card with a background image and text on top. Inspire Blur can render a blur effect with a gradually fading intensity, allowing the text to stand out more against the background.

### Choosing a Blur Mode

Both blur modes can produce similar visual effects, but they are designed for different scenarios. Choosing the appropriate mode helps ensure the best stability and performance.

| Blur mode     | Typical use case                                                    |
| ------------- | ------------------------------------------------------------------- |
| Child blur    | Individual components such as cards, images, or standalone widgets. |
| Backdrop blur | Full-screen overlays and scene-level effects.                       |

## Usage

To get started, import the package:

```dart
import 'package:inspire_blur/inspire_blur.dart';
```

### Applying Child Blur

Wrap the widget that should be blurred with `Inspire.childBlur()`.

```dart
Inspire.childBlur(
  config: InspireBlurConfig(...), // Blur configuration
  child: MyWidget(), // Widget to be blurred
)
```

### Applying Backdrop Blur

Add `Inspire.backdropBlur()` to the same `Stack` as the content that should be blurred.

The blur widget must be added after the other widgets in the stack so it renders above them.

```dart
Stack(
  children: [
    MyWidget(), // Widgets to be blurred
    Inspire.backdropBlur(
      config: InspireBlurConfig(...), // Blur configuration
    ),
  ],
);
```

### Preloading Shaders (Optional)

It is recommended to call `Inspire.warmUp()` during app startup to ensure blur effects render immediately when first displayed.

## Presets

Inspire Blur config includes ready-to-use presets for the most typical use cases.

<p align="center">
  <img src="https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/readme/blur-patterns-0.2.0.webp" width="800">
</p>

### Directional Blur

This type of blur progressively fades along a direction, gradually changing its strength from one side to the other.

Use one of the predefined factories:

```dart
InspireBlurConfig.topToBottom()
InspireBlurConfig.bottomToTop()
InspireBlurConfig.leftToRight()
InspireBlurConfig.rightToLeft()
```

For a custom direction, use:

```dart
InspireBlurConfig.directional()
```

### Shape-based Blur

This type of blur has a non-uniform/variable distribution, where blur strength is determined by a shape.

The `inverse` parameter inverts the blur distribution. The blur normally starts from the center and fades outward. If `inverse` is `true`, the blur will start from the outside and fade outside-in.

Choose a custom `fadeCurve` to control how the blur intensity is gradually smoothened out. The default curve is `Curves.easeOutSine` which produces a smoother, more gradual fade that is distributed across the gradient in a more natural way visually.

#### Ellipse blur

For an elliptical blur, use:

```dart
InspireBlurConfig.ellipse()
```

#### Rectangle blur

For a rectangular blur, use:

```dart
InspireBlurConfig.rectangle()
```

#### Rounded rectangle blur

For a rounded rectangular blur, use:

```dart
InspireBlurConfig.roundedRectangle()
```

### Uniform Blur

To apply a uniform blur across the entire area, use:

```dart
InspireBlurConfig.solid()
```

### Color Tint

To apply a color tint to the blurred area of a widget, use one of the factory methods from `Inspire.tint`. Tinting adds a distinct accent color helping to soften the blur transition. This results in a more natural, integrated appearance.

The tint transition can be adjusted using the `curve` parameter. Curves such as `Curves.easeOutCubic` will typically produce a more natural effect than the regular `Curves.linear`. Various curves might also make the tint look more or less prominent.

The `extent` parameter defines how far the tint effect extends.

| Blur mode     | How to apply tint                                                        |
| ------------- | ------------------------------------------------------------------------ |
| Child blur    | Wrap the `Inspire.childBlur` _inside_ the tint widget.                   |
| Backdrop blur | Place the tint widget _after_ the `Inspire.backdropBlur` in the `Stack`. |

#### Tint Example

See below for an example of tint applied to a child blur with specific configuration values. The color was chosen arbitrarily, but it's recommended to use a color palette generator to pick an accent color programmatically.

<p align="center">
  <img src="https://raw.githubusercontent.com/inspirestack/inspire_blur/main/assets/readme/tint-comparison.webp" alt="Comparison of progressive blur with and without color tint" width="480">
</p>

```dart
Inspire.tint.bottomToTop(
  color: const Color(0xFF80CFF1),
  opacity: 0.75,
  extent: 0.5,
  curve: Curves.easeOutCubic,
  child: Inspire.childBlur(
    child: // ... card image
  ),
),
```

## Blur Configuration

### Sigma

Blur strength is defined by sigma values:

- `sigma` — uniform blur (both directions)
- `sigmaX` — horizontal blur
- `sigmaY` — vertical blur

`sigma` is mutually exclusive with `sigmaX` and `sigmaY`.

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

### Extent

Progressive blur does not have to span the entire area. To shorten the spread of the blur effect, use the `extent` property. It specifies the point at which the blur effect stops.

Values greater than `1.0` are also supported, allowing the blur transition to extend beyond the widget bounds.

For example:

- 0.0 → no blur is visible
- 0.5 → blur stops halfway
- 1.0 → blur spans the entire area

### Fade Curve

The blur strength is distributed according to the selected fade curve, allowing you to fine-tune how quickly the blur intensity progresses across the area.

The default is `Curves.easeInSine`, which produces a natural, more gradual soft edge blur fade. For a regular linear gradient blur progression, use `Curves.linear`.

## How It Works

### Backdrop Blur

**`Inspire.backdropBlur()` is a widget that blurs everything displayed behind it.**

It is built on top of Flutter’s `BackdropFilter` widget. It applies the custom blur shader via `ImageFilter.shader`.

A typical way to use `Inspire.backdropBlur()` is to add it to a `Stack` on top of the content that needs to be blurred. Make sure it is the last widget in the stack so it renders above the content.

### Child Blur

**`Inspire.childBlur()` is a widget that blurs everything inside it.**

It has two modes available:

- `InspireBlurMode.imageFilter`
- `InspireBlurMode.animatedSampler`

Each one uses a different underlying mechanism to render the blur effect.

These two modes have different trade-offs in terms of rendering accuracy, performance, and compatibility.

To let Inspire Blur choose the best mode automatically, use the default `InspireBlurMode.auto` which will determine the most suitable mode at runtime.

- The `imageFilter` mode is recommended for static and complex layouts. It is more tightly integrated with the rendering pipeline, making it more stable for complex layouts with stacks, shadows, and layered effects.
- The `animatedSampler` mode is recommended for scrollable content and simpler layouts. It provides better accuracy for elements of lists, grids, carousels, etc. It may however produce less accurate results for complex widgets, especially those using stacks and shadows.

_Note that `imageFilter` is only supported on Impeller. If it’s chosen and Impeller is not available, `animatedSampler` will be used instead._

## Performance

Designed with performance in mind, Inspire Blur minimizes GPU cost while maintaining high visual quality.

Inspire Blur relies on custom GPU shaders to achieve efficient blur rendering while allowing a high degree of customization. Each shader uses a lightweight one-dimensional convolution kernel, making the implementation GPU-friendly.

For uniform blur, horizontal and vertical passes are combined to approximate a 2D blur effect. Stacking two 1D blur passes is typically more efficient than a single 2D blur pass, especially for large sigma values. It produces visual quality that is visually comparable to a full 2D convolution for most UI use cases.

### Performance Precautions

Both Backdrop blur and Child blur can be used together within the same screen. When backdrop blur is on top of a widget that has a child blur applied, both should blend smoothly without any issues.

However, this comes with an associated performance cost. Using a large number of blur effects in a single scene may impact performance due to the need to allocate additional resources, such as framebuffers or save layers. This is particularly relevant in complex layouts or scrollable content where multiple layers are recomposited frequently.

If you encounter performance issues, consider reducing the blur sigma or limiting the area where the effect is applied. Additionally, limit the number of distinct blur effects displayed at once.

## Compatibility

iOS and Android platforms are fully supported.

On Web, only child blur with `InspireBlurMode.animatedSampler` is supported.

## Troubleshooting

> **My blur effect is too slow or starts lagging**
>
> Limit the number of distinct blur effects used on a single screen. Each additional blur increases GPU workload and rendering cost. Combining backdrop blur and child blur on the same screen may also introduce additional overhead. If you still experience bad performance, consider lowering the sigma value.

> **There is jank when blur is first rendered**
>
> Make sure to call `Inspire.warmUp()` before rendering blur effects. A recommended place is during app startup, such as on a splash screen.

> **I’m getting visual artifacts, such as overblown shadows**
>
> Try using child blur with `InspireBlurMode.imageFilter`. This mode provides more accurate rendering in certain scenarios, but is currently only available on the Impeller engine.

> **Child blur appears inaccurate while scrolling**
>
> Try using `InspireBlurMode.animatedSampler`, which works better in scrollable widgets and dynamically changing layouts.

> **I’m using platform views**
>
> Blur effects currently do not support platform views such as:
>
> - WebView
> - Google Maps
> - Native UIKit/AppKit views
>
> This limitation originates from Flutter’s platform view rendering architecture.

## Best Practices

### Optimize First Launch

It is recommended to call `Inspire.warmUp()` on app startup, for example during a splash screen. This function preloads the shaders used by the effects.

While not required, this is a useful optimization that ensures the blur effect renders immediately when first used, avoiding potential frame drops — especially on lower-end devices.

### Reduce Sigma on Lower-end Devices

Consider choosing lower sigma values for better performance. On lower-end devices, sigma values above `8-13` may become expensive depending on the layout complexity and number of active blur effects.

### Scale Sigma With Screen Resolution

Blur strength is perceived differently depending on the screen resolution. On smaller screens, lower sigma values may produce a visually similar result to higher sigma values on larger screens. For extra consistency it is advised to scale sigma depending on the screen resolution.

## Why Inspire Blur?

- **Built for Impeller first.** Optimized for Flutter’s modern rendering engine.
- **Graceful best-effort fallback.** To extensively cover a wide range of devices, it automatically falls back to Skia if Impeller is unavailable.
- **Actively maintained.** We’re working on constantly improving the performance and extending the available features, ensuring compatibility with latest Flutter, and no deprecation warnings.

## Support the Project

If `inspire_blur` helped you build a beautiful, high-quality UI, consider giving the package a 👍 on [pub.dev](https://pub.dev/packages/inspire_blur) and a ⭐️ on [GitHub](https://github.com/inspirestack/inspire_blur). It helps other developers discover the project.

If you'd like to support the project's continued development, you can also buy InspireStack a virtual cup of coffee.

☕️ [**Support InspireStack on Buy Me a Coffee**](https://buymeacoffee.com/inspirestack)

### Share What You’ve Built!

Did Inspire Blur turn out to be a great fit for your app? Share it with us! We’d love to feature your app. Find out how on [GitHub discussions](https://github.com/inspirestack/inspire_blur/discussions/categories/show-and-tell).

_Help inspire the Flutter community by showcasing what custom GPU shaders can do!_
