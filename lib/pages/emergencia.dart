import 'package:adoption_app/main.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

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
    Completer<GoogleMapController> _controller = Completer();

    List<Marker> marcador = [
      Marker(
        markerId: MarkerId('emergenciaMarker'),
        draggable: false,
        position: LatLng(widget.objeto.ubicacion.latitude,
            widget.objeto.ubicacion.longitude),
      ),
    ];

    // TODO: implement build
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
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
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
                      placeholder: AssetImage('assets/dog.png'),
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
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        Icon(Icons.adjust),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Tipo de emergencia: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              Text(widget.objeto.tipoEmergencia,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ]),
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
                    height: 20.0,
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
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_on),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Ubicación: ',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
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
                  widget.objeto.tipoEmergencia == 'Abuso y maltrato'
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15.0,
                            ),
                            Text('¿Cómo denunciar?',
                                style: TextStyle(
                                  fontSize: 20.0,
                                )),
                            SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Image.asset('assets/denuncia2.jpg', 
                                  width: 700,
                                  height: 500,
                                    
                                  ),
                                )
                              ),
                                                          child: Container(
                                  height: 200.0,
                                  width: 400.0,
                                  child: Image.asset('assets/denuncia2.jpg')),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              )),
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
