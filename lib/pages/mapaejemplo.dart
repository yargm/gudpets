import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gudpets/services/services.dart';

class MapSample extends StatefulWidget {
  final double latitud;
  final double longitud;
  final Controller controlador1;

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
        markerId: MarkerId('Aqui'),
        draggable: true,
        position: LatLng(widget.latitud, widget.longitud),
        onDragEnd: (value) {
          setState(() {
            double newlatitud = value.latitude;
            double newlongitud = value.longitude;
            widget.controlador1.latitudfinal = newlatitud;
            widget.controlador1.longitudfinal = newlongitud;
            print('la latitud nueva es:' +
                widget.controlador1.latitudfinal.toString());
            print('la longitud nueva es:' +
                widget.controlador1.longitudfinal.toString());
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
          Navigator.pop(context);
          print('la latitud final es:' +
              widget.controlador1.latitudfinal.toString());
          print('la latitud final es:' +
              widget.controlador1.longitudfinal.toString());
        },
        label: Text('Guardar'),
        icon: Icon(Icons.location_on),
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
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
