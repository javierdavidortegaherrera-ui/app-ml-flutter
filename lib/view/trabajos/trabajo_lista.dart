import 'package:flutter/material.dart';
import 'package:avance2/models/trabajo.dart';
import 'package:avance2/view/trabajos/trabajo_perfil.dart';
//import 'package:avance2/view/trabajos/editar_trabajo.dart';
import 'package:avance2/view/trabajos/borrar_trabajo.dart';
import 'package:avance2/controller/trabajo_controller.dart';

class TrabajoLista extends StatelessWidget {
  final List<Trabajos> trabajos;
  final void Function(Trabajos) onEditar;
  final void Function(Trabajos) onEliminar;

  const TrabajoLista({
    super.key,
    required this.trabajos,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trabajos.length,
      itemBuilder: (context, index) {
        final trabajo = trabajos[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: const Color(0xFF2C2C2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: const Icon(Icons.build, size: 32, color: Colors.white),
            title: Text(
              trabajo.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Motor: ${trabajo.motor}\nTel: ${trabajo.numerotel}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: trabajo.cotizado,
                  onChanged: (nuevoValor) async {
                    if (nuevoValor != null) {
                      await TrabajoController().actualizarCampo(
                        trabajo.id,
                        'cotizado',
                        nuevoValor,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            nuevoValor
                                ? 'Trabajo marcado como cotizado'
                                : 'Trabajo marcado como no cotizado',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                ),
                const Text(
                  'Cotizado',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Perfil(modelo: trabajo)),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (_) => BorrarTrabajoDialog(
                  trabajo: trabajo,
                  onDelete: () => onEliminar(trabajo),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
