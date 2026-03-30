import 'package:flutter/material.dart';
import 'package:avance2/controller/trabajo_controller.dart';
import 'package:avance2/models/trabajo.dart';
import 'package:avance2/view/trabajos/trabajo_lista.dart';

class TrabajoListaScreen extends StatefulWidget {
  const TrabajoListaScreen({super.key});

  @override
  State<TrabajoListaScreen> createState() => _TrabajoListaScreenState();
}

class _TrabajoListaScreenState extends State<TrabajoListaScreen> {
  List<Trabajos> _trabajos = [];

  @override
  void initState() {
    super.initState();
    _cargarTrabajos();
  }

  void _cargarTrabajos() async {
    final trabajos = await TrabajoController().obtenerTrabajos();
    setState(() => _trabajos = trabajos);
  }

  void _editarTrabajo(Trabajos actualizado) async {
    await TrabajoController().actualizarTrabajo(actualizado);
    _cargarTrabajos();
  }

  void _eliminarTrabajo(Trabajos trabajo) async {
    await TrabajoController().eliminarTrabajo(trabajo);
    _cargarTrabajos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Trabajos')),
      body: _trabajos.isEmpty
          ? const Center(child: Text('No hay trabajos'))
          : TrabajoLista(
              trabajos: _trabajos,
              onEditar: _editarTrabajo,
              onEliminar: _eliminarTrabajo,
            ),
    );
  }
}
