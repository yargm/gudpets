import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import '../shared/colores.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

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
        mainAxisSize: MainAxisSize.min,
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
                mainAxisSize: MainAxisSize.min,
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.call,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
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
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Teléfono

                            SizedBox(
                              height: 20,
                            ),
                            //Fecha publicación
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
                    ],
                  ),
                  SizedBox(height: 30,),
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
                      Icon(Icons.photo_album),
                      Text('Álbum',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  widget.objeto.fotos.isNotEmpty
                      ? Column(
                          children: <Widget>[
                           widget.objeto.fotos.length > 1 ? Text(
                              "Deslice para ver mas fotos",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ) : Container(),
                            Container(
                              height: 350,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ScrollPhysics(
                                    parent: BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics())),
                                itemBuilder: (context, index) => FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder: AssetImage('assets/dog.png'),
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  height: 300,
                                  image:
                                      NetworkImage(widget.objeto.fotos[index]),
                                ),
                                itemCount: widget.objeto.fotos.length,
                              ),
                            )
                          ],
                        )
                      : Text(
                          'No hay nada para mostrar',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                   SizedBox(height: 30,),
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
                      Text('Ubicación: ',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  widget.objeto.ubicacion.latitude != 0
                      ? Container(
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
                        )
                      : Text("No hay ubicación para mostrar"),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              )),
        ],
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
