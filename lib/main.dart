import 'package:adoption_app/adoption.dart';
import 'package:adoption_app/login.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'registrousuario.dart';
import 'home2.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
 
      home: LogIn(),
      routes: {
        '/home': (BuildContext context) => HomePage(),
        '/adoption': (BuildContext context) => Adoption(),
        '/registrousuario': (BuildContext context) => RegistroUsuario(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
