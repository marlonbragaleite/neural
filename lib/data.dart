import 'dart:math';
import 'package:flutter/material.dart';

class DataPoint {
  late final List<double> values;
  late final List<double> expected;
  DataPoint(this.values, this.expected);
}

class Data {
  late final List<DataPoint> data;
  final Size size;
  final int length;

  Data(this.size, this.length) {
    List<DataPoint> data = List.generate(
      length ~/ 2,
      (index) => DataPoint(generateDataNonLinear(true), [1, 0]),
    );
    data = data +
        List.generate(
          length ~/ 2,
          (index) => DataPoint(generateDataNonLinear(false), [0, 1]),
        );
    this.data = data;
  }

  List<double> generateDataLinear(bool value) {
    double x;
    double y;
    int i = 0;
    do {
      x = Random().nextDouble() * size.width;
      y = Random().nextDouble() * size.height;
      i++;
    } while ((value ? 0.3 * x + y > 0.4 : 0.3 * x + y < 0.41) && i < 200);
    return [x, y];
  }

  List<double> generateDataNonLinear(bool value) {
    double x;
    double y;
    int i = 0;
    do {
      x = Random().nextDouble() * size.width;
      y = Random().nextDouble() * size.height;
      i++;
    } while ((value
            ? 9 * x * x - 2 * x + 1.1 * y > 0.7
            : 9 * x * x - 2 * x + 1.1 * y < 0.71) &&
        i < 200);
    return [x, y];
  }
}
