import 'package:flutter/material.dart';
import 'package:avance2/models/trabajo.dart';

class BorrarTrabajoDialog extends StatelessWidget {
  final Trabajos trabajo;
  final void Function() onDelete;

  const BorrarTrabajoDialog({
    super.key,
    required this.trabajo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Eliminar trabajo?'),
      content: Text(
        '¿Seguro que quieres eliminar el trabajo de ${trabajo.nombre}?',
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context), //Cancelar
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 7, 79, 138),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            onDelete(); //borrar
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete, color: Colors.white),
          label: const Text(
            'Eliminar',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 7, 79, 138),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
