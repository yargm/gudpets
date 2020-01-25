import 'package:adoption_app/main.dart';
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
          child: Card(
        margin: EdgeInsets.only(bottom: 20, top: 20, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                      color: Colors.brown[300]),
                  padding: EdgeInsets.all(10.0),
                  width: 175.0,
                  alignment: Alignment.bottomRight,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        widget.objeto.userName,
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.objeto.titulo,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(FontAwesomeIcons.dog),
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
                                ? _favtrue(widget.favorito, controlador1,
                                    widget.objeto)
                                : _favfalse(widget.favorito, controlador1,
                                    widget.objeto);

                            setState(() {
                              widget.favorito
                                  ? widget.favorito = false
                                  : widget.favorito = true;
                            });

                            print(widget.favorito.toString());
                          },
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                      child: Text(widget.objeto.descripcion,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  'Tipo de emergencia: ' +
                                      widget.objeto.tipoEmergencia,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      color: primaryDark,
                      height: 200.0,
                      width: 200.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                )),
          ],
        ),
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
