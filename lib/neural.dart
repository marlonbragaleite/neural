import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:neural/data.dart';

class Neuron {
  double bias;
  List<double> inputWeights;

  double costBias = 0;
  late List<double> costWeight;

  List<double> inputValues;
  Neuron(this.bias, this.inputWeights, this.inputValues) {
    costWeight = List.generate(inputWeights.length, (index) => 0);
    initializeRandomWeights();
  }

  double get weightedOutput {
    double answer = bias;
    for (int i = 0; i < inputWeights.length; i++) {
      answer += inputWeights[i] * inputValues[i];
    }
    return answer;
  }

  void initializeRandomWeights() {
    for (int i = 0; i < inputWeights.length; i++) {
      inputWeights[i] = Random().nextDouble() * 2 - 1;
    }
  }
}

class Layer {
  int numInputs, numNodes;
  List<Neuron> nodes = [];

  Layer(this.numInputs, this.numNodes) {
    for (int i = 0; i < numNodes; i++) {
      nodes.add(
        Neuron(
          0,
          List.generate(numInputs, (index) => 0),
          List.generate(numInputs, (index) => 0),
        ),
      );
    }
  }

  void applyGradients(double learnRate) {
    for (int i = 0; i < numNodes; i++) {
      nodes[i].bias -= nodes[i].costBias * learnRate;
      for (int j = 0; j < nodes[i].inputWeights.length; j++) {
        // Check if should accumulate.
        // Does the costWeigh changes somewhere else?
        nodes[i].inputWeights[j] = nodes[i].costWeight[j] * learnRate;
      }
    }
  }

  void setWeights(List<List<double>> weights) {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i].inputWeights = weights[i];
    }
  }

  void setBiases(List<double> biases) {
    for (int i = 0; i < nodes.length; i++) {
      nodes[i].bias = biases[i];
    }
  }

  List<double> get weightedOutputs {
    List<double> answer = [];
    for (int i = 0; i < nodes.length; i++) {
      answer.add(activationFunction(nodes[i].weightedOutput));
    }
    return answer;
  }

  double activationFunction(double weightedOutput) =>
      1 / (1 + exp(-weightedOutput));

  double nodeCost(double outputActivation, double expectedOutput) {
    double error = outputActivation - expectedOutput;
    return error * error;
  }
}

class NeuralNetwork {
  List<Layer> layers = [];

  NeuralNetwork(List<int> layerSizes) {
    for (int i = 0; i < layerSizes.length - 1; i++) {
      layers.add(Layer(layerSizes[i], layerSizes[i + 1]));
    }
  }

  void applyAllGradients(double learnRate) {
    for (Layer layer in layers) {
      layer.applyGradients(learnRate);
    }
  }

  void learn(
      List<DataPoint> trainingData, double learnRate, Function feedback) {
    const double h = 0.001;
    for (int iteration = 0; iteration < 100; iteration++) {
      double originalCost = cost(trainingData);
      for (Layer layer in layers) {
        // Cost gradient for weights
        for (int nodeNum = 0; nodeNum < layer.numNodes; nodeNum++) {
          for (int inputW = 0;
              inputW < layer.nodes[nodeNum].inputWeights.length;
              inputW++) {
            layer.nodes[nodeNum].inputWeights[inputW] += h;
            double deltaCost = cost(trainingData) - originalCost;
            layer.nodes[nodeNum].inputWeights[inputW] -= h;
            layer.nodes[nodeNum].costWeight[inputW] = deltaCost / h;
          }
        }

        //Cost gradient for Biases
        for (int nodeNum = 0; nodeNum < layer.numNodes; nodeNum++) {
          layer.nodes[nodeNum].bias += h;
          double deltaCost = cost(trainingData) - originalCost;
          layer.nodes[nodeNum].bias -= h;
          layer.nodes[nodeNum].costBias = deltaCost / h;
        }
      }
      print('$iteration  -  ${cost(trainingData)}');
      print(layers[0].nodes[0].inputWeights);
      List<double> w1 = [
        ...layers[0].nodes[0].inputWeights,
        ...layers[0].nodes[1].inputWeights,
        ...layers[0].nodes[2].inputWeights
      ];
      List<double> w2 = [
        ...layers[1].nodes[0].inputWeights,
        ...layers[1].nodes[1].inputWeights
      ];
      List<double> b1 = [
        layers[0].nodes[0].bias,
        layers[0].nodes[1].bias,
        layers[0].nodes[2].bias
      ];
      List<double> b2 = [
        layers[1].nodes[0].bias,
        layers[1].nodes[1].bias,
      ];
      feedback(w1, b1, w2, b2);
      applyAllGradients(learnRate);
    }
  }

  List<double> calculateOutputs(List<double> inputs) {
    for (Layer layer in layers) {
      for (Neuron node in layer.nodes) {
        node.inputValues = inputs;
      }
      inputs = layer.weightedOutputs;
    }
    return inputs;
  }

  int outputNodeWinner(DataPoint input) {
    List<double> outputs = calculateOutputs(input.values);

    int largestIndex = 0;
    for (int i = 0; i < outputs.length; i++) {
      if (outputs[i] > outputs[largestIndex]) {
        largestIndex = i;
      }
    }
    return largestIndex;
  }

  double costIndividual(DataPoint input) {
    List<double> outputs = calculateOutputs(input.values);
    Layer outputLayer = layers.last;
    double cost = 0;

    for (int nodeOut = 0; nodeOut < outputs.length; nodeOut++) {
      cost += outputLayer.nodeCost(outputs[nodeOut], input.expected[nodeOut]);
    }
    return cost;
  }

  double cost(List<DataPoint> data) {
    double totalCost = 0;
    for (DataPoint dataPoint in data) {
      totalCost += costIndividual(dataPoint);
    }
    return totalCost / data.length;
  }

  int totalCorrect(List<DataPoint> data) {
    int total = 0;
    for (DataPoint dataPoint in data) {
      int winnerNode = outputNodeWinner(dataPoint);
      if (listEquals(dataPoint.expected, [1, 0]) && winnerNode == 0) {
        total++;
      } else if (listEquals(dataPoint.expected, [0, 1]) && winnerNode == 1) {
        total++;
      }
    }
    return total;
  }
}
