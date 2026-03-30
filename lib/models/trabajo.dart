import 'package:cloud_firestore/cloud_firestore.dart';

class Trabajos {
  String id;
  String nombre;
  String rtn;
  String numerotel;
  String motor;
  bool cotizado;
  final DateTime? fecha;

  // Culatas
  final double cepillar;
  final double rectiAsientos;
  final double rectivalvulas;
  final double rectiguias;
  final double fabriasientos;
  final double acoplarguias;
  final double fabricunas;
  final double cambprecamaras;
  final double cambcapuchones;
  final double asentararmarcali;
  final double alineartunel;
  final double pruebafuga;

  // Cigüeñal
  final double rectificarBancadaYBielas;
  final double hacerPuntoRetenedorDelantero;
  final double hacerPuntoRetenedorTrasero;
  final double cambiarBalinerasYEngranaje;
  final double enderezadoYTorsion;
  final double pulirCiguenal;

  // Block
  final double rectificarCilindros;
  final double encamisarCilindrosSTD;
  final double alinearTunelBancada;
  final double cambiarTunelEjesLevas;

  // Bielas
  final double rectificarHousing;
  final double cambiarBujes;
  final double cambiarPistones;

  Trabajos({
    required this.id,
    required this.nombre,
    required this.rtn,
    required this.motor,
    required this.numerotel,
    required this.cotizado,
    this.fecha,

    // Culatas
    required this.cepillar,
    required this.rectiAsientos,
    required this.rectivalvulas,
    required this.rectiguias,
    required this.fabriasientos,
    required this.acoplarguias,
    required this.fabricunas,
    required this.cambprecamaras,
    required this.cambcapuchones,
    required this.asentararmarcali,
    required this.alineartunel,
    required this.pruebafuga,

    // Cigüeñal
    required this.rectificarBancadaYBielas,
    required this.hacerPuntoRetenedorDelantero,
    required this.hacerPuntoRetenedorTrasero,
    required this.cambiarBalinerasYEngranaje,
    required this.enderezadoYTorsion,
    required this.pulirCiguenal,

    // Block
    required this.rectificarCilindros,
    required this.encamisarCilindrosSTD,
    required this.alinearTunelBancada,
    required this.cambiarTunelEjesLevas,

    // Bielas
    required this.rectificarHousing,
    required this.cambiarPistones,
    required this.cambiarBujes,
  });

  /// Método para calcular el total a pagar con impuesto del 15%
  double totalapagar() {
    final subtotal =
        cepillar +
        rectiAsientos +
        rectivalvulas +
        rectiguias +
        fabriasientos +
        acoplarguias +
        fabricunas +
        cambprecamaras +
        cambcapuchones +
        asentararmarcali +
        alineartunel +
        pruebafuga +
        rectificarBancadaYBielas +
        hacerPuntoRetenedorDelantero +
        hacerPuntoRetenedorTrasero +
        cambiarBalinerasYEngranaje +
        enderezadoYTorsion +
        pulirCiguenal +
        rectificarCilindros +
        encamisarCilindrosSTD +
        alinearTunelBancada +
        cambiarTunelEjesLevas +
        rectificarHousing +
        cambiarBujes +
        cambiarPistones;

    final impuesto = subtotal * 0.15;
    return subtotal + impuesto;
  }

