import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService {
  CameraController? _cameraController;
  bool _disposed = false;

  CameraController get cameraController => _cameraController!;

  /// Inicializa la cámara frontal con resolución HD (720p)
  /// ResolutionPreset.medium = 1280x720 (horizontal), pero útil también para rostro en vertical
  Future<bool> initializeCamera() async {
    try {
      if (_disposed) return false;
      final cameras = await availableCameras();
      if (_disposed) return false;
      if (cameras.isEmpty) {
        debugPrint('No se encontraron cámaras disponibles');
        return false;
      }

      final controller = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        ),
        ResolutionPreset.medium, // 720p: 1280x720 HD
        enableAudio: false,
      );

      await _cameraController?.dispose();
      if (_disposed) {
        await controller.dispose();
        return false;
      }
      _cameraController = controller;
      await controller.initialize();
      if (_disposed) return false;

      // Muestra la resolución actual en consola (solo en debug)
      final previewSize = controller.value.previewSize;
      debugPrint(
        'Resolución seleccionada: ${previewSize?.width}x${previewSize?.height}',
      );

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
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      debugPrint('La cámara aún no está inicializada');
      return null;
    }

    if (controller.value.isTakingPicture) {
      debugPrint('La cámara ya está tomando una foto');
      return null;
    }

    try {
      return await controller.takePicture();
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
    _disposed = true;
    _cameraController?.dispose();
    _cameraController = null;
  }
}
