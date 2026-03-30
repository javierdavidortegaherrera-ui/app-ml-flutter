import 'package:flutter/material.dart';
import 'package:avance2/models/parametro.dart';
import 'package:avance2/controller/parametros_controller.dart';
import 'package:avance2/view/parametros/parametros_form.dart';

class TabParametros extends StatefulWidget {
  const TabParametros({super.key});

  @override
  State<TabParametros> createState() => _TabParametrosState();
}

class _TabParametrosState extends State<TabParametros> {
  List<Parametro> _parametros = [];

  @override
  void initState() {
    super.initState();
    _cargarParametros();
  }

  void _cargarParametros() async {
    final lista = await ParametroController().obtenerParametros();
    setState(() => _parametros = lista);
  }

  void _crearParametro(Parametro nuevo) async {
    await ParametroController().crearParametro(nuevo);
    _cargarParametros();
  }

  void _editarParametro(Parametro actualizado) async {
    await ParametroController().actualizarParametro(actualizado);
    _cargarParametros();
  }

  void _eliminarParametro(String id) async {
    await ParametroController().eliminarParametro(id);
    _cargarParametros();
  }

  void _abrirFormulario({Parametro? parametro}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ParametroForm(
          parametro: parametro,
          onSubmit: parametro == null ? _crearParametro : _editarParametro,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _parametros.isEmpty
          ? const Center(child: Text('No hay parámetros'))
          : ListView.builder(
              itemCount: _parametros.length,
              itemBuilder: (context, index) {
                final p = _parametros[index];
                return Card(
                  child: ListTile(
                    title: Text(p.nombre),
                    subtitle: Text('Valor: ${p.valor}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'editar') {
                          _abrirFormulario(parametro: p);
                        } else if (value == 'eliminar') {
                          _eliminarParametro(p.id);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem(
                          value: 'eliminar',
                          child: Text('Eliminar'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
