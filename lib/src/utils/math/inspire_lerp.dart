import 'dart:ui';

List<double> lerpDoubleList(
  List<double> a,
  List<double> b,
  double t,
) {
  assert(a.length == b.length);

  return List.generate(
    a.length,
    (i) => lerpDouble(a[i], b[i], t)!,
    growable: false,
  );
}
