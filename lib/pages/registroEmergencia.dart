import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:adoption_app/services/services.dart';

class RegistroEmergencia extends StatefulWidget{
  @override
  _RegistroEmergenciaState createState() => _RegistroEmergenciaState();
}

class _RegistroEmergenciaState extends State<RegistroEmergencia> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Registra tu emergencia'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Hola'),
          ],
        ),
      ),
    );
  }
}