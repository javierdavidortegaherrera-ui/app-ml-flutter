import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceCropService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  /// Detecta y recorta el rostro desde la ruta de una imagen
  Future<img.Image?> detectAndCropFace(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) return null;

      final Uint8List bytes = await File(imagePath).readAsBytes();
      final img.Image? original = img.decodeImage(bytes);
      if (original == null) return null;

      final faceBox = faces.first.boundingBox;

      final int x = faceBox.left.toInt().clamp(0, original.width - 1);
      final int y = faceBox.top.toInt().clamp(0, original.height - 1);
      final int w = faceBox.width.toInt().clamp(1, original.width - x);
      final int h = faceBox.height.toInt().clamp(1, original.height - y);

      return img.copyCrop(original, x: x, y: y, width: w, height: h);
    } catch (e) {
      print('Error al recortar el rostro: $e');
      return null;
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}

