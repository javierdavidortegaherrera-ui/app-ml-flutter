import 'package:flutter/material.dart';
import 'package:avance2/models/cliente.dart';
import 'package:avance2/controller/cliente_controller.dart';
import 'package:avance2/view/clientes/cliente_form.dart';

class TabClientes extends StatefulWidget {
  const TabClientes({super.key});

  @override
  State<TabClientes> createState() => _TabClientesState();
}

class _TabClientesState extends State<TabClientes> {
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  void _cargarClientes() async {
    final clientes = await ClienteController().obtenerClientes();
    setState(() => _clientes = clientes);
  }

  void _crearCliente(Cliente nuevo) async {
    await ClienteController().crearCliente(nuevo);
    _cargarClientes();
  }

  void _editarCliente(Cliente actualizado) async {
    await ClienteController().actualizarCliente(actualizado);
    _cargarClientes();
  }

  void _borrarCliente(Cliente cliente) async {
    await ClienteController().eliminarCliente(cliente.id);
    _cargarClientes();
  }

  void _abrirFormulario({Cliente? cliente}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClienteForm(
          clienteExistente: cliente,
          onGuardar: cliente == null ? _crearCliente : _editarCliente,
        ),
      ),
    );
  }

  Widget _buildCard(Cliente cliente) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: const Color(0xFF2C2C2E),
      child: ListTile(
        title: Text(
          cliente.nombre,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'RTN: ${cliente.rtn} | Tel: ${cliente.telefono}',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'editar') {
              _abrirFormulario(cliente: cliente);
            } else if (value == 'eliminar') {
              _confirmarEliminar(cliente);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'editar', child: Text('Editar')),
            const PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminar(Cliente cliente) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar cliente?'),
        content: Text('¿Estás seguro que deseas eliminar a ${cliente.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _borrarCliente(cliente);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clientes.isEmpty
          ? const Center(child: Text('No hay clientes registrados'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: _clientes.map(_buildCard).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
