import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Perdido extends StatefulWidget {
  final PerdidoModel objeto;

  Perdido({this.objeto});

  @override
  _PerdidoState createState() => _PerdidoState();
}

class _PerdidoState extends State<Perdido> {
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
                tag: widget.objeto.document_id,
                child: Container(
                  width: double.infinity,
                  height: 350.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.objeto.foto),
                          fit: BoxFit.cover)),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}