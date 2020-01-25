import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller with ChangeNotifier {
  int pestana_act = 0;
  String uid;
  String name;
  String email;
  String imageUrl;

  UsuarioModel usuario_act = UsuarioModel(
    nombre: 'No name',
    foto: '',
  );

  UsuarioModel get usuario => usuario_act;

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('correo', usuario_act.correo);
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
      return true;
    }
  }

  agregausuario(UsuarioModel usuario) {
    usuario_act = usuario;
  }

  double latitudfinal;
  double longitudfinal;
}
