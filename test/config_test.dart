import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inspire_blur/src/distribution/blur_distribution.dart';
import 'package:inspire_blur/src/inspire_blur_config.dart';
import 'package:inspire_blur/src/transform/blur_transform.dart';

import 'test_core.dart';

void main() {
  InspireBlurConfig mockValidConfig() => InspireBlurConfig(
        sigma: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      );

  test('Constructor accepts valid configs', () {
    final configWithSigma = InspireBlurConfig(
      sigma: 1,
      distribution: DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      transform: BlurTransform.identity,
    );

    final configWithSigmaX = InspireBlurConfig(
      sigmaX: 2,
      distribution: DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      transform: BlurTransform.identity,
    );

    final configWithSigmaY = InspireBlurConfig(
      sigmaY: 3,
      distribution: DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      transform: BlurTransform.identity,
    );

    final configWithSigmaXY = InspireBlurConfig(
      sigmaX: 5,
      sigmaY: 8,
      distribution: DirectionalDistribution(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 1],
        values: [0, 1],
      ),
      transform: BlurTransform.identity,
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
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
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
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when all sigma values provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
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
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when both sigma and sigmaX provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ).copyWith(sigmaX: 5),
      throwsAssertionError,
    );
  });

  test('Constructor throws when both sigma and sigmaY provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        sigmaY: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ),
      throwsAssertionError,
    );
  });

  test('copyWith throws when both sigma and sigmaY provided at once', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
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

  test('Horizontal and vertical sigma is derived correctly from one', () {
    final config = InspireBlurConfig.topToBottom(sigma: 5);

    expect(config.effectiveSigmaX, 5);
    expect(config.effectiveSigmaY, 5);
  });

  test('Horizontal and vertical sigma is derived correctly from separate', () {
    final config = InspireBlurConfig.topToBottom(sigmaX: 5, sigmaY: 13);

    expect(config.effectiveSigmaX, 5);
    expect(config.effectiveSigmaY, 13);
  });

  test('One-directional horizontal sigma is applied correctly', () {
    final config = InspireBlurConfig.topToBottom(sigmaX: 8);

    expect(config.effectiveSigmaX, 8);
    expect(config.effectiveSigmaY, null);
  });

  test('One-directional vertical sigma is applied correctly', () {
    final config = InspireBlurConfig.topToBottom(sigmaY: 8);

    expect(config.effectiveSigmaX, null);
    expect(config.effectiveSigmaY, 8);
  });

  test('Only sigma is replaced by copyWith', () {
    final originalConfig = mockValidConfig();
    final newConfig = originalConfig.copyWith(sigma: 34);

    expect(newConfig.sigma, equals(34));
    expect(newConfig.sigmaX, equals(originalConfig.sigmaX));
    expect(newConfig.sigmaY, equals(originalConfig.sigmaY));
    expect(newConfig.distribution, equals(originalConfig.distribution));
  });

  test('No values are replaced by copyWith when nulls are passed', () {
    final config = InspireBlurConfig(
      sigma: 21,
      distribution: DirectionalDistribution(
        values: [0, 1],
        stops: [0, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      transform: BlurTransform.identity,
    );
    final copiedConfig = config.copyWith();

    expect(copiedConfig.sigma, equals(21));
    expect(copiedConfig.distribution, equals(config.distribution));
  });

  test('copyWith throws when too many or no sigma provided', () {
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ).copyWith(sigmaX: 5),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigma: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ).copyWith(sigmaY: 5),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigmaX: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ).copyWith(sigma: 5),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig(
        sigmaY: 5,
        distribution: DirectionalDistribution(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 1],
          values: [0, 1],
        ),
        transform: BlurTransform.identity,
      ).copyWith(sigma: 5),
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
  });

  test('Configs with different directions are not equal', () {
    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.bottomToTop(sigma: 5))));

    expect(InspireBlurConfig.leftToRight(sigma: 5),
        isNot(equals(InspireBlurConfig.rightToLeft(sigma: 5))));

    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.leftToRight(sigma: 5))));

    expect(InspireBlurConfig.topToBottom(sigma: 5),
        isNot(equals(InspireBlurConfig.solid(sigma: 5))));
  });

  test('topToBottom produces correct config', () {
    final config = InspireBlurConfig.topToBottom(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);

    final distribution = config.distribution as DirectionalDistribution;

    expect(distribution.begin, Alignment.topCenter);
    expect(distribution.end, Alignment.bottomCenter);
    expect(distribution.stops.first, 0.0);
    expect(distribution.stops.last, 1.0);
    expect(distribution.values.first, 1.0);
    expect(distribution.values.last, 0.0);
    expectIncreasing(distribution.stops);
    expectDecreasing(distribution.values);
  });

  test('bottomToTop produces correct config', () {
    final config = InspireBlurConfig.bottomToTop(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);

    final distribution = config.distribution as DirectionalDistribution;

    expect(distribution.begin, Alignment.bottomCenter);
    expect(distribution.end, Alignment.topCenter);
    expect(distribution.stops.first, 0.0);
    expect(distribution.stops.last, 1.0);
    expect(distribution.values.first, 1.0);
    expect(distribution.values.last, 0.0);
    expectIncreasing(distribution.stops);
    expectDecreasing(distribution.values);
  });

  test('leftToRight produces correct config', () {
    final config = InspireBlurConfig.leftToRight(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);

    final distribution = config.distribution as DirectionalDistribution;

    expect(distribution.begin, Alignment.centerLeft);
    expect(distribution.end, Alignment.centerRight);
    expect(distribution.stops.first, 0.0);
    expect(distribution.stops.last, 1.0);
    expect(distribution.values.first, 1.0);
    expect(distribution.values.last, 0.0);
    expectIncreasing(distribution.stops);
    expectDecreasing(distribution.values);
  });

  test('rightToLeft produces correct config', () {
    final config = InspireBlurConfig.rightToLeft(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);

    final distribution = config.distribution as DirectionalDistribution;

    expect(distribution.begin, Alignment.centerRight);
    expect(distribution.end, Alignment.centerLeft);
    expect(distribution.stops.first, 0.0);
    expect(distribution.stops.last, 1.0);
    expect(distribution.values.first, 1.0);
    expect(distribution.values.last, 0.0);
    expectIncreasing(distribution.stops);
    expectDecreasing(distribution.values);
  });

  test('directional produces correct config', () {
    final config = InspireBlurConfig.directional(
      sigma: 5,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);

    final distribution = config.distribution as DirectionalDistribution;

    expect(distribution.begin, Alignment.topLeft);
    expect(distribution.end, Alignment.bottomRight);
    expect(distribution.stops.first, 0.0);
    expect(distribution.stops.last, 1.0);
    expect(distribution.values.first, 1.0);
    expect(distribution.values.last, 0.0);
    expectIncreasing(distribution.stops);
    expectDecreasing(distribution.values);
  });

  test('uniform produces correct config', () {
    final config = InspireBlurConfig.solid(sigma: 5);

    expect(config.sigma, 5);
    expect(config.sigmaX, null);
    expect(config.sigmaY, null);

    expect(config.distribution, isA<UniformDistribution>());
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
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        extent: -0.1,
      ),
      throwsAssertionError,
    );
    expect(
      () => InspireBlurConfig.directional(
        begin: Alignment.topLeft,
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

    final distribution = config.distribution as DirectionalDistribution;

    expect(distribution.stops, [0.0, 0.0]);
    expect(distribution.values, [1.0, 0.0]);
    expect(distribution.values.length, 2);
  });
}
