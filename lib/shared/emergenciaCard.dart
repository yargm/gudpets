import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class EmergenciaCard extends StatelessWidget {
  final EmergenciaModel objeto;
final double containerPadding = 45;
final double containerPadding2 = 60;
final double containerBorderRadius = 10;
  EmergenciaCard({this.objeto});
  @override
  Widget build(BuildContext context) {
    var leftAligned = (objeto.emergencia_id % 2 == 0 )? true : false;
   
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left:leftAligned ? 0 : containerPadding2, right: leftAligned? containerPadding : 0 ),
        child: Column(
          
      children: <Widget>[
        Padding(
        padding: EdgeInsets.only(left: 0, right: 0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Emergencia(objeto: objeto)),
              );
            },
            child: Container(
              width: double.maxFinite,
              height: 200,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: leftAligned ? Radius.circular(0): Radius.circular(containerBorderRadius),
                  right: leftAligned ? Radius.circular(containerBorderRadius) : Radius.circular(0) ,
                ),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: objeto.emergencia_id,
                      child: Container(
                       width: 400,
                       height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0.0),
                              topRight: Radius.circular(0.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(objeto.foto),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left:20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                objeto.titulo,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                iconSize: 30.0,
                color: Colors.pink,
                onPressed: () {
                  // añadir o quitar de la lista de favoritos del usuario con el controlador
                  print('curazao');
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left:20,right: 30, bottom: 20.0),
          child: Text(objeto.descripcion,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: Colors.grey,
              )),
        ),
      ],
    ));
  }
}
