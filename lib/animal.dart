import 'package:flutter/material.dart';
import 'models.dart';
import 'adoption.dart';

class Animal extends StatelessWidget {
  final AnimalModel objeto;

  Animal({this.objeto});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 40.0, bottom: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Adoption(objeto: objeto)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: objeto.nombre,
                  child: Container(
                    width: double.infinity,
                    height: 250.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
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
          padding: EdgeInsets.only(left: 40.0, bottom: 20.0),
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
