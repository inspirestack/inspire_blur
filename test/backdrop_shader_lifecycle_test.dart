import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/inspire_blur.dart';

void main() {
  testWidgets(
    'ignores backdrop shader loading after the blur is unmounted',
    (tester) async {
      final recorder = ui.PictureRecorder();
      ui.Canvas(recorder)
          .drawColor(const ui.Color(0xffffffff), ui.BlendMode.src);
      final picture = recorder.endRecording();
      addTearDown(picture.dispose);
      final mask = picture.toImageSync(1, 1);
      addTearDown(mask.dispose);

      const child = SizedBox(width: 100, height: 100);
      final backdrop = Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Inspire.backdropBlur(
              config: InspireBlurConfig.customMask(maskImage: mask, sigma: 6),
              child: child,
            ),
          ),
        ),
      );
      await tester.pumpWidget(backdrop);

      // Build the blur passes once the bounds and mask are ready. Unlike pump,
      // drawFrame lets us remove them before shader-loading microtasks run.
      tester.binding.drawFrame();
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.runtimeType.toString() == '_InspireBackdropBlurPass',
        ),
        findsNWidgets(2),
      );
      expect(find.byType(BackdropFilter), findsNothing);

      tester.binding.attachRootWidget(
        tester.binding.wrapWithDefaultView(const SizedBox()),
      );
      tester.binding.drawFrame();
      expect(find.byType(InspireBackdropBlur), findsNothing);

      await tester.pump();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(backdrop);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNWidgets(2));
    },
    skip: !ui.ImageFilter.isShaderFilterSupported,
  );
}
