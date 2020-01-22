import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Emergencia extends StatefulWidget {
  final EmergenciaModel objeto;
  bool favorito;

  Emergencia({this.objeto, this.favorito});

  @override
  _EmergenciaState createState() => _EmergenciaState();
}

class _EmergenciaState extends State<Emergencia> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
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
          Padding(
              padding: EdgeInsets.only(left: 20, top:10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.objeto.titulo,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(widget.favorito
                        ? Icons.favorite
                        : Icons.favorite_border),
                    iconSize: 30.0,
                    color: Colors.pink,
                    onPressed: () {
                      !widget.favorito
                          ? _favtrue(
                              widget.favorito, controlador1, widget.objeto)
                          : _favfalse(
                              widget.favorito, controlador1, widget.objeto);
                      setState(() {
                        widget.favorito
                            ? widget.favorito = false
                            : widget.favorito = true;
                      });
                      print(widget.favorito.toString());
                    },
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.objeto.descripcion,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                )),
          )
        ],
      )),
    );
  }

  _favtrue(bool favorito, Controller controlador1, EmergenciaModel objeto) {
    objeto.reference.updateData({
      'favoritos': FieldValue.arrayUnion([controlador1.usuario.documentId]),
    });
    controlador1.usuario.reference.updateData(
      {
        'emergencias': FieldValue.arrayUnion([
          {
            'imagen': objeto.foto,
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }

  _favfalse(bool favorito, Controller controlador1, EmergenciaModel objeto) {
    objeto.reference.updateData({
      'favoritos': FieldValue.arrayRemove([controlador1.usuario.documentId])
    });
    controlador1.usuario.reference.updateData(
      {
        'emergencias': FieldValue.arrayRemove([
          {
            'imagen': objeto.foto,
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }
}
