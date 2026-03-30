import 'package:flutter/material.dart';
import 'package:avance2/models/cliente.dart';
import 'package:uuid/uuid.dart';

class ClienteForm extends StatefulWidget {
  final Cliente? clienteExistente;
  final void Function(Cliente) onGuardar;

  const ClienteForm({
    super.key,
    this.clienteExistente,
    required this.onGuardar,
  });

  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombre;
  late TextEditingController _rtn;
  late TextEditingController _telefono;
  late TextEditingController _tipoMotor;

  @override
  void initState() {
    super.initState();
    final cliente = widget.clienteExistente;
    _nombre = TextEditingController(text: cliente?.nombre ?? '');
    _rtn = TextEditingController(text: cliente?.rtn ?? '');
    _telefono = TextEditingController(text: cliente?.telefono ?? '');
    _tipoMotor = TextEditingController(text: cliente?.tipoMotor ?? '');
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final cliente = widget.clienteExistente;
      final nuevo = Cliente(
        id: cliente?.id ?? const Uuid().v4(),
        nombre: _nombre.text.trim(),
        rtn: _rtn.text.trim(),
        telefono: _telefono.text.trim(),
        tipoMotor: _tipoMotor.text.trim(),
      );
      widget.onGuardar(nuevo);
      Navigator.pop(context);
    }
  }

  Widget _campoTexto(
    String label,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
    bool obligatorio = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: tipo,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black87),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          final texto = value?.trim() ?? '';
          if (obligatorio && texto.isEmpty) {
            return 'Campo requerido';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.clienteExistente != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Cliente' : 'Nuevo Cliente'),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campoTexto('Nombre', _nombre),
              _campoTexto('RTN', _rtn),
              _campoTexto('Teléfono', _telefono, tipo: TextInputType.phone),
              _campoTexto('Tipo de motor', _tipoMotor),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cliente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
