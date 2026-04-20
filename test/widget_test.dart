import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/inspire_blur.dart';
import 'package:inspire_blur/src/inspire_shaders.dart';

void main() {
  InspireBlurConfig mockConfig() => InspireBlurConfig.topToBottom(sigma: 5);

  testWidgets('Inspire.childBlur builds with child widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(InspireChildBlur), findsOneWidget);
  });

  testWidgets('Inspire.backdropBlur builds with child widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.backdropBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(InspireBackdropBlur), findsOneWidget);
  });

  testWidgets('Rebuild of child blur does not crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(InspireChildBlur), findsOneWidget);
  });

  testWidgets('Rebuild of backdrop blur does not crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.backdropBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.backdropBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(InspireBackdropBlur), findsOneWidget);
  });

  testWidgets('Child blur works after async shader load', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    await tester.pump(); // allow shader Future to resolve
    await tester.pump(); // apply setState

    expect(find.byType(InspireChildBlur), findsOneWidget);
  });

  testWidgets('Backdrop blur works after async shader load', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.backdropBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    await tester.pump(); // allow shader Future to resolve
    await tester.pump(); // apply setState

    expect(find.byType(InspireBackdropBlur), findsOneWidget);
  });

  testWidgets('Config is propagated to child blur', (tester) async {
    final config = mockConfig();

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: config,
          child: Container(),
        ),
      ),
    );

    final widget = tester.widget<InspireChildBlur>(
      find.byType(InspireChildBlur),
    );

    expect(widget.config, equals(config));
  });

  testWidgets('Config is propagated to backdrop blur', (tester) async {
    final config = mockConfig();

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.backdropBlur(
          config: config,
          child: Container(),
        ),
      ),
    );

    final widget = tester.widget<InspireBackdropBlur>(
      find.byType(InspireBackdropBlur),
    );

    expect(widget.config, equals(config));
  });

  testWidgets('Child blur rebuilds with new config', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: InspireBlurConfig.topToBottom(sigma: 5),
          child: Container(),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: InspireBlurConfig.topToBottom(sigma: 10),
          child: Container(),
        ),
      ),
    );

    expect(find.byType(InspireChildBlur), findsOneWidget);

    final widget = tester.widget<InspireChildBlur>(
      find.byType(InspireChildBlur),
    );

    expect(widget.config, InspireBlurConfig.topToBottom(sigma: 10));
  });

  testWidgets('Child is preserved across rebuilds', (tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(key: key),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(key: key),
        ),
      ),
    );

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('Backdrop blur builds with background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            Container(color: Colors.lightBlueAccent),
            Inspire.backdropBlur(
              config: mockConfig(),
              child: Container(),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(InspireBackdropBlur), findsOneWidget);
  });

  test('Inspire.warmUp completes without throwing', () async {
    await expectLater(
      Inspire.warmUp(),
      completes,
    );
  });

  test('Inspire.warmUp can be called multiple times', () async {
    await Inspire.warmUp();
    await Inspire.warmUp();

    expect(true, isTrue); // just ensures test completes
  });

  testWidgets('Widget works after warmUp', (tester) async {
    await Inspire.warmUp();

    await tester.pumpWidget(
      MaterialApp(
        home: Inspire.childBlur(
          config: mockConfig(),
          child: Container(),
        ),
      ),
    );

    expect(find.byType(InspireChildBlur), findsOneWidget);
  });

  tearDown(() {
    InspireShaders.reset();
  });
}
