import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:avance2/models/trabajo.dart';
import 'package:avance2/view/trabajos/editar_trabajo.dart';
import 'package:avance2/controller/trabajo_controller.dart';

class Perfil extends StatefulWidget {
  final Trabajos modelo;

  const Perfil({super.key, required this.modelo});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late Trabajos _modelo;

  @override
  void initState() {
    super.initState();
    _modelo = widget.modelo;
  }

  List<String> obtenerDatos() {
    final m = _modelo;

    String formatear(String label, double? valor) =>
        '$label: L${(valor ?? 0).toStringAsFixed(2)}';

    return [
      'Nombre: ${m.nombre}',
      'RTN: ${m.rtn}',
      'Tipo de motor: ${m.motor}',
      'Número de teléfono: ${m.numerotel}',
      'Fecha: ${m.fecha != null ? DateFormat('dd/MM/yyyy').format(m.fecha!) : 'Sin fecha'}',
      '¿Cotizado?: ${m.cotizado ? "Sí" : "No"}',
      formatear('Cepillar', m.cepillar),
      formatear('Rectificar Asientos', m.rectiAsientos),
      formatear('Rectificar Válvulas', m.rectivalvulas),
      formatear('Rectificar Guías', m.rectiguias),
      formatear('Fabricar Asientos', m.fabriasientos),
      formatear('Acoplar Guías', m.acoplarguias),
      formatear('Fabricar Uñas', m.fabricunas),
      formatear('Cambiar Precámaras', m.cambprecamaras),
      formatear('Cambiar Capuchones', m.cambcapuchones),
      formatear('Asentar y Armar Calibrado', m.asentararmarcali),
      formatear('Alinear Túnel', m.alineartunel),
      formatear('Prueba de Fuga', m.pruebafuga),
      formatear('Rectificar Cilindros', m.rectificarCilindros),
      formatear('Encamisar Cilindros', m.encamisarCilindrosSTD),
      formatear('Alinear T. Bancada', m.alinearTunelBancada),
      formatear('Cambiar T.Ejes Levas', m.cambiarTunelEjesLevas),
      formatear('Rectificar Bancada y Bielas', m.rectificarBancadaYBielas),
      formatear('Punto Retenedor Delantero', m.hacerPuntoRetenedorDelantero),
      formatear('Punto Retenedor Trasero', m.hacerPuntoRetenedorTrasero),
      formatear('Cambiar Balineras y Engranaje', m.cambiarBalinerasYEngranaje),
      formatear('Enderezado y Torsión', m.enderezadoYTorsion),
      formatear('Pulir Cigüeñal', m.pulirCiguenal),
      formatear('Cambiar Bujes', m.cambiarBujes),
      formatear('Rectificar Housing', m.rectificarHousing),
      formatear('Cambiar Pistones', m.cambiarPistones),
    ];
  }

  Future<void> enviarWhatsapp(String numero, String mensaje) async {
    final url = Uri.parse(
      'https://wa.me/$numero?text=${Uri.encodeComponent(mensaje)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = _modelo;
    final datos = obtenerDatos();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        title: Text(m.nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Cliente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            for (var i in datos.take(6))
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(i, style: const TextStyle(color: Colors.white)),
              ),
            const SizedBox(height: 30),
            const Text(
              'Servicios Realizados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.blueGrey),
            const SizedBox(height: 10),
            for (var d in datos.skip(6))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        d.split(':').first,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      d.split(':').last,
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total a Pagar (con ISV)',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    'L${(m.totalapagar()).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarTrabajoForm(
                    trabajo: _modelo,
                    onEdit: (nuevo) => Navigator.pop(context, nuevo),
                  ),
                ),
              );

              if (resultado != null && resultado is Trabajos) {
                await TrabajoController().actualizarTrabajo(resultado);
                setState(() {
                  _modelo = resultado;
                });
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Precios'),
            backgroundColor: const Color(0xFF0D47A1),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            onPressed: () async {
              final numero = _modelo.numerotel
                  .replaceAll(' ', '')
                  .replaceAll('-', '');
              final mensaje =
                  'Hola ${_modelo.nombre}, su trabajo está listo. Total a pagar: L${_modelo.totalapagar().toStringAsFixed(2)}.';
              await enviarWhatsapp(numero, mensaje);
            },
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            label: const Text('Notificar por WhatsApp'),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
