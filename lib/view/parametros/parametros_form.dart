import 'package:flutter/material.dart';
import 'package:avance2/models/parametro.dart';
import 'package:uuid/uuid.dart';

class ParametroForm extends StatefulWidget {
  final Parametro? parametro;
  final void Function(Parametro) onSubmit;

  const ParametroForm({super.key, this.parametro, required this.onSubmit});

  @override
  State<ParametroForm> createState() => _ParametroFormState();
}

class _ParametroFormState extends State<ParametroForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombre;
  late TextEditingController _valor;

  @override
  void initState() {
    super.initState();
    final p = widget.parametro;
    _nombre = TextEditingController(text: p?.nombre ?? '');
    _valor = TextEditingController(text: p?.valor ?? '');
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final p = widget.parametro;
      final nuevo = Parametro(
        id: p?.id ?? const Uuid().v4(),
        nombre: _nombre.text.trim(),
        valor: _valor.text.trim(),
      );
      widget.onSubmit(nuevo);
      Navigator.pop(context);
    }
  }

  Widget _campoTexto(
    String label,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
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
          if (texto.isEmpty) return 'Campo requerido';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.parametro == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(esNuevo ? 'Nuevo Parámetro' : 'Editar Parámetro'),
        backgroundColor: const Color(0xFF074F8A),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campoTexto('Nombre', _nombre),
              _campoTexto('Valor', _valor),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF083685),
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
