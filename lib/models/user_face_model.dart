import 'dart:math';

class UserFaceModel {
  final String name;
  final List<double> embedding;
  final String? imagePath;

  UserFaceModel({
    required this.name,
    required this.embedding,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'embedding': embedding,
      'imagePath': imagePath,
    };
  }

  // Para leer desde un mapa
  factory UserFaceModel.fromMap(Map<String, dynamic> map) {
    return UserFaceModel(
      name: map['name'],
      embedding: List<double>.from(map['embedding']),
      imagePath: map['imagePath'],
    );
  }

  // Comparar dos embeddings con distancia euclidiana
  static double euclideanDistance(List<double> e1, List<double> e2) {
    if (e1.length != e2.length) return double.infinity;
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow(e1[i] - e2[i], 2);
    }
    return sqrt(sum);
  }
}
