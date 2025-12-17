import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteHelper {
  static Interpreter? _interpreter;
  static List<String>? _labels;

  static Future loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData
          .split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      print(
        'Model loaded. Input shape: ${_interpreter!.getInputTensors()[0].shape}',
      );
      print('Output shape: ${_interpreter!.getOutputTensors()[0].shape}');
      print('Labels: ${_labels!.length}');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  static Future<List?> classifyImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;

      // Assume model input is 224x224, adjust as needed
      final resizedImage = img.copyResize(image, width: 224, height: 224);
      final input = imageToByteListFloat32(resizedImage, 224, 0.0, 255.0);
      final output = List<List<double>>.generate(
        1,
        (_) => List<double>.filled(_labels!.length, 0.0),
      );
      _interpreter!.run(input, output);

      final result = <Map<String, dynamic>>[];
      for (int i = 0; i < _labels!.length; i++) {
        result.add({'label': _labels![i], 'confidence': output[0][i]});
      }
      result.sort(
        (a, b) =>
            (b['confidence'] as double).compareTo(a['confidence'] as double),
      );
      return result.take(3).toList();
    } catch (e) {
      print('Error classifying image: $e');
      return null;
    }
  }

  static List<List<List<List<double>>>> imageToByteListFloat32(
    img.Image image,
    int inputSize,
    double mean,
    double std,
  ) {
    final input = List<List<List<List<double>>>>.generate(
      1,
      (_) => List<List<List<double>>>.generate(
        inputSize,
        (_) => List<List<double>>.generate(
          inputSize,
          (_) => List<double>.filled(3, 0.0),
        ),
      ),
    );
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        final pixel = image.getPixel(j, i);
        final red = pixel.r.toDouble();
        final green = pixel.g.toDouble();
        final blue = pixel.b.toDouble();
        input[0][i][j][0] = (red - mean) / std;
        input[0][i][j][1] = (green - mean) / std;
        input[0][i][j][2] = (blue - mean) / std;
      }
    }
    return input;
  }

  static close() {
    _interpreter?.close();
  }
}
