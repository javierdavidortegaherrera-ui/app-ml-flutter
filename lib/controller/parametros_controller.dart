import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avance2/models/parametro.dart';

class ParametroController {
  final _db = FirebaseFirestore.instance;
  final String _coleccion = 'parametros';

  Future<void> crearParametro(Parametro parametro) async {
    await _db.collection(_coleccion).doc(parametro.id).set(parametro.toJson());
  }

  Future<void> actualizarParametro(Parametro parametro) async {
    await _db
        .collection(_coleccion)
        .doc(parametro.id)
        .update(parametro.toJson());
  }

  Future<void> eliminarParametro(String id) async {
    await _db.collection(_coleccion).doc(id).delete();
  }

  Future<List<Parametro>> obtenerParametros() async {
    final snapshot = await _db.collection(_coleccion).get();
    return snapshot.docs.map((doc) => Parametro.fromJson(doc.data())).toList();
  }
}
