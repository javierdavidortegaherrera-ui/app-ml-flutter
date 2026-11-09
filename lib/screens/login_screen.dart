import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

// Servicios
import '../services/camera_service.dart';
import '../services/face_recognition_service.dart' as recog;
import '../services/face_crop_service.dart' as crop;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cameraService = CameraService();
  final recog.FaceRecognitionService _faceService =
      recog.FaceRecognitionService();
  final crop.FaceCropService _faceCropService = crop.FaceCropService();

  bool _isInitialized = false;
  bool _isProcessing = false;
  String? _initializationError;
  String? _loginResult;
  List<List<double>>? _validEmbeddings; // Referencias del rostro

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Inicializa cámara y modelo
  Future<void> _initialize() async {
    setState(() => _initializationError = null);
    try {
      final success = await _cameraService.initializeCamera();
      if (!success) {
        if (mounted) {
          setState(() => _initializationError = 'No se pudo iniciar la cámara');
        }
        return;
      }
      await _faceService.loadModel();
      await _loadReferenceEmbeddings();
      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _initializationError =
            'No se pudo preparar el reconocimiento facial',
      );
      debugPrint('Error al inicializar el reconocimiento facial: $error');
    }
  }

  /// Carga un embedding único desde la imagen de referencia
  Future<void> _loadReferenceEmbeddings() async {
    final byteData = await rootBundle.load('assets/tflite/face.jpg');
    final imageBytes = byteData.buffer.asUint8List();
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw StateError('No se pudo leer la imagen de referencia');
    }
    final embedding = await _faceService.predict(image);
    _validEmbeddings = [embedding];
  }

  /// Reconocimiento facial con recorte y comparación
  Future<void> _authenticateUser() async {
    if (_validEmbeddings == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _loginResult = null;
    });

    try {
      final XFile? file = await _cameraService.takePicture();
      if (!mounted || file == null) return;

      final croppedImage = await _faceCropService.detectAndCropFace(file.path);
      if (!mounted) return;
      if (croppedImage == null) {
        setState(() => _loginResult = 'Rostro no detectado. Intenta de nuevo.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se detectó ningún rostro.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final inputEmbedding = await _faceService.predict(croppedImage);
      if (!mounted) return;
      final match = _validEmbeddings!.any(
        (ref) => _compareEmbeddings(ref, inputEmbedding) < 0.45,
      );

      if (match) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logueado', true);
        if (!mounted) return;
        setState(() => _loginResult = 'Acceso concedido');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bienvenido. Rostro verificado con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/bienvenida');
      } else {
        setState(() => _loginResult = 'Acceso denegado. Rostro no autorizado.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acceso denegado. Intenta de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _loginResult = 'No se pudo procesar el rostro. Intenta de nuevo.',
      );
      debugPrint('Error al autenticar el rostro: $error');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// Distancia euclidiana entre embeddings
  double _compareEmbeddings(List<double> a, List<double> b) {
    double sum = 0.0;
    for (int i = 0; i < a.length; i++) {
      sum += (a[i] - b[i]) * (a[i] - b[i]);
    }
    return math.sqrt(sum);
  }

  @override
  void dispose() {
    _cameraService.disposeCamera();
    _faceService.dispose();
    _faceCropService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Login facial')),
        body: Center(
          child: _initializationError == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_initializationError!),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _initialize,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login facial')),
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
              onPressed: _isProcessing ? null : _authenticateUser,
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : const Text('Iniciar sesión con rostro'),
            ),
            const SizedBox(height: 20),
            if (_loginResult != null)
              Text(
                _loginResult!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