  factory Trabajos.fromMap(Map<String, dynamic> map) {
    return Trabajos(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      rtn: map['rtn'] ?? '',
      numerotel: map['numerotel'] ?? '',
      motor: map['motor'] ?? '',
      cotizado: map['cotizado'] ?? false,
      fecha: map['fecha'] != null
          ? (map['fecha'] is Timestamp
                ? (map['fecha'] as Timestamp).toDate()
                : DateTime.tryParse(map['fecha']))
          : null,

      // Culatas
      cepillar: (map['cepillar'] ?? 0).toDouble(),
      rectiAsientos: (map['rectiAsientos'] ?? 0).toDouble(),
      rectivalvulas: (map['rectivalvulas'] ?? 0).toDouble(),
      rectiguias: (map['rectiguias'] ?? 0).toDouble(),
      fabriasientos: (map['fabriasientos'] ?? 0).toDouble(),
      acoplarguias: (map['acoplarguias'] ?? 0).toDouble(),
      fabricunas: (map['fabricunas'] ?? 0).toDouble(),
      cambprecamaras: (map['cambprecamaras'] ?? 0).toDouble(),
      cambcapuchones: (map['cambcapuchones'] ?? 0).toDouble(),
      asentararmarcali: (map['asentararmarcali'] ?? 0).toDouble(),
      alineartunel: (map['alineartunel'] ?? 0).toDouble(),
      pruebafuga: (map['pruebafuga'] ?? 0).toDouble(),

      // Cigüeñal
      rectificarBancadaYBielas: (map['rectificarBancadaYBielas'] ?? 0)
          .toDouble(),
      hacerPuntoRetenedorDelantero: (map['hacerPuntoRetenedorDelantero'] ?? 0)
          .toDouble(),
      hacerPuntoRetenedorTrasero: (map['hacerPuntoRetenedorTrasero'] ?? 0)
          .toDouble(),
      cambiarBalinerasYEngranaje: (map['cambiarBalinerasYEngranaje'] ?? 0)
          .toDouble(),
      enderezadoYTorsion: (map['enderezadoYTorsion'] ?? 0).toDouble(),
      pulirCiguenal: (map['pulirCiguenal'] ?? 0).toDouble(),

      // Block
      rectificarCilindros: (map['rectificarCilindros'] ?? 0).toDouble(),
      encamisarCilindrosSTD: (map['encamisarCilindrosSTD'] ?? 0).toDouble(),
      alinearTunelBancada: (map['alinearTunelBancada'] ?? 0).toDouble(),
      cambiarTunelEjesLevas: (map['cambiarTunelEjesLevas'] ?? 0).toDouble(),

      // Bielas
      rectificarHousing: (map['rectificarHousing'] ?? 0).toDouble(),
      cambiarPistones: (map['cambiarPistones'] ?? 0).toDouble(),
      cambiarBujes: (map['cambiarBujes'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'rtn': rtn,
      'numerotel': numerotel,
      'motor': motor,
      'cotizado': cotizado,
      'fecha': fecha?.toIso8601String(),

      // Culatas
      'cepillar': cepillar,
      'rectiAsientos': rectiAsientos,
      'rectivalvulas': rectivalvulas,
      'rectiguias': rectiguias,
      'fabriasientos': fabriasientos,
      'acoplarguias': acoplarguias,
      'fabricunas': fabricunas,
      'cambprecamaras': cambprecamaras,
      'cambcapuchones': cambcapuchones,
      'asentararmarcali': asentararmarcali,
      'alineartunel': alineartunel,
      'pruebafuga': pruebafuga,

      // Cigüeñal
      'rectificarBancadaYBielas': rectificarBancadaYBielas,
      'hacerPuntoRetenedorDelantero': hacerPuntoRetenedorDelantero,
      'hacerPuntoRetenedorTrasero': hacerPuntoRetenedorTrasero,
      'cambiarBalinerasYEngranaje': cambiarBalinerasYEngranaje,
      'enderezadoYTorsion': enderezadoYTorsion,
      'pulirCiguenal': pulirCiguenal,

      // Block
      'rectificarCilindros': rectificarCilindros,
      'encamisarCilindrosSTD': encamisarCilindrosSTD,
      'alinearTunelBancada': alinearTunelBancada,
      'cambiarTunelEjesLevas': cambiarTunelEjesLevas,

      // Bielas
      'rectificarHousing': rectificarHousing,
      'cambiarPistones': cambiarPistones,
      'cambiarBujes': cambiarBujes,
    };
  }
}
