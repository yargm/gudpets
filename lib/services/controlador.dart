import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';

class Controller with ChangeNotifier {
  int pestana_act = 0;

  UsuarioModel usuario_act;

  UsuarioModel get usuario => usuario_act;

  agregausuario(UsuarioModel usuario) {
    usuario_act = usuario;
  }
}
