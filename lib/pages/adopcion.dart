import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'dart:async';

class Adopcion extends StatefulWidget {
  final AdopcionModel objeto;
  bool favorito;

  Adopcion({this.objeto, this.favorito});

  @override
  _AdopcionState createState() => _AdopcionState();
}

class _AdopcionState extends State<Adopcion> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FontAwesomeIcons.chevronCircleLeft,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(

          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 350,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Hero(
                    tag: widget.objeto.documentId,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/perriti_pic.png'),
                      width: double.maxFinite,
                      height: 350,
                      image: NetworkImage(widget.objeto.foto),
                    )),

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
                        Column(
                          children: <Widget>[
                            Text('Tipo:', style: TextStyle(fontSize: 12)),
                            widget.objeto.tipoAnimal == 'perro'
                                ? Icon(FontAwesomeIcons.dog)
                                : widget.objeto.tipoAnimal == 'gato'
                                    ? Icon(FontAwesomeIcons.cat)
                                    : widget.objeto.tipoAnimal == 'ave'
                                        ? Icon(FontAwesomeIcons.dove)
                                        : Text(
                                            'otro',
                                            style: TextStyle(fontSize: 15),
                                          ),
                          ],
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
                      height: 5.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Fecha de publicación: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              Text(
                                widget.objeto.fecha.day.toString() +
                                    '/' +
                                    widget.objeto.fecha.month.toString() +
                                    '/' +
                                    widget.objeto.fecha.year.toString(),
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Edad: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              Text(widget.objeto.edad,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.grey)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Convivencia con otros: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              widget.objeto.convivenciaotros
                                  ? Text('Sí',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey))
                                  : Text('No'),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Desparacitado: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              widget.objeto.desparacitacion
                                  ? Text('Sí',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey))
                                  : Text('No',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Vacunado: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              widget.objeto.vacunacion
                                  ? Text('Sí',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey))
                                  : Text('No',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Esterilizado: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              widget.objeto.esterilizacion
                                  ? Text('Si',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey))
                                  : Text('No',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey)),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('Sexo: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              Text(widget.objeto.sexo,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.grey)),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ButtonBar(
                      children: <Widget>[
                        RaisedButton.icon(
                          icon: Icon(FontAwesomeIcons.userFriends),
                          label: Text('Interesados'),
                          onPressed: () {return Navigator.of(context).pushNamed('/interesados_adopcion');},
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton.icon(
                          icon: Icon(FontAwesomeIcons.home),
                          label: Text('Adoptar'),
                          onPressed: () {},
                        ),
                      ],
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

  _favtrue(bool favorito, Controller controlador1, AdopcionModel objeto) {
    objeto.reference.updateData({
      'favoritos': FieldValue.arrayUnion([controlador1.usuario.documentId]),
    });
    controlador1.usuario.reference.updateData(
      {
        'adopciones': FieldValue.arrayUnion([
          {
            'imagen': objeto.foto,
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }

  _favfalse(bool favorito, Controller controlador1, AdopcionModel objeto) {
    objeto.reference.updateData({
      'favoritos': FieldValue.arrayRemove([controlador1.usuario.documentId])
    });
    controlador1.usuario.reference.updateData(
      {
        'adopciones': FieldValue.arrayRemove([
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
