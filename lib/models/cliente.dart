class Cliente {
  final String id;
  final String nombre;
  final String rtn;
  final String telefono;
  final String tipoMotor;

  Cliente({
    required this.id,
    required this.nombre,
    required this.rtn,
    required this.telefono,
    required this.tipoMotor,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      rtn: map['rtn'] ?? '',
      telefono: map['telefono'] ?? '',
      tipoMotor: map['tipoMotor'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'rtn': rtn,
      'telefono': telefono,
      'tipoMotor': tipoMotor,
    };
  }
}
