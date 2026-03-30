import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avance2/models/trabajo.dart';

class TrabajoController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _coleccion = 'trabajos';

  Future<void> crearTrabajo(Trabajos trabajo) async {
    await _db.collection(_coleccion).doc(trabajo.id).set(trabajo.toMap());
  }

  Future<void> actualizarTrabajo(Trabajos trabajo) async {
    await _db.collection(_coleccion).doc(trabajo.id).update(trabajo.toMap());
  }

  Future<void> eliminarTrabajo(Trabajos trabajo) async {
    await _db.collection(_coleccion).doc(trabajo.id).delete();
  }

  Future<void> actualizarCampo(String id, String campo, dynamic valor) async {
    await _db.collection(_coleccion).doc(id).update({campo: valor});
  }

  Future<List<Trabajos>> obtenerTrabajos() async {
    final snapshot = await _db.collection(_coleccion).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Trabajos.fromMap(data);
    }).toList();
  }

  Stream<List<Trabajos>> streamTrabajos() {
    return _db.collection(_coleccion).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Trabajos.fromMap(doc.data())).toList();
    });
  }
}
