import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class FaceRecognitionService {
  late Interpreter _interpreter;

  /// tamaño de entrada que requiere el modelo 
  static const int modelInputSize = 112;

  /// Carga el modelo MobileFaceNet desde el assets
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/tflite/mobilefacenet.tflite');
  }

  /// Realiza la predicción del embedding facial
  Future<List<double>> predict(img.Image faceImage) async {
    // Redimensiona la imagen al tamaño que requiere el modelo
    final resized = img.copyResize(faceImage, width: modelInputSize, height: modelInputSize);

    // Convierte imagen a Float32List
    final Float32List input = imageToFloat32(resized);

    // Prepara la salida (192 dimensiones)
    final List<List<double>> output = List.generate(1, (_) => List.filled(192, 0.0));

    // Ejecuta el modelo con reshape correcto
    _interpreter.run(input.reshape([1, modelInputSize, modelInputSize, 3]), output);

    return output[0];
  }

  /// Convierte imagen a Float32List [-1, 1] según MobileFaceNet
  Float32List imageToFloat32(img.Image image) {
    final Float32List convertedBytes = Float32List(modelInputSize * modelInputSize * 3);
    int pixelIndex = 0;

    for (int y = 0; y < modelInputSize; y++) {
      for (int x = 0; x < modelInputSize; x++) {
        final pixel = image.getPixel(x, y);
        convertedBytes[pixelIndex++] = (pixel.r - 127.5) / 127.5;
        convertedBytes[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        convertedBytes[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }

    return convertedBytes;
  }

  void dispose() {
    _interpreter.close();
  }
}
