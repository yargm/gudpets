import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class Adopcion extends StatefulWidget {
  final AdopcionModel objeto;
  final bool favorito;

  Adopcion({this.objeto, this.favorito});

  @override
  _AdopcionState createState() => _AdopcionState();
}

class _AdopcionState extends State<Adopcion> {
  int index = 0;

  void _next() {
    setState(() {
      if (index < widget.objeto.fotos.length - 1) {
        index++;
      } else {
        index = index;
      }
    });
  }

  void _prev() {
    setState(() {
      if (index > 0) {
        index--;
      } else {
        index = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    UsuarioModel userpublicacion;
    controlador1.adopcion = widget.objeto;

    Widget _indicator(bool isActive) {
      return Expanded(
        child: Container(
          height: 4,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isActive ? Colors.white : Colors.grey[800]),
        ),
      );
    }

    List<Widget> _buildIndicator() {
      List<Widget> indicators = [];
      for (int i = 0; i < widget.objeto.fotos.length; i++) {
        if (index == i) {
          indicators.add(_indicator(true));
        } else {
          indicators.add(_indicator(false));
        }
      }

      return indicators;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('¡Adóptame!'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 350,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageViewer(
                          image: widget.objeto.fotos[index],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Hero(
                          tag: widget.objeto.documentId,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/dog.png'),
                            width: double.maxFinite,
                            height: 350,
                            image: NetworkImage(widget.objeto.fotos[index]),
                          )),
                      GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            print("next");
                            _prev();
                          } else if (details.velocity.pixelsPerSecond.dx < 0) {
                            _next();
                          }
                        },
                        child: Container(
                          height: 350,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  colors: [
                                Colors.black.withOpacity(.3),
                                Colors.black.withOpacity(.3),
                              ])),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 45,
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                children: _buildIndicator(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  widget.objeto.titulo,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.10,
                                  ),
                                ),
                                SizedBox(width: 5),
                                widget.objeto.sexo == "Hembra"
                                    ? Icon(FontAwesomeIcons.venus,
                                        color: Colors.pink[100])
                                    : Icon(FontAwesomeIcons.mars,
                                        color: Colors.blue[100])
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                            color: Colors.brown[300]),
                        padding: EdgeInsets.all(5.0),
                        alignment: Alignment.bottomRight,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('usuarios')
                                .doc(widget.objeto.userId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Container(
                                    height: 50,
                                    child: const CircularProgressIndicator());

                              userpublicacion =
                                  UsuarioModel.fromDocumentSnapshot(
                                      snapshot.data, 'meh');
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Perfil(
                                              usuario: userpublicacion)));
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundImage:
                                            NetworkImage(userpublicacion.foto),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.25,
                                        child: Text(
                                          userpublicacion.nombre,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.objeto.lugar,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.width * 0.20,
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Positioned(
                                  top: 0,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.18,
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              spreadRadius: 3,
                                              blurRadius: 3)
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, left: 10, right: 10),
                                    child: Text(
                                      "Tipo",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    )),
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
                              ]),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.20,
                          width: MediaQuery.of(context).size.width * 0.18,
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Positioned(
                                  top: 0,
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.18,
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              spreadRadius: 3,
                                              blurRadius: 3)
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 30, left: 10, right: 10),
                                    child: Text(
                                      widget.objeto.edad,
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    )),
                                Icon(Icons.cake),
                              ]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: 300,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.32,
                                width: 300,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.2),
                                        spreadRadius: 3,
                                        blurRadius: 3)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 30, left: 15, right: 10, bottom: 15),
                              child: Expanded(
                                flex: 1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    widget.objeto.descripcion,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              )),
                          Icon(Icons.description)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Convive con otros animales: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          widget.objeto.convivenciaotros
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.convivenciaotros
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Desparacitado: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          widget.objeto.desparacitacion
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.desparacitacion
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Vacunado: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          widget.objeto.vacunacion
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.vacunacion
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Esterilizado: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          widget.objeto.esterilizacion
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.esterilizacion
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      endIndent: 60,
                      indent: 60,
                      thickness: 1,
                      color: secondaryDark,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
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
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  favtrue(bool favorito, Controller controlador1, AdopcionModel objeto) {
    objeto.reference.update({
      'favoritos': FieldValue.arrayUnion([controlador1.usuario.documentId]),
    });
    controlador1.usuario.reference.update(
      {
        'adopciones': FieldValue.arrayUnion([
          {
            'imagen': objeto.fotos[0],
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }

  favfalse(bool favorito, Controller controlador1, AdopcionModel objeto) {
    objeto.reference.update({
      'favoritos': FieldValue.arrayRemove([controlador1.usuario.documentId])
    });
    controlador1.usuario.reference.update(
      {
        'adopciones': FieldValue.arrayRemove([
          {
            'imagen': objeto.fotos[0],
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }
}
