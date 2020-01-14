import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

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
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                  tag: widget.objeto.user_id,
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
                              image: NetworkImage(widget.objeto.fotos),
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
