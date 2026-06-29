## 0.2.0

### Added

- **Blur shapes:** Added `ellipse()`, `rectangle()`, and `roundedRectangle()` blur distributions.
- **Color tint:** Added the `Inspire.tint` API with factories for applying a gradually fading accent color on top of blur effects.
- **More flexible configuration:** Relaxed constraints on several configuration parameters. For example, `extent` now supports values greater than `1.0`, making it more flexible for advanced use cases such as animations.

### Fixed

- **ImageFilter mode:** Fixed a `nullptr` crash that could occur when using child blur with `InspireBlurMode.imageFilter` in dynamically changing widget trees.
- **Child blur gestures:** Fixed a bug where taps and other gestures were not passed through to widgets wrapped with child blur.

### Changed

- **Breaking change:** Blur distribution parameters are now configured through the `distribution` field of `InspireBlurConfig`, using dedicated `BlurDistribution` subclasses for each type of blur distribution.
- **Package size:** Reduced the published package size from ~15 MB to ~1 MB.
- **Example app:** Merged the example app source files into one `main.dart` file that contains a self-contained and minimal copy-pasteable first use example.
- **Documentation:**
  - Expanded the `README.md` with the new blur shape factories, blur pattern screenshots, a color tint demo, and a "Support the Project" section.
  - Expanded the API documentation and improved the overall structure, formatting, and readability.
- **Unit test coverage:** Expanded test coverage for core utilities, including gradient mask generation.

## 0.1.0

- Initial release
- Centralized `Inspire` API for quick access
- Progressive blur widgets for child and backdrop mode
- GPU-optimized shader program based on a blur-strength gradient map
- Unit and widget tests for improved reliability
- Example app showcasing all available blur types
