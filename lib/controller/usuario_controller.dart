import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avance2/models/usuario.dart';

class UsuarioController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _coleccion = 'usuarios';

  Future<void> crearUsuario(Usuario usuario) async {
    await _db.collection(_coleccion).doc(usuario.id).set(usuario.toJson());
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await _db.collection(_coleccion).doc(usuario.id).update(usuario.toJson());
  }

  Future<void> eliminarUsuario(String id) async {
    await _db.collection(_coleccion).doc(id).delete();
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    final snapshot = await _db.collection(_coleccion).get();
    return snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList();
  }
}
