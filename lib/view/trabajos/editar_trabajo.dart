import 'package:flutter/material.dart';
import 'package:avance2/models/trabajo.dart';

class EditarTrabajoForm extends StatefulWidget {
  final Trabajos trabajo;
  final void Function(Trabajos) onEdit;

  const EditarTrabajoForm({
    super.key,
    required this.trabajo,
    required this.onEdit,
  });

  @override
  State<EditarTrabajoForm> createState() => _EditarTrabajoFormState();
}

class _EditarTrabajoFormState extends State<EditarTrabajoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombre;
  late TextEditingController _rtn;
  late TextEditingController _motor;
  late TextEditingController _telefono;

  late bool _cotizado;
  late DateTime _fecha;

  final Map<String, TextEditingController> _campos = {};
  final Map<String, bool> _expandidos = {};

  final Map<String, List<String>> _categorias = {
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
    final t = widget.trabajo;

    _nombre = TextEditingController(text: t.nombre);
    _rtn = TextEditingController(text: t.rtn);
    _motor = TextEditingController(text: t.motor);
    _telefono = TextEditingController(text: t.numerotel);
    _cotizado = t.cotizado;
    _fecha = t.fecha ?? DateTime.now();

    final todosCampos = _categorias.values.expand((e) => e);
    for (var campo in todosCampos) {
      _campos[campo] = TextEditingController(
        text: t.toMap()[campo]?.toString() ?? '0.0',
      );
    }

    for (var key in _categorias.keys) {
      _expandidos[key] = false;
    }
  }

  double _getDouble(String key) =>
      double.tryParse(_campos[key]?.text.trim() ?? '') ?? 0.0;

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
    final actualizado = Trabajos(
      id: widget.trabajo.id,
      nombre: _nombre.text.trim(),
      rtn: _rtn.text.trim(),
      motor: _motor.text.trim(),
      numerotel: _telefono.text.trim(),
      cotizado: _cotizado,
      fecha: _fecha,
      // Aquí vas a mapear los valores según el modelo original
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

    widget.onEdit(actualizado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text('Editar Trabajo'),
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
              for (var categoria in _categorias.entries)
                ExpansionTile(
                  title: Text(
                    categoria.key,
                    style: const TextStyle(color: Colors.black),
                  ),
                  initiallyExpanded: _expandidos[categoria.key] ?? false,
                  onExpansionChanged: (v) {
                    setState(() {
                      _expandidos[categoria.key] = v;
                    });
                  },
                  children: categoria.value.map((campo) {
                    return _campo(campo, _campos[campo]!);
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
                    'Guardar Cambios',
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
