import 'package:flutter/material.dart';

class InformesScreen extends StatelessWidget {
  const InformesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informes')),
      body: const Center(
        child: Text(
          'Aquí se mostrarán los informes por mes.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
