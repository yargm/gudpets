import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:gudpets/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class Perdido extends StatefulWidget {
  final PerdidoModel objeto;
  final bool favorito;

  Perdido({this.objeto, this.favorito});

  @override
  _PerdidoState createState() => _PerdidoState();
}

class _PerdidoState extends State<Perdido> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    Completer<GoogleMapController> _controller = Completer();

    List<Marker> marcador = [
      Marker(
        markerId: MarkerId('perdidoMarker'),
        draggable: false,
        onTap: () {
          controlador1.openMap(widget.objeto.ubicacion.latitude,
              widget.objeto.ubicacion.longitude);
        },
        infoWindow: InfoWindow(
          title: 'Lugar del suceso',
        ),
        position: LatLng(widget.objeto.ubicacion.latitude,
            widget.objeto.ubicacion.longitude),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Image(
                image: AssetImage('assets/gudpetsfirstNoText.png'),
              )),
        ],
        title: Text('GudPets'),
        // leading: IconButton(
        //   color: Colors.white,
        //   onPressed: () => Navigator.of(context).pop(),
        //   icon: Icon(
        //     FontAwesomeIcons.chevronCircleLeft,
        //   ),
        // ),
        // elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.maxFinite,
            height: 350,
            child: GestureDetector(
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: FadeInImage(
                          image: NetworkImage(widget.objeto.album[0]),
                          placeholder: AssetImage('assets/dog.png'),
                        ),
                      ),
                    );
                  }),
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
                        image: NetworkImage(widget.objeto.album[0]),
                      )),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                        ),
                        color: Colors.brown[300]),
                    padding: EdgeInsets.all(10.0),
                    width: widget.objeto.userName.length * 11.1,
                    height: 40,
                    alignment: Alignment.bottomRight,
                    child: Text(
                      widget.objeto.userName,
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
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

                      // IconButton(
                      //   icon: Icon(widget.favorito
                      //       ? Icons.favorite
                      //       : Icons.favorite_border),
                      //   iconSize: 30.0,
                      //   color: Colors.pink,
                      //   onPressed: () {
                      //     !widget.favorito
                      //         ? _favtrue(widget.favorito, controlador1,
                      //             widget.objeto)
                      //         : _favfalse(widget.favorito, controlador1,
                      //             widget.objeto);

                      //     setState(() {
                      //       widget.favorito
                      //           ? widget.favorito = false
                      //           : widget.favorito = true;
                      //     });

                      //     print(widget.favorito.toString());
                      //   },
                      // ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.description),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(widget.objeto.descripcion,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.sentiment_very_dissatisfied),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Fecha de extravío: ',
                              style: TextStyle(
                                fontSize: 20.0,
                              )),
                          Text(
                            widget.objeto.fechaExtravio.day.toString() +
                                '/' +
                                widget.objeto.fechaExtravio.month.toString() +
                                '/' +
                                widget.objeto.fechaExtravio.year.toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.all_inclusive),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Raza: ',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                      Expanded(
                        child: Text(
                          widget.objeto.raza,
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.venusMars),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Sexo: ',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                      Text(
                        widget.objeto.sexo,
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.info),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Señas particulares: ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                )),
                            Text(
                              widget.objeto.senasPart,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.monetization_on),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Recompensa: ',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                      Text(
                        widget.objeto.recompensa != null
                            ? widget.objeto.recompensa
                            : 'No',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.call,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Teléfono: ',
                              style: TextStyle(
                                fontSize: 20.0,
                              )),
                          GestureDetector(
                            onTap: () => launch(
                                "tel://" + widget.objeto.telefono.toString()),
                            child: Text(
                              widget.objeto.telefono.toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Divider(
                    endIndent: 60,
                    indent: 60,
                    thickness: 1,
                    color: secondaryDark,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Ubicación: ',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height: 300.0,
                    width: 400.0,
                    child: GoogleMap(
                      zoomGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      markers: Set.from(marcador),
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.objeto.ubicacion.latitude,
                            widget.objeto.ubicacion.longitude),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              )),
        ],
      )),
    );
  }

  favtrue(bool favorito, Controller controlador1, PerdidoModel objeto) {
    objeto.reference.update({
      'favoritos': FieldValue.arrayUnion([controlador1.usuario.documentId]),
    });
    controlador1.usuario.reference.update(
      {
        'perdidos': FieldValue.arrayUnion([
          {
            'imagen': objeto.album[0],
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }

  favfalse(bool favorito, Controller controlador1, PerdidoModel objeto) {
    objeto.reference.update({
      'favoritos': FieldValue.arrayRemove([controlador1.usuario.documentId])
    });
    controlador1.usuario.reference.update(
      {
        'emergencias': FieldValue.arrayRemove([
          {
            'imagen': objeto.album[0],
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }
}
