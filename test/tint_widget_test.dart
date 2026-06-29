import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/src/inspire_blur.dart';
import 'package:inspire_blur/src/inspire_tint.dart';

void main() {
  const childKey = Key('child');
  const child = SizedBox(key: childKey);

  testWidgets('InspireTint builds a DecoratedBox', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.tint.topToBottom(
          color: Colors.black,
          extent: 0.5,
          opacity: 0.5,
          curve: Curves.linear,
          child: child,
        ),
      ),
    );

    expect(find.byType(InspireTint), findsOneWidget);
    expect(find.byType(DecoratedBox), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);
  });

  testWidgets('InspireTint returns child without decoration when extent <= 0',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.tint.topToBottom(
          color: Colors.black,
          extent: 0.0,
          opacity: 0.5,
          curve: Curves.linear,
          child: child,
        ),
      ),
    );

    expect(find.byType(InspireTint), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byType(DecoratedBox), findsNothing);
  });

  testWidgets('InspireTint returns child without decoration when opacity <= 0',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.tint.topToBottom(
          color: Colors.black,
          extent: 0.5,
          opacity: 0.0,
          curve: Curves.linear,
          child: child,
        ),
      ),
    );

    expect(find.byType(InspireTint), findsOneWidget);
    expect(find.byKey(childKey), findsOneWidget);
    expect(find.byType(DecoratedBox), findsNothing);
  });

  group('InspireTint factories', () {
    final color = Colors.lightBlueAccent;
    final curve = Curves.linear;
    final extent = 0.75;
    final opacity = 0.35;

    final cases = [
      (
        factoryName: 'directional',
        factoryFunction: () => Inspire.tint.directional(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              color: color,
              extent: extent,
              opacity: opacity,
              curve: curve,
              child: child,
            ),
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
      ),
      (
        factoryName: 'topToBottom',
        factoryFunction: () => Inspire.tint.topToBottom(
              color: color,
              extent: extent,
              opacity: opacity,
              curve: curve,
              child: child,
            ),
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      ),
      (
        factoryName: 'bottomToTop',
        factoryFunction: () => Inspire.tint.bottomToTop(
              color: color,
              extent: extent,
              opacity: opacity,
              curve: curve,
              child: child,
            ),
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter
      ),
      (
        factoryName: 'leftToRight',
        factoryFunction: () => Inspire.tint.leftToRight(
              color: color,
              extent: extent,
              opacity: opacity,
              curve: curve,
              child: child,
            ),
        begin: Alignment.centerLeft,
        end: Alignment.centerRight
      ),
      (
        factoryName: 'rightToLeft',
        factoryFunction: () => Inspire.tint.rightToLeft(
              color: color,
              extent: extent,
              opacity: opacity,
              curve: curve,
              child: child,
            ),
        begin: Alignment.centerRight,
        end: Alignment.centerLeft
      ),
    ];

    for (final c in cases) {
      testWidgets('${c.factoryName} factory forwards params correctly',
          (tester) async {
        await tester.pumpWidget(MaterialApp(home: c.factoryFunction()));

        final widget = tester.widget<InspireTint>(find.byType(InspireTint));
        expect(widget.begin, c.begin);
        expect(widget.end, c.end);
        expect(widget.color, color);
        expect(widget.curve, curve);
        expect(widget.extent, extent);
        expect(widget.opacity, opacity);

        expect(find.byKey(childKey), findsOneWidget);
      });
    }
  });
}
