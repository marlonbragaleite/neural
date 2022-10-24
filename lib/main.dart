import 'package:flutter/material.dart';
import 'package:neural/neural.dart';
import 'package:neural/neuralview.dart';
import 'data.dart';
import 'sliders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neural Network',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  late Size windowSize;
  Data data = Data(const Size(1, 1), 100);
  List<double> weights1 = List.filled(6, 0);
  List<double> bias1 = List.filled(3, 0);
  List<double> weights2 = List.filled(6, 0);
  List<double> bias2 = List.filled(2, 0);

  NeuralNetwork neural = NeuralNetwork([2, 3, 2]);
  // NeuralNetwork neural = NeuralNetwork([2, 2]);

  void redraw() {
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    List<double> weights = [...weights1, ...weights2];
    List<double> bias = [...bias1, ...bias2];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neural Network'),
        actions: [
          IconButton(
            onPressed: () {
              neural.learn(data.data, 0.0001, (List<double> w1, List<double> b1,
                  List<double> w2, List<double> b2) {
                setState(() {
                  weights1 = w1;
                  weights2 = w2;
                  bias1 = b1;
                  bias2 = b2;
                });
              });
            },
            icon: const Icon(Icons.label_important_outline),
          ),
          IconButton(
            onPressed: () {
              print(weights1);
              print(bias1);
              print(weights2);
              print(bias2);
            },
            icon: const Icon(Icons.question_mark),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                weights1 = [-25, -8.6951, -10.118, 25, -0.6976, 20.5827];
                bias1 = [11.751, -13.211, 17.209];
                weights2 = [7.155, 9.479, -3.849, 2.812, 10.025, 0];
                bias2 = [0.304, 0.220];
              });
            },
            icon: const Icon(Icons.check),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                weights1 = [21.07, 13.15, 7.15, -13.10, -19.54, -11.89];
                bias1 = [11.81, -15.38, 12.09];
                weights2 = [10.09, -5.8, -13.35, 0, 0, 0];
                bias2 = [-1.51, -2.8];
              });
            },
            icon: const Icon(Icons.no_adult_content),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(160, 20, 10, 10),
            child: NeuralView(
              neural: neural,
              data: data,
              weights: weights,
              biases: bias,
            ),
          ),
          FittedBox(
            child: Column(
              children: [
                Sliders(
                    values: weights1,
                    min: -25,
                    max: 25,
                    redraw: redraw,
                    title: 'Weights'),
                Sliders(
                    values: bias1,
                    min: -25,
                    max: 25,
                    redraw: redraw,
                    title: 'Bias'),
                Sliders(
                    values: weights2,
                    min: -25,
                    max: 25,
                    redraw: redraw,
                    title: 'Weights'),
                Sliders(
                    values: bias2,
                    min: -25,
                    max: 25,
                    redraw: redraw,
                    title: 'Bias'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
