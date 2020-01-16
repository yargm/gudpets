import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Emergencia extends StatefulWidget {
  final EmergenciaModel objeto;

  Emergencia({this.objeto});

  @override
  _EmergenciaState createState() => _EmergenciaState();
}

class _EmergenciaState extends State<Emergencia> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                  tag: widget.objeto.document_id,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistroUsuario()));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.objeto.foto),
                              fit: BoxFit.cover)),
                    ),
                  )),
            ],
          )
        ],
      )),
    );
  }
}
