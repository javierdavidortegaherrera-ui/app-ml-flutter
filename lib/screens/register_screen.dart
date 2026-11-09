import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../services/camera_service.dart';

class RegisterScreen extends StatefulWidget {
  final String id;
  final String nombre;
  const RegisterScreen({super.key, required this.id, required this.nombre});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _cameraService = CameraService();

  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() => _cameraError = null);
    final success = await _cameraService.initializeCamera();
    if (!mounted) return;
    if (!success) {
      setState(() => _cameraError = 'No se pudo iniciar la cámara');
      return;
    }
    setState(() => _isInitialized = true);
  }

  /// Captura la imagen
  Future<void> _captureOnly() async {
    setState(() => _isProcessing = true);

    final XFile? file = await _cameraService.takePicture();
    if (!mounted) return;
    if (file == null) {
      setState(() => _isProcessing = false);
      return;
    }

    setState(() {
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Rostro capturado')));

    // Aquí se hará la función de registrar rostro
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Registro facial')),
        body: Center(
          child: _cameraError == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_cameraError!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _initializeCamera,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Registro facial')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_cameraService.cameraController.value.isInitialized)
              Center(
                child: SizedBox(
                  width: 320,
                  height: 480,
                  child: CameraPreview(_cameraService.cameraController),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isProcessing ? null : _captureOnly,
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : const Text('Tomar Rostro'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraService.disposeCamera();
    super.dispose();
  }
}
