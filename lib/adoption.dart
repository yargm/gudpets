import 'package:flutter/material.dart';
import 'models.dart';
import 'registrousuario.dart';

class Adoption extends StatefulWidget {
  final AnimalModel objeto;

  Adoption({this.objeto});

  @override
  _AdoptionState createState() => _AdoptionState();
}

class _AdoptionState extends State<Adoption> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                  tag: widget.objeto.nombre,
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
