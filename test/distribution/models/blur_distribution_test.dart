import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/src/distribution/blur_distribution.dart';

void main() {
  DirectionalDistribution mockValidConfig() => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      );

  test('constructor throws when start equals end', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.center,
        end: Alignment.center,
        stops: [0, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when start equals end', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.center,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(begin: Alignment.center),
      throwsAssertionError,
    );
  });

  test('constructor throws when stops and values length differ', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 0.5, 1],
      ),
      throwsAssertionError,
    );
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.5, 1],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when stops and values length differ', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [0, 0.5, 1]),
      throwsAssertionError,
    );
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [0, 0.5, 1]),
      throwsAssertionError,
    );
  });

  test('constructor throws when not at least 2 blur stops provided', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0],
        values: [0, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when not at least 2 blur stops provided', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: []),
      throwsAssertionError,
    );
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [0]),
      throwsAssertionError,
    );
  });

  test('constructor throws when not at least 2 blur values provided', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [],
      ),
      throwsAssertionError,
    );
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when not at least 2 blur values provided', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: []),
      throwsAssertionError,
    );
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [0]),
      throwsAssertionError,
    );
  });

  test('constructor throws when stops are not in increasing order', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1, 0.9],
        values: [0, 0.5, 1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when stops are not in increasing order', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.5, 1],
        values: [0, 0.5, 1],
      ).copyWith(stops: [0, 1, 0.9]),
      throwsAssertionError,
    );
  });

  test('constructor allows stops outside [0,1] normalized range', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [-0.1, 1],
        values: [0, 1],
      ),
      returnsNormally,
    );

    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1.1],
        values: [0, 1],
      ),
      returnsNormally,
    );
  });

  test('copyWith allows stops outside [0,1] normalized range', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [-0.1, 1]),
      returnsNormally,
    );

    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(stops: [0, 1.1]),
      returnsNormally,
    );
  });

  test('constructor does not throw when stops contain duplicates', () {
    expect(
      DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.5, 0.5, 1],
        values: [0, 0.25, 0.75, 1],
      ).stops,
      [0, 0.5, 0.5, 1],
    );
  });

  test('copyWith does not throw when stops contain duplicates', () {
    expect(
      DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.25, 0.75, 1],
        values: [0, 0.25, 0.75, 1],
      ).copyWith(stops: [0, 0.5, 0.5, 1]).stops,
      [0, 0.5, 0.5, 1],
    );
  });

  test('constructor throws when values are outside [0,1] range', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [-0.1, 1],
      ),
      throwsAssertionError,
    );

    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1.1],
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when values are outside [0,1] range', () {
    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ).copyWith(values: [-0.1, 1]),
      throwsAssertionError,
    );

    expect(
      () => DirectionalDistribution(
        begin: Alignment.topCenter,
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

  test('Different list instances but same values are equal', () {
    final a = mockValidConfig();
    final b = mockValidConfig().copyWith(
      stops: [...a.stops],
      values: [...a.values],
    );

    expect(a, equals(b));
  });

  test('All values are replaced by copyWith', () {
    final config = mockValidConfig().copyWith(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0, 0.2, 1],
      values: [0, 0.3, 1],
    );

    expect(config.begin, equals(Alignment.topLeft));
    expect(config.end, equals(Alignment.bottomRight));
    expect(config.stops, equals([0, 0.2, 1]));
    expect(config.values, equals([0, 0.3, 1]));
  });

  test('copyWith updates start', () {
    final config = mockValidConfig();

    final updated = config.copyWith(begin: Alignment.center);

    expect(updated.begin, Alignment.center);
    expect(updated.end, config.end);
  });

  test('copyWith updates end', () {
    final config = mockValidConfig();

    final updated = config.copyWith(end: Alignment.center);

    expect(updated.begin, config.begin);
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

  test('copyWith throws when start equals end', () {
    expect(
      () => mockValidConfig().copyWith(
        begin: const Alignment(0.25, 0.25),
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

  test('External mutation does not affect config', () {
    final stops = [0.0, 1.0];

    final config = DirectionalDistribution(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: stops,
      values: [1, 0],
    );

    stops.add(0.5);

    expect(config.stops, [0, 1]);
  });

  test('Configs with different values are not equal', () {
    /// Different [start] value
    expect(mockValidConfig().copyWith(begin: Alignment.topLeft),
        isNot(equals(mockValidConfig().copyWith(begin: Alignment.center))));

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
    /// Same [start] value
    expect(mockValidConfig().copyWith(begin: Alignment.center),
        equals(mockValidConfig().copyWith(begin: Alignment.center)));

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
    /// Same [start] value
    expect(mockValidConfig().copyWith(begin: Alignment.center).hashCode,
        equals(mockValidConfig().copyWith(begin: Alignment.center).hashCode));

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
}
