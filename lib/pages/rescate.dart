import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

import '../shared/colores.dart';
import '../shared/colores.dart';
import '../shared/colores.dart';

class Rescate extends StatefulWidget {
  final RescateModel objeto;

  Rescate({this.objeto});

  @override
  _RescateState createState() => _RescateState();
}

class _RescateState extends State<Rescate> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.objeto.documentId,
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
            ),
          )
        ],
      )),
    );
  }
}
