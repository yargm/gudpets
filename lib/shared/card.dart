import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class EmergenciaCard extends StatelessWidget {
  final dynamic objeto;
  final int posicion;
  
final double containerPadding = 80;
final double containerPadding2 = 80;
final double containerBorderRadius = 15;

  EmergenciaCard({this.objeto, this.posicion});
  @override
  
  Widget build(BuildContext context) {
print(posicion.toString());
    var leftAligned = (posicion% 2 == 0 )? true : false;
   
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
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),R
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: objeto.user_id,
                  child: Container(
                   width: double.maxFinite,
                   height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: leftAligned ? Radius.circular(0) : Radius.circular(40.0),
                          topRight: leftAligned ? Radius.circular(40.0) : Radius.circular(0),
                          bottomLeft: leftAligned ? Radius.circular(0) : Radius.circular(40.0),
                          bottomRight: leftAligned ? Radius.circular(40.0) : Radius.circular(0),
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
        Padding(
          padding: EdgeInsets.only(left:10.0),
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
                
                padding: leftAligned ?  EdgeInsets.only(right: 30) : EdgeInsets.only(right: 5),
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
        Align(
          alignment:Alignment.centerLeft ,
                  child: Padding(
            padding: EdgeInsets.only(left:20,right: 30, bottom: 20.0),
            child: Text(objeto.descripcion,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  color: Colors.grey,
                )),
          ),
        ),
      ],
    ));
  }
}
