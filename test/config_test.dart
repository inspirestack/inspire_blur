import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/inspire_blur.dart';

void main() {
  InspireBlurConfig mockValidConfig() => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      );

  test('Constructor accepts valid configs', () {
    final configWithSigma = InspireBlurConfig(
      sigma: 1,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 1],
      values: [0, 1],
    );

    final configWithSigmaX = InspireBlurConfig(
      sigmaX: 2,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 1],
      values: [0, 1],
    );

    final configWithSigmaY = InspireBlurConfig(
      sigmaY: 3,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 1],
      values: [0, 1],
    );

    final configWithSigmaXY = InspireBlurConfig(
      sigmaX: 5,
      sigmaY: 8,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 1],
      values: [0, 1],
    );

    expect(configWithSigma.sigma, equals(1));
    expect(configWithSigmaX.sigmaX, equals(2));
    expect(configWithSigmaY.sigmaY, equals(3));
    expect(configWithSigmaXY.sigmaX, equals(5));
    expect(configWithSigmaXY.sigmaY, equals(8));
  });

  test('Allows sigmaX without sigmaY', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigmaX: 5),
      returnsNormally,
    );
  });

  test('Allows sigmaY without sigmaX', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigmaY: 5),
      returnsNormally,
    );
  });

  test('Constructor throws when no sigma provided', () {
    expect(
      () => InspireBlurConfig(
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('Constructor throws when all sigma values provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        sigmaX: 5,
        sigmaY: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when all sigma values provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(
        sigmaX: 5,
        sigmaY: 5,
      ),
      throwsAssertionError,
    );
  });

  test('Constructor throws when both sigma and sigmaX provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        sigmaX: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when both sigma and sigmaX provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(sigmaX: 5),
      throwsAssertionError,
    );
  });

  test('Constructor throws when both sigma and sigmaY provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        sigmaY: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when both sigma and sigmaY provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(sigmaY: 5),
      throwsAssertionError,
    );
  });

  test('Constructor throws when sigma is negative', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigma: -1),
      throwsAssertionError,
    );
  });

  test('copyWith throws when sigma is negative', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigma: 5).copyWith(sigma: -5),
      throwsAssertionError,
    );
  });

  test('Constructor throws when sigmaX is negative', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigmaX: -1),
      throwsAssertionError,
    );
  });

  test('copyWith throws when sigmaX is negative', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigmaX: 5).copyWith(sigmaX: -5),
      throwsAssertionError,
    );
  });

  test('Constructor throws when sigmaY is negative', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigmaY: -1),
      throwsAssertionError,
    );
  });

  test('copyWith throws when sigmaY is negative', () {
    expect(
      () => InspireBlurConfig.topToBottom(sigmaY: 5).copyWith(sigmaY: -5),
      throwsAssertionError,
    );
  });

  test('Constructor throws when start equals end', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.center,
        end: Alignment.center,
        stops: [0, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when start equals end', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.center,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(start: Alignment.center),
      throwsAssertionError,
    );
  });

  test('Constructor throws when stops and values length differ', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 0.5, 1],
      ),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.5, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when stops and values length differ', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [0, 0.5, 1]),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [0, 0.5, 1]),
      throwsAssertionError,
    );
  });

  test('Constructor throws when not at least 2 blur stops provided', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when not at least 2 blur stops provided', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: []),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [0]),
      throwsAssertionError,
    );
  });

  test('Constructor throws when not at least 2 blur values provided', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [],
      ),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when not at least 2 blur values provided', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: []),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [0]),
      throwsAssertionError,
    );
  });

  test('Constructor throws when stops are not in increasing order', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1, 0.9],
        values: [0, 0.5, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when stops are not in increasing order', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.5, 1],
        values: [0, 0.5, 1],
      ).copyWith(stops: [0, 1, 0.9]),
      throwsAssertionError,
    );
  });

  test('Constructor throws when stops are outside [0,1] range', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [-0.1, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1.1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when stops are outside [0,1] range', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [-0.1, 1]),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [0, 1.1]),
      throwsAssertionError,
    );
  });

  test('Constructor throws when stops contain duplicates', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.5, 0.5, 1],
        values: [0, 0.25, 0.75, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when stops contain duplicates', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.25, 0.75, 1],
        values: [0, 0.25, 0.75, 1],
      ).copyWith(stops: [0, 0.5, 0.5, 1]),
      throwsAssertionError,
    );
  });

  test('Constructor throws when values are outside [0,1] range', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [-0.1, 1],
      ),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1.1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when values are outside [0,1] range', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [-0.1, 1]),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [0, 1.1]),
      throwsAssertionError,
    );
  });

  test('Lists are not shared by reference — copyWith', () {
    final config = mockValidConfig();
    final updated = config.copyWith();

    expect(identical(config.stops, updated.stops), false);
    expect(identical(config.values, updated.values), false);
  });

  test('Lists are not shared by reference — onlyHorizontal', () {
    final config = mockValidConfig();
    final updated = config.onlyHorizontal(5);

    expect(identical(config.stops, updated.stops), false);
    expect(identical(config.values, updated.values), false);
  });

  test('Lists are not shared by reference — onlyVertical', () {
    final config = mockValidConfig();
    final updated = config.onlyVertical(5);

    expect(identical(config.stops, updated.stops), false);
    expect(identical(config.values, updated.values), false);
  });

  test('Different list instances but same values are equal', () {
    final a = mockValidConfig();
    final b = mockValidConfig().copyWith(
      stops: [...a.stops],
      values: [...a.values],
    );

    expect(a, equals(b));
  });

  test('Horizontal and vertical sigma is derived correctly from one', () {
    final config = InspireBlurConfig.topToBottom(sigma: 5);

    expect(config.overallSigmaHorizontally(), 5);
    expect(config.overallSigmaVertically(), 5);
  });

  test('Horizontal and vertical sigma is derived correctly from separate', () {
    final config = InspireBlurConfig.topToBottom(sigmaX: 5, sigmaY: 13);

    expect(config.overallSigmaHorizontally(), 5);
    expect(config.overallSigmaVertically(), 13);
  });

  test('One-directional horizontal sigma is applied correctly', () {
    final config = InspireBlurConfig.topToBottom(sigmaX: 8);

    expect(config.overallSigmaHorizontally(), 8);
    expect(config.overallSigmaVertically(), null);
  });

  test('One-directional vertical sigma is applied correctly', () {
    final config = InspireBlurConfig.topToBottom(sigmaY: 8);

    expect(config.overallSigmaHorizontally(), null);
    expect(config.overallSigmaVertically(), 8);
  });

  test('All values are replaced by copyWith', () {
    final config = mockValidConfig().copyWith(
      sigma: 21,
      start: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0, 0.2, 1],
      values: [0, 0.3, 1],
    );

    expect(config.sigma, equals(21));
    expect(config.start, equals(Alignment.topLeft));
    expect(config.end, equals(Alignment.bottomRight));
    expect(config.stops, equals([0, 0.2, 1]));
    expect(config.values, equals([0, 0.3, 1]));
  });

  test('Only sigma is replaced by copyWith', () {
    final originalConfig = mockValidConfig();
    final newConfig = originalConfig.copyWith(sigma: 34);

    expect(newConfig.sigma, equals(34));
    expect(newConfig.sigmaX, equals(originalConfig.sigmaX));
    expect(newConfig.sigmaY, equals(originalConfig.sigmaY));
    expect(newConfig.start, equals(originalConfig.start));
    expect(newConfig.end, equals(originalConfig.end));
    expect(newConfig.stops, equals(originalConfig.stops));
    expect(newConfig.values, equals(originalConfig.values));
  });

  test('No values are replaced by copyWith when nulls are passed', () {
    final config = InspireBlurConfig(
      sigma: 21,
      start: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0, 0.2, 1],
      values: [0, 0.3, 1],
    );
    final copiedConfig = config.copyWith();

    expect(copiedConfig.sigma, equals(21));
    expect(copiedConfig.start, equals(Alignment.topLeft));
    expect(copiedConfig.end, equals(Alignment.bottomRight));
    expect(copiedConfig.stops, equals([0, 0.2, 1]));
    expect(copiedConfig.values, equals([0, 0.3, 1]));
  });

  test('copyWith updates start', () {
    final config = mockValidConfig();

    final updated = config.copyWith(start: Alignment.center);

    expect(updated.start, Alignment.center);
    expect(updated.end, config.end);
  });

  test('copyWith updates end', () {
    final config = mockValidConfig();

    final updated = config.copyWith(end: Alignment.center);

    expect(updated.start, config.start);
    expect(updated.end, Alignment.center);
  });

  test('copyWith updates stops', () {
    final config = mockValidConfig();

    final updated = config.copyWith(stops: [0.2, 0.8]);

    expect(updated.stops, [0.2, 0.8]);
    expect(updated.values, config.values);
  });

  test('copyWith updates values', () {
    final config = mockValidConfig();

    final updated = config.copyWith(values: [0.3, 0.6]);

    expect(updated.stops, config.stops);
    expect(updated.values, [0.3, 0.6]);
  });

  test('copyWith throws when too many or no sigma provided', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(sigmaX: 5),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(sigmaY: 5),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigmaX: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(sigma: 5),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigmaY: 5,
        start: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(sigma: 5),
      throwsAssertionError,
    );
  });

  test('copyWith throws when start equals end', () {
    expect(
      () => mockValidConfig().copyWith(
        start: const Alignment(0.25, 0.25),
        end: const Alignment(0.25, 0.25),
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when not at least 2 blur stops provided', () {
    expect(
      () => mockValidConfig().copyWith(stops: []),
      throwsAssertionError,
    );
    expect(
      () => mockValidConfig().copyWith(stops: [0]),
      throwsAssertionError,
    );
  });

  test('copyWith throws when not at least 2 blur values provided', () {
    expect(
      () => mockValidConfig().copyWith(values: []),
      throwsAssertionError,
    );
    expect(
      () => mockValidConfig().copyWith(values: [0]),
      throwsAssertionError,
    );
  });

  test('copyWith throws when mismatched stops and values provided', () {
    expect(
      () => mockValidConfig().copyWith(
        stops: [0, 1],
        values: [0, 0.5, 1],
      ),
      throwsAssertionError,
    );
    expect(
      () => mockValidConfig().copyWith(
        stops: [0, 0.5, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('onlyHorizontal overrides sigma correctly', () {
    final config = InspireBlurConfig.topToBottom(sigma: 5);

    final result = config.onlyHorizontal(10);

    expect(result.sigma, null);
    expect(result.sigmaX, 10);
    expect(result.sigmaY, null);
  });

  test('onlyVertical overrides sigma correctly', () {
    final config = InspireBlurConfig.topToBottom(sigma: 5);

    final result = config.onlyVertical(10);

    expect(result.sigma, null);
    expect(result.sigmaX, null);
    expect(result.sigmaY, 10);
  });

  test('Configs with different values are not equal', () {
    /// Different [sigma] value
    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.topToBottom(sigma: 10))));

    /// Different [sigma] and [sigmaX] values
    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.topToBottom(sigmaX: 5))));

    /// Different [sigma] and [sigmaY] values
    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.topToBottom(sigmaY: 5))));

    /// Different [start] value
    expect(mockValidConfig().copyWith(start: Alignment.topLeft),
        isNot(equals(mockValidConfig().copyWith(start: Alignment.center))));

    /// Different [end] value
    expect(mockValidConfig().copyWith(end: Alignment.topLeft),
        isNot(equals(mockValidConfig().copyWith(end: Alignment.center))));

    /// Different [stops] value
    expect(mockValidConfig().copyWith(stops: [0.222, 1.0]),
        isNot(equals(mockValidConfig().copyWith(stops: [0.333, 1.0]))));

    /// Different [values] value
    expect(mockValidConfig().copyWith(values: [0.222, 1.0]),
        isNot(equals(mockValidConfig().copyWith(values: [0.333, 1.0]))));
  });

  test('Configs with same values are equal', () {
    /// Same [sigma] value
    expect(InspireBlurConfig.topToBottom(sigma: 5),
        equals(InspireBlurConfig.topToBottom(sigma: 5)));

    /// Same [sigmaX] value
    expect(InspireBlurConfig.topToBottom(sigmaX: 5),
        equals(InspireBlurConfig.topToBottom(sigmaX: 5)));

    /// Same [sigmaY] value
    expect(InspireBlurConfig.topToBottom(sigmaY: 5),
        equals(InspireBlurConfig.topToBottom(sigmaY: 5)));

    /// Same [start] value
    expect(mockValidConfig().copyWith(start: Alignment.center),
        equals(mockValidConfig().copyWith(start: Alignment.center)));

    /// Same [end] value
    expect(mockValidConfig().copyWith(end: Alignment.center),
        equals(mockValidConfig().copyWith(end: Alignment.center)));

    /// Same [stops] value
    expect(mockValidConfig().copyWith(stops: [0.222, 1.0]),
        equals(mockValidConfig().copyWith(stops: [0.222, 1.0])));

    /// Same [values] value
    expect(mockValidConfig().copyWith(values: [0.222, 1.0]),
        equals(mockValidConfig().copyWith(values: [0.222, 1.0])));
  });

  test('Configs with same values have same hashCode', () {
    /// Same [sigma] value
    expect(InspireBlurConfig.topToBottom(sigma: 5).hashCode,
        equals(InspireBlurConfig.topToBottom(sigma: 5).hashCode));

    /// Same [sigmaX] value
    expect(InspireBlurConfig.topToBottom(sigmaX: 5).hashCode,
        equals(InspireBlurConfig.topToBottom(sigmaX: 5).hashCode));

    /// Same [sigmaY] value
    expect(InspireBlurConfig.topToBottom(sigmaY: 5).hashCode,
        equals(InspireBlurConfig.topToBottom(sigmaY: 5).hashCode));

    /// Same [start] value
    expect(mockValidConfig().copyWith(start: Alignment.center).hashCode,
        equals(mockValidConfig().copyWith(start: Alignment.center).hashCode));

    /// Same [end] value
    expect(mockValidConfig().copyWith(end: Alignment.center).hashCode,
        equals(mockValidConfig().copyWith(end: Alignment.center).hashCode));

    /// Same [stops] value
    expect(mockValidConfig().copyWith(stops: [0.222, 1.0]).hashCode,
        equals(mockValidConfig().copyWith(stops: [0.222, 1.0]).hashCode));

    /// Same [values] value
    expect(mockValidConfig().copyWith(values: [0.222, 1.0]).hashCode,
        equals(mockValidConfig().copyWith(values: [0.222, 1.0]).hashCode));
  });

  test('Configs with different directions are not equal', () {
    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.bottomToTop(sigma: 5))));

    expect(InspireBlurConfig.leftToRight(sigma: 5),
        isNot(equals(InspireBlurConfig.rightToLeft(sigma: 5))));

    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.leftToRight(sigma: 5))));

    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.uniform(sigma: 5))));
  });

  test('External mutation affects config (documented behavior)', () {
    final stops = [0.0, 1.0];

    final config = InspireBlurConfig(
      sigma: 5,
      start: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: stops,
      values: [1, 0],
    );

    stops.add(0.5);

    expect(config.stops.length, 3);
  });

  test('topToBottom produces correct config', () {
    final config = InspireBlurConfig.topToBottom(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);
    expect(config.start, Alignment.topCenter);
    expect(config.end, Alignment.bottomCenter);
    expect(config.stops.first, 0.0);
    expect(config.stops.last, 1.0);
    expect(config.values.first, 1.0);
    expect(config.values.last, 0.0);
    _expectIncreasing(config.stops);
    _expectDecreasing(config.values);
  });

  test('bottomToTop produces correct config', () {
    final config = InspireBlurConfig.bottomToTop(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);
    expect(config.start, Alignment.bottomCenter);
    expect(config.end, Alignment.topCenter);
    expect(config.stops.first, 0.0);
    expect(config.stops.last, 1.0);
    expect(config.values.first, 1.0);
    expect(config.values.last, 0.0);
    _expectIncreasing(config.stops);
    _expectDecreasing(config.values);
  });

  test('leftToRight produces correct config', () {
    final config = InspireBlurConfig.leftToRight(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);
    expect(config.start, Alignment.centerLeft);
    expect(config.end, Alignment.centerRight);
    expect(config.stops.first, 0.0);
    expect(config.stops.last, 1.0);
    expect(config.values.first, 1.0);
    expect(config.values.last, 0.0);
    _expectIncreasing(config.stops);
    _expectDecreasing(config.values);
  });

  test('rightToLeft produces correct config', () {
    final config = InspireBlurConfig.rightToLeft(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);
    expect(config.start, Alignment.centerRight);
    expect(config.end, Alignment.centerLeft);
    expect(config.stops.first, 0.0);
    expect(config.stops.last, 1.0);
    expect(config.values.first, 1.0);
    expect(config.values.last, 0.0);
    _expectIncreasing(config.stops);
    _expectDecreasing(config.values);
  });

  test('directional produces correct config', () {
    final config = InspireBlurConfig.directional(
      sigma: 5,
      start: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);
    expect(config.start, Alignment.topLeft);
    expect(config.end, Alignment.bottomRight);
    expect(config.stops.first, 0.0);
    expect(config.stops.last, 1.0);
    expect(config.values.first, 1.0);
    expect(config.values.last, 0.0);
    _expectIncreasing(config.stops);
    _expectDecreasing(config.values);
  });

  test('uniform produces correct config', () {
    final config = InspireBlurConfig.uniform(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);
    expect(config.start, Alignment.topCenter);
    expect(config.end, Alignment.bottomCenter);
    expect(config.stops.first, 0.0);
    expect(config.stops.last, 1.0);
    expect(config.values.first, 1.0);
    expect(config.values.last, 1.0);
    _expectIncreasing(config.stops);
    _expectUniform(config.values);
  });

  test('Throws when extent is outside [0,1] range', () {
    expect(
      () => InspireBlurConfig.topToBottom(extent: -0.1),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig.topToBottom(extent: 1.1),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig.bottomToTop(extent: -0.1),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig.bottomToTop(extent: 1.1),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig.leftToRight(extent: -0.1),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig.leftToRight(extent: 1.1),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig.rightToLeft(extent: -0.1),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig.rightToLeft(extent: 1.1),
      throwsAssertionError,
    );

    expect(
      () => InspireBlurConfig.directional(
        start: Alignment.topLeft,
        end: Alignment.bottomRight,
        extent: -0.1,
      ),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig.directional(
        start: Alignment.topLeft,
        end: Alignment.bottomRight,
        extent: 1.1,
      ),
      throwsAssertionError,
    );
  });

  test('extent == 0 produces valid minimal gradient', () {
    final config = InspireBlurConfig.topToBottom(
      sigma: 5,
      extent: 0.0,
    );

    expect(config.stops, [0.0, 1.0]);
    expect(config.values.length, 2);
  });
}

void _expectIncreasing(List<double> values) {
  for (int i = 1; i < values.length; i++) {
    expect(values[i], greaterThan(values[i - 1]));
  }
}

void _expectDecreasing(List<double> values) {
  for (int i = 1; i < values.length; i++) {
    expect(values[i], lessThan(values[i - 1]));
  }
}

void _expectUniform(List<double> values) {
  for (int i = 1; i < values.length; i++) {
    expect(values[i], equals(values[i - 1]));
  }
}
