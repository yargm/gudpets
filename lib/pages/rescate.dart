import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import '../shared/colores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Rescate extends StatefulWidget {
  final RescateModel objeto;
  bool favorito;

  Rescate({this.objeto, this.favorito});

  @override
  _RescateState createState() => _RescateState();
}

class _RescateState extends State<Rescate> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    Completer<GoogleMapController> _controller = Completer();
    List<Marker> marcador = [
      Marker(
        markerId: MarkerId('rescateMarker'),
        draggable: false,
        position: LatLng(widget.objeto.ubicacion.latitude,
            widget.objeto.ubicacion.longitude),
      ),
    ];
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
          child: Card(
        margin: EdgeInsets.only(bottom: 20, top: 30, right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: widget.objeto.userName.length * 11.5,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Text('Fecha de publicación: ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.objeto.fecha.day.toString() +
                                    '/' +
                                    widget.objeto.fecha.month.toString() +
                                    '/' +
                                    widget.objeto.fecha.year.toString(),
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Mas Fotos',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    Container(
                      width: double.infinity,
                      height: 350.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.objeto.foto),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Ubicación: ',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 300.0,
                      width: 400.0,
                      child: GoogleMap(
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
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
        ),
      )),
    );
  }
}

_favtrue(bool favorito, Controller controlador1, RescateModel objeto) {
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

_favfalse(bool favorito, Controller controlador1, RescateModel objeto) {
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
