import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      home: Home(),
      routes: {
        '/login': (BuildContext context) => LogIn(),
        '/registro_usuario': (BuildContext context) => RegistroUsuario(),
        '/home': (BuildContext context) => Home(),
        '/adopcion': (BuildContext context) => Adopcion(),
        '/perdido': (BuildContext context) => Perdido(),
        '/rescate': (BuildContext context) => Rescate(),
        '/emergencia': (BuildContext context) => Emergencia(),
      },
    );
  }
}
