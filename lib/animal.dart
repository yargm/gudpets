import 'package:flutter/material.dart';
import 'models.dart';
import 'adoption.dart';

class Animal extends StatelessWidget {
  final AnimalModel objeto;
final double containerPadding = 45;
final double containerPadding2 = 60;
final double containerBorderRadius = 10;
  Animal({this.objeto});
  @override
  Widget build(BuildContext context) {
    var leftAligned = (objeto.id % 2 == 0 )? true : false;
   
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
                    builder: (context) => Adoption(objeto: objeto)),
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
                      tag: objeto.nombre,
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
          padding: EdgeInsets.only(left: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                objeto.nombre,
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
                onPressed: () => print('Corazón'),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only( bottom: 20.0),
          child: Text(objeto.desc,
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
