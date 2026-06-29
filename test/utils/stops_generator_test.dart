import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/src/utils/inspire_stops_generator.dart';

import '../test_core.dart';

void main() {
  group('curveToValuesAndStops', () {
    group('allows stops outside the normalized range', () {
      final cases = [
        (
          description: 'returnsNormally when startStop < 0',
          startStop: -0.01,
          endStop: 1.0,
          stopsCount: 5,
        ),
        (
          description: 'returnsNormally when startStop > 1',
          startStop: 1.01,
          endStop: 1.2,
          stopsCount: 5,
        ),
        (
          description: 'returnsNormally when endStop < 0',
          startStop: -0.2,
          endStop: -0.01,
          stopsCount: 5,
        ),
        (
          description: 'returnsNormally when endStop > 1',
          startStop: 0.0,
          endStop: 1.01,
          stopsCount: 5,
        ),
      ];

      for (final c in cases) {
        test(c.description, () {
          expect(
            () => curveToValuesAndStops(
              startStop: c.startStop,
              endStop: c.endStop,
              curve: Curves.linear,
              stopsCount: c.stopsCount,
            ),
            returnsNormally,
          );
        });
      }
    });

    group('throws', () {
      final cases = [
        (
          description: 'throws when endStop < startStop (around 0.0)',
          startStop: 0.0,
          endStop: -0.01,
          stopsCount: 5,
        ),
        (
          description: 'throws when startStop > endStop',
          startStop: 0.501,
          endStop: 0.499,
          stopsCount: 5,
        ),
        (
          description: 'throws when stopsCount < 2 (is 1)',
          startStop: 0.0,
          endStop: 1.0,
          stopsCount: 1,
        ),
        (
          description: 'throws when stopsCount < 2 (is 0)',
          startStop: 0.0,
          endStop: 1.0,
          stopsCount: 0,
        ),
        (
          description: 'throws when stopsCount < 2 (is -1)',
          startStop: 0.0,
          endStop: 1.0,
          stopsCount: -1,
        ),
      ];

      for (final c in cases) {
        test(c.description, () {
          expect(
            () => curveToValuesAndStops(
              startStop: c.startStop,
              endStop: c.endStop,
              curve: Curves.linear,
              stopsCount: c.stopsCount,
            ),
            throwsAssertionError,
          );
        });
      }

      test('does not throw when startStop == endStop', () {
        final result = curveToValuesAndStops(
          startStop: 0.5,
          endStop: 0.5,
          curve: Curves.linear,
          stopsCount: 5,
        );

        expect(result.first, (1.0, 0.5));
        expect(result.last, (0.0, 0.5));
      });
    });

    group('returns', () {
      test('returns linear values for Curves.linear', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 5,
        );
        expect(result[0], (1.0, 0.0));
        expect(result[1], (0.75, 0.25));
        expect(result[2], (0.5, 0.5));
        expect(result[3], (0.25, 0.75));
        expect(result[4], (0.0, 1.0));
      });
      test('returns stopsCount items', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.length, 10);
      });
      test('returns stopsCount + 1 when startStop > 0', () {
        final result = curveToValuesAndStops(
          startStop: 0.1,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.length, 11);
      });
      test('returns stopsCount + 1 when endStop < 1', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 0.9,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.length, 11);
      });
      test('returns stopsCount + 2 when startStop > 0 && endStop < 1', () {
        final result = curveToValuesAndStops(
          startStop: 0.1,
          endStop: 0.9,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.length, 12);
      });
      test('returns stops in increasing order', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 30,
        );
        expectIncreasing(result.map((e) => e.$2).toList());
      });
      test('starts at 0 and ends at 1', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 3,
        );
        expect(result.first.$2, 0.0);
        expect(result.last.$2, 1.0);
      });
      test('handles custom startStop and endStop', () {
        final result = curveToValuesAndStops(
          startStop: 0.25,
          endStop: 0.75,
          curve: Curves.linear,
          stopsCount: 3,
        );
        expect(result[1], (1.0, 0.25));
        expect(result[3], (0.0, 0.75));
      });
      test('returns values clamped to [0, 1]', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.easeInOutBack,
          stopsCount: 30,
        );
        for (final r in result) {
          expect(r.$1, inInclusiveRange(0.0, 1.0));
        }
      });
      test('returns values in decreasing order for Curves.linear', () {
        final result = curveToValuesAndStops(
          startStop: 0,
          endStop: 1,
          curve: Curves.linear,
          stopsCount: 30,
        );

        expectDecreasing(
          result.map((e) => e.$1).toList(),
        );
      });
    });

    group('prepends', () {
      test('prepends fully opaque stop when startStop > 0', () {
        final result = curveToValuesAndStops(
          startStop: 0.1,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.first, (1.0, 0.0));
        expect(result.length, 11);
      });
      test('does not prepend when startStop == 0', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.length, 10);
      });
    });

    group('appends', () {
      test('appends fully transparent stop when endStop < 1', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 0.9,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.last, (0.0, 1.0));
        expect(result.length, 11);
      });
      test('does not append when endStop == 1', () {
        final result = curveToValuesAndStops(
          startStop: 0.0,
          endStop: 1.0,
          curve: Curves.linear,
          stopsCount: 10,
        );
        expect(result.length, 10);
      });
    });
  });
}
