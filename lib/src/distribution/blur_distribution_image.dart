import 'dart:ui' as ui;

class BlurDistributionImage {
  final ui.Image image;
  final bool _owned;

  BlurDistributionImage.owned(this.image) : _owned = true;

  BlurDistributionImage.borrowed(this.image) : _owned = false;

  void dispose() {
    if (_owned) image.dispose();
  }
}
