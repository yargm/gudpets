import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:adoption_app/services/services.dart';

class MapSample extends StatefulWidget {
  final double latitud;
  final double longitud;
  Controller controlador1;

  MapSample({this.latitud, this.longitud, this.controlador1});
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<Marker> marcadores = [];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _ubicacion;

  void initState() {
    super.initState();

    marcadores.add(Marker(
        markerId: MarkerId('aqui estoy'),
        draggable: true,
        position: LatLng(widget.latitud, widget.longitud),
        onDragEnd: (value) {
          setState(() {
            double newlatitud = value.latitude;
            double newlongitud = value.longitude;
            print('movi a lat:' + newlatitud.toString());
            print('movi a long:' + newlongitud.toString());
            widget.controlador1.latitudfinal = newlatitud;
            widget.controlador1.longitudfinal = newlongitud;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    _ubicacion = CameraPosition(
      target: LatLng(widget.latitud, widget.longitud),
      zoom: 14.4746,
    );
    return new Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            widget.controlador1.latitudfinal.isNaN
                ? widget.controlador1.latitudfinal = widget.latitud
                : widget.controlador1.latitudfinal =
                    widget.controlador1.latitudfinal;
            widget.controlador1.longitudfinal.isNaN
                ? widget.controlador1.longitudfinal = widget.longitud
                : widget.controlador1.longitudfinal =
                    widget.controlador1.longitudfinal;
          });
          Navigator.pop(context);
        },
        label: Text('Guardar'),
        icon: Icon(Icons.location_on),
      ),
      body: GoogleMap(
        markers: Set.from(marcadores),
        mapType: MapType.normal,
        initialCameraPosition: _ubicacion,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
