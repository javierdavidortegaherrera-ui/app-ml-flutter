import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:avance2/models/trabajo.dart';
import 'package:avance2/controller/trabajo_controller.dart';
import 'package:avance2/view/trabajos/trabajo_perfil.dart';

class TabInformes extends StatelessWidget {
  const TabInformes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Trabajos>>(
        stream: TrabajoController().streamTrabajos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final trabajosCotizados = snapshot.data!
              .where((t) => t.cotizado == true)
              .toList();

          final Map<String, List<Trabajos>> trabajosPorMes = {};
          for (var t in trabajosCotizados) {
            final fecha = t.fecha ?? DateTime.now();
            final mes = DateFormat('MMMM yyyy', 'es_ES').format(fecha);
            trabajosPorMes.putIfAbsent(mes, () => []).add(t);
          }

          final mesesOrdenados = trabajosPorMes.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: mesesOrdenados.length,
            itemBuilder: (context, index) {
              final mes = mesesOrdenados[index];
              final trabajosDelMes = trabajosPorMes[mes]!;

              final totalMes = trabajosDelMes
                  .map((t) => t.totalapagar())
                  .fold(0.0, (a, b) => a + b);

              return ExpansionTile(
                backgroundColor: Colors.grey[100],
                collapsedBackgroundColor: Colors.grey[200],
                title: Text(
                  mes,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                subtitle: Text(
                  'Total: L ${totalMes.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green),
                ),
                children: trabajosDelMes.map((trabajo) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      trabajo.nombre,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Motor: ${trabajo.motor}\nRTN: ${trabajo.rtn}  Tel: ${trabajo.numerotel}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      'L ${trabajo.totalapagar().toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Perfil(modelo: trabajo),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
