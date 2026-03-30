import 'package:flutter/material.dart';
import 'package:avance2/controller/trabajo_controller.dart';
import 'package:avance2/models/trabajo.dart';
import 'package:avance2/view/trabajos/crear_trabajo.dart';
import 'package:avance2/view/trabajos/editar_trabajo.dart';
import 'package:avance2/view/trabajos/borrar_trabajo.dart';
import 'package:avance2/view/trabajos/trabajo_perfil.dart';

class TabTrabajos extends StatefulWidget {
  const TabTrabajos({super.key});

  @override
  State<TabTrabajos> createState() => _TabTrabajosState();
}

class _TabTrabajosState extends State<TabTrabajos> {
  final TrabajoController _controller = TrabajoController();
  List<Trabajos> _trabajos = [];

  @override
  void initState() {
    super.initState();
    _cargarTrabajos();
  }

  Future<void> _cargarTrabajos() async {
    final trabajos = await _controller.obtenerTrabajos();
    if (!mounted) return;
    setState(() => _trabajos = trabajos);
  }

  Future<void> _crearTrabajo(Trabajos nuevo) async {
    await _controller.crearTrabajo(nuevo);
    _cargarTrabajos();
  }

  Future<void> _editarTrabajo(Trabajos actualizado) async {
    await _controller.actualizarTrabajo(actualizado);
    _cargarTrabajos();
  }

  Future<void> _borrarTrabajo(String id) async {
    final trabajo = _trabajos.firstWhere((t) => t.id == id);
    if (trabajo.id.isNotEmpty) {
      await _controller.eliminarTrabajo(trabajo);
      _cargarTrabajos();
    } else {
      debugPrint('ERROR: ID vacío al intentar eliminar');
    }
  }

  void _abrirCrearForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearTrabajoForm(onCreate: _crearTrabajo),
      ),
    );
    _cargarTrabajos();
  }

  Future<void> _actualizarCotizado(Trabajos trabajo, bool nuevoEstado) async {
    await _controller.actualizarCampo(trabajo.id, 'cotizado', nuevoEstado);
    _cargarTrabajos();
  }

  Widget _buildCard(Trabajos trabajo) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      child: ListTile(
        title: Text(trabajo.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Motor: ${trabajo.motor}'),
            Row(
              children: [
                Checkbox(
                  value: trabajo.cotizado,
                  onChanged: (valor) {
                    if (valor != null) {
                      _actualizarCotizado(trabajo, valor);
                    }
                  },
                ),
                const Text('Cotizado'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarTrabajoForm(
                    trabajo: trabajo,
                    onEdit: _editarTrabajo,
                  ),
                ),
              );
            } else if (value == 'borrar') {
              showDialog(
                context: context,
                builder: (_) => BorrarTrabajoDialog(
                  trabajo: trabajo,
                  onDelete: () => _borrarTrabajo(trabajo.id),
                ),
              );
            } else if (value == 'ver') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Perfil(modelo: trabajo)),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'ver', child: Text('Ver')),
            const PopupMenuItem(value: 'editar', child: Text('Editar')),
            const PopupMenuItem(value: 'borrar', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _trabajos.isEmpty
          ? const Center(child: Text('No hay trabajos'))
          : ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 80),
              children: _trabajos.map(_buildCard).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCrearForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
