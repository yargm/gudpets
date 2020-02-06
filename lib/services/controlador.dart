import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Controller with ChangeNotifier {
  int pestana_act = 0;
  String uid = '';
  String name = '';
  String email = '';
  String imageUrl= '';
  String activeToken;
  bool loading = false;
  String sexo;
  String tipo;

  UsuarioModel usuario_act = UsuarioModel(
    nombre: 'No name',
    foto: '',
  );

  UsuarioModel get usuario => usuario_act;

  notify() {
    notifyListeners();
  }

AdopcionModel adopcion;

  storeToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.getToken().then((value) {
      activeToken = value;
      usuario.reference.updateData({
        'tokens': FieldValue.arrayUnion([value])
      });
    });
  }

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await googleSignIn.signOut();
    await usuario.reference.updateData({
      'tokens' : FieldValue.arrayRemove([activeToken])
    });
    prefs.clear();
  }

  signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('correo', usuario_act.correo);
    await storeToken();
  }

  Future<bool> signInCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('correo') == null) {
      return false;
    } else {
      await Firestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: prefs.getString('correo'))
          .getDocuments()
          .then((onValue) {
        usuario_act =
            UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
      });
      await storeToken();
      return true;
    }
  }

  agregausuario(UsuarioModel usuario) {
    usuario_act = usuario;
  }

  double latitudfinal;
  double longitudfinal;
}
