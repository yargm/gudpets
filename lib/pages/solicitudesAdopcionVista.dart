import 'package:gudpets/pages/perfilAdopcion.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/shared/shared.dart';

class SolicitudAdopcionVista extends StatefulWidget {
  final SolicitudModel objeto;


  SolicitudAdopcionVista({this.objeto});

  @override
  _SolicitudAdopcionVistaState createState() => _SolicitudAdopcionVistaState();
}

class _SolicitudAdopcionVistaState extends State<SolicitudAdopcionVista> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      onTap: () {
        return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PerfilAdopcion(
                objeto: widget.objeto,
              ),
            ));
      },
      title: Text(
        widget.objeto.nombre,
        style: TextStyle(fontSize: 20),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.objeto.foto),
      ),
      subtitle: Text('Edad: ' + widget.objeto.edad.toString()),
    );
  }
}
