import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: const Center(
        child: Text(
          'Aquí se configurarán parámetros generales.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
