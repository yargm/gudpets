import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // initialRoute: '/login',
      home: Home(),
      routes: {
        '/emergencia_list': (BuildContext context) => EmergenciaList(),
        '/registro_usuario': (BuildContext context) => RegistroUsuario(),
        '/login': (BuildContext context) => LogIn(),
      },
    );
  }
}
