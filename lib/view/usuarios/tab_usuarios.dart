import 'package:flutter/material.dart';
import 'package:avance2/controller/usuario_controller.dart';
import 'package:avance2/models/usuario.dart';
import 'package:avance2/view/usuarios/usuario_form.dart';

class TabUsuarios extends StatefulWidget {
  const TabUsuarios({super.key});

  @override
  State<TabUsuarios> createState() => _TabUsuariosState();
}

class _TabUsuariosState extends State<TabUsuarios> {
  List<Usuario> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  void _cargarUsuarios() async {
    final usuarios = await UsuarioController().obtenerUsuarios();
    setState(() => _usuarios = usuarios);
  }

  void _crearUsuario(Usuario nuevo) async {
    await UsuarioController().crearUsuario(nuevo);
    _cargarUsuarios();
  }

  void _editarUsuario(Usuario actualizado) async {
    await UsuarioController().actualizarUsuario(actualizado);
    _cargarUsuarios();
  }

  void _eliminarUsuario(String id) async {
    await UsuarioController().eliminarUsuario(id);
    _cargarUsuarios();
  }

  void _abrirFormulario({Usuario? usuario}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: UsuarioForm(
          usuarioExistente: usuario, // CORREGIDO AQUÍ
          onSubmit: usuario == null ? _crearUsuario : _editarUsuario,
        ),
      ),
    );
  }

  Widget _buildCard(Usuario usuario) {
    return Card(
      child: ListTile(
        title: Text(usuario.nombre),
        subtitle: Text('Correo: ${usuario.correo}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              _abrirFormulario(usuario: usuario);
            } else if (value == 'eliminar') {
              _eliminarUsuario(usuario.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'editar', child: Text('Editar')),
            const PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _usuarios.isEmpty
          ? const Center(child: Text('No hay usuarios registrados'))
          : ListView.builder(
              itemCount: _usuarios.length,
              itemBuilder: (context, index) => _buildCard(_usuarios[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
