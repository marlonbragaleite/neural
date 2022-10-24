import 'package:flutter/material.dart';
import 'package:neural/draw.dart';
import 'neural.dart';
import 'data.dart';

class NeuralView extends StatefulWidget {
  final NeuralNetwork neural;
  final Data data;
  final List<double> weights;
  final List<double> biases;

  const NeuralView({
    Key? key,
    required this.neural,
    required this.data,
    required this.weights,
    required this.biases,
  }) : super(key: key);

  @override
  State<NeuralView> createState() => _NeuralViewState();
}

class _NeuralViewState extends State<NeuralView> {
  @override
  Widget build(BuildContext context) {
    Size windowSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return CustomPaint(
      size: windowSize,
      painter: MyPainter(
        windowSize,
        widget.data,
        widget.neural,
        widget.weights,
        widget.biases,
      ),
    );
  }
}
