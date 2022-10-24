import 'package:flutter/foundation.dart';

import 'neural.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class MyPainter extends CustomPainter {
  static final paintBlue = Paint()
    ..strokeWidth = 5
    ..color = Colors.indigoAccent
    ..style = PaintingStyle.stroke;
  static final paintRed = Paint()
    ..strokeWidth = 5
    ..color = Colors.redAccent
    ..style = PaintingStyle.stroke;

  static final paintClassBlue = Paint()
    ..strokeWidth = 5
    ..color = const Color(0xFFC8C8FF)
    ..style = PaintingStyle.fill;

  static final paintClassRed = Paint()
    ..strokeWidth = 5
    ..color = const Color.fromARGB(255, 255, 200, 200)
    ..style = PaintingStyle.fill;

  List<double> weights;
  List<double> bias;
  Size size;
  Data data;
  NeuralNetwork neural;

  MyPainter(
    this.size,
    this.data,
    this.neural,
    this.weights,
    this.bias,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Set weights for neurons
    neural.layers[0].setWeights([
      [
        weights[0],
        weights[1],
      ],
      [
        weights[2],
        weights[3],
      ],
      [
        weights[4],
        weights[5],
      ]
    ]);
    neural.layers[1].setWeights([
      [
        weights[6],
        weights[7],
        weights[8],
      ],
      [
        weights[9],
        weights[10],
        weights[11],
      ],
    ]);
    neural.layers[0].setBiases([bias[0], bias[1], bias[2]]);
    neural.layers[1].setBiases([bias[3], bias[4]]);

    for (double x = 0; x < size.width; x = x + 10) {
      for (double y = 0; y < size.height; y = y + 10) {
        visualize(neural, canvas, x, y);
      }
    }

    // Plot data points
    for (int i = 0; i < data.data.length; i++) {
      canvas.drawCircle(
        Offset(data.data[i].values[0] * size.width,
            data.data[i].values[1] * size.height),
        2,
        listEquals(data.data[i].expected, [1, 0]) ? paintBlue : paintRed,
      );
    }

    //Plot cost
    TextSpan span = TextSpan(
        text:
            'Cost: ${neural.cost(data.data)}\n Total Correct: ${neural.totalCorrect(data.data)}',
        style: const TextStyle(color: Colors.purple, fontSize: 30));
    TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    tp.layout();
    tp.paint(canvas, const Offset(0, 0));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void visualize(NeuralNetwork neural, Canvas canvas, double x, double y) {
    DataPoint dataPoint = DataPoint([x / size.width, y / size.height], [0, 0]);
    if (neural.outputNodeWinner(dataPoint) == 0) {
      canvas.drawCircle(Offset(x, y), 10, paintClassBlue);
    } else {
      canvas.drawCircle(Offset(x, y), 10, paintClassRed);
    }
  }
}
