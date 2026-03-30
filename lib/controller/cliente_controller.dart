import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avance2/models/cliente.dart';

class ClienteController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _coleccion = 'clientes';

  Future<void> crearCliente(Cliente cliente) async {
    await _db.collection(_coleccion).doc(cliente.id).set(cliente.toMap());
  }

  Future<void> actualizarCliente(Cliente cliente) async {
    await _db.collection(_coleccion).doc(cliente.id).update(cliente.toMap());
  }

  Future<void> eliminarCliente(String id) async {
    await _db.collection(_coleccion).doc(id).delete();
  }

  Future<List<Cliente>> obtenerClientes() async {
    final snapshot = await _db.collection(_coleccion).get();
    return snapshot.docs.map((doc) => Cliente.fromMap(doc.data())).toList();
  }

  Stream<List<Cliente>> streamClientes() {
    return _db.collection(_coleccion).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Cliente.fromMap(doc.data())).toList();
    });
  }
}
