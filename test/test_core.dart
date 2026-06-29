import 'package:flutter_test/flutter_test.dart';

void expectIncreasing(List<double> values) {
  for (int i = 1; i < values.length; i++) {
    expect(values[i], greaterThan(values[i - 1]));
  }
}

void expectDecreasing(List<double> values) {
  for (int i = 1; i < values.length; i++) {
    expect(values[i], lessThan(values[i - 1]));
  }
}

void expectUniform(List<double> values) {
  for (int i = 1; i < values.length; i++) {
    expect(values[i], equals(values[i - 1]));
  }
}
