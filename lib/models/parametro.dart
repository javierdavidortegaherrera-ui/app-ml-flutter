class Parametro {
  final String id;
  final String nombre;
  final String valor;

  Parametro({required this.id, required this.nombre, required this.valor});

  factory Parametro.fromJson(Map<String, dynamic> json) => Parametro(
    id: json['id'] ?? '',
    nombre: json['nombre'] ?? '',
    valor: json['valor'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre, 'valor': valor};
}
