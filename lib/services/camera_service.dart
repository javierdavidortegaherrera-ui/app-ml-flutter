import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;

  CameraController get cameraController => _cameraController;

  /// Inicializa la cámara frontal con resolución HD (720p)
  /// ResolutionPreset.medium = 1280x720 (horizontal), pero útil también para rostro en vertical
  Future<bool> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint('No se encontraron cámaras disponibles');
        return false;
      }

      _cameraController = CameraController(
        _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first,
        ),
        ResolutionPreset.medium, // 720p: 1280x720 HD
        enableAudio: false,
      );

      await _cameraController.initialize();

      // Muestra la resolución actual en consola (solo en debug)
      final previewSize = _cameraController.value.previewSize;
      debugPrint('Resolución seleccionada: ${previewSize?.width}x${previewSize?.height}');

      return true;
    } on CameraException catch (e) {
      debugPrint('Error al inicializar la cámara: $e');
      return false;
    } catch (e) {
      debugPrint('Error desconocido al inicializar la cámara: $e');
      return false;
    }
  }

  /// Captura una imagen desde la cámara frontal
  Future<XFile?> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      debugPrint('La cámara aún no está inicializada');
      return null;
    }

    if (_cameraController.value.isTakingPicture) {
      debugPrint('La cámara ya está tomando una foto');
      return null;
    }

    try {
      return await _cameraController.takePicture();
    } on CameraException catch (e) {
      debugPrint('Error de cámara al tomar la foto: $e');
      return null;
    } on StateError catch (e) {
      debugPrint('Estado incorrecto al tomar la foto: $e');
      return null;
    } catch (e) {
      debugPrint('Error desconocido al tomar la foto: $e');
      return null;
    }
  }

  void disposeCamera() {
    _cameraController.dispose();
  }
}
