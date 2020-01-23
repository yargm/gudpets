import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class Avisos extends StatelessWidget {
  final AvisoModel objeto;

  Avisos({this.objeto});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Card(
          color: Colors.white70,
          margin: EdgeInsets.symmetric(horizontal: 5),
          elevation: 9.0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)),
          child: GestureDetector(
            onTap: () => launch(objeto.link),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Image(
                  image: NetworkImage(objeto.imagen),
                  width: 350.0,
                  height: 300.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.globe),
                    Text('Ver más')
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
