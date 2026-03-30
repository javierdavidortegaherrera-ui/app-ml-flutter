import 'package:flutter/material.dart';
import 'package:avance2/models/trabajo.dart';
import 'package:uuid/uuid.dart';

class CrearTrabajoForm extends StatefulWidget {
  final void Function(Trabajos) onCreate;

  const CrearTrabajoForm({super.key, required this.onCreate});

  @override
  State<CrearTrabajoForm> createState() => _CrearTrabajoFormState();
}

class _CrearTrabajoFormState extends State<CrearTrabajoForm> {
  final _formKey = GlobalKey<FormState>();

  final _nombre = TextEditingController();
  final _rtn = TextEditingController();
  final _telefono = TextEditingController();
  final _motor = TextEditingController();

  final Map<String, TextEditingController> campos = {};
  final Map<String, bool> expandidos = {};

  final Map<String, List<String>> categorias = {
    'Culatas': [
      'cepillar',
      'rectiAsientos',
      'rectivalvulas',
      'rectiguias',
      'fabriasientos',
      'acoplarguias',
      'fabricunas',
      'cambprecamaras',
      'cambcapuchones',
      'asentararmarcali',
      'alineartunel',
      'pruebafuga',
    ],
    'Cigüeñal': [
      'rectificarBancadaYBielas',
      'hacerPuntoRetenedorDelantero',
      'hacerPuntoRetenedorTrasero',
      'cambiarBalinerasYEngranaje',
      'enderezadoYTorsion',
      'pulirCiguenal',
    ],
    'Block': [
      'rectificarCilindros',
      'encamisarCilindrosSTD',
      'alinearTunelBancada',
      'cambiarTunelEjesLevas',
    ],
    'Bielas': ['rectificarHousing', 'cambiarPistones', 'cambiarBujes'],
  };

  @override
  void initState() {
    super.initState();
    for (var campo in categorias.values.expand((e) => e)) {
      campos[campo] = TextEditingController();
    }
    for (var key in categorias.keys) {
      expandidos[key] = false;
    }
  }

  double _getDouble(String key) =>
      double.tryParse(campos[key]?.text.trim() ?? '') ?? 0.0;

  Widget _campo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final trabajo = Trabajos(
      id: const Uuid().v4(),
      nombre: _nombre.text.trim(),
      rtn: _rtn.text.trim(),
      numerotel: _telefono.text.trim(),
      motor: _motor.text.trim(),
      cotizado: false,
      fecha: DateTime.now(),
      cepillar: _getDouble('cepillar'),
      rectiAsientos: _getDouble('rectiAsientos'),
      rectivalvulas: _getDouble('rectivalvulas'),
      rectiguias: _getDouble('rectiguias'),
      fabriasientos: _getDouble('fabriasientos'),
      acoplarguias: _getDouble('acoplarguias'),
      fabricunas: _getDouble('fabricunas'),
      cambprecamaras: _getDouble('cambprecamaras'),
      cambcapuchones: _getDouble('cambcapuchones'),
      asentararmarcali: _getDouble('asentararmarcali'),
      alineartunel: _getDouble('alineartunel'),
      pruebafuga: _getDouble('pruebafuga'),
      rectificarBancadaYBielas: _getDouble('rectificarBancadaYBielas'),
      hacerPuntoRetenedorDelantero: _getDouble('hacerPuntoRetenedorDelantero'),
      hacerPuntoRetenedorTrasero: _getDouble('hacerPuntoRetenedorTrasero'),
      cambiarBalinerasYEngranaje: _getDouble('cambiarBalinerasYEngranaje'),
      enderezadoYTorsion: _getDouble('enderezadoYTorsion'),
      pulirCiguenal: _getDouble('pulirCiguenal'),
      rectificarCilindros: _getDouble('rectificarCilindros'),
      encamisarCilindrosSTD: _getDouble('encamisarCilindrosSTD'),
      alinearTunelBancada: _getDouble('alinearTunelBancada'),
      cambiarTunelEjesLevas: _getDouble('cambiarTunelEjesLevas'),
      rectificarHousing: _getDouble('rectificarHousing'),
      cambiarPistones: _getDouble('cambiarPistones'),
      cambiarBujes: _getDouble('cambiarBujes'),
    );

    widget.onCreate(trabajo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('Nuevo Trabajo'),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campo('Nombre', _nombre),
              _campo('RTN', _rtn),
              _campo('Teléfono', _telefono),
              _campo('Motor', _motor),
              const SizedBox(height: 10),
              for (var categoria in categorias.entries)
                ExpansionTile(
                  title: Text(
                    categoria.key,
                    style: const TextStyle(color: Colors.black),
                  ),
                  initiallyExpanded: expandidos[categoria.key] ?? false,
                  onExpansionChanged: (v) {
                    setState(() {
                      expandidos[categoria.key] = v;
                    });
                  },
                  children: categoria.value.map((campo) {
                    return _campo(campo, campos[campo]!);
                  }).toList(),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar Trabajo',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
