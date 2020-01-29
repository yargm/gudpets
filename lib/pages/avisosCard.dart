import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

class AvisosCard extends StatelessWidget {
  final AvisoModel objeto;

  AvisosCard({this.objeto});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left:5, right: 5, top: 10),
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: GestureDetector(
            onTap: () => launch(objeto.link),
            child: Column(
              children: <Widget>[
                Image(
                  image: NetworkImage(objeto.imagen),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 15.0,
                ),
                OutlineButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.globe,
                    color: Colors.brown[300],
                  ),
                  onPressed: () => launch(objeto.link),
                  label: Text(
                    'Ver más',
                    style: TextStyle(color: Colors.brown[300]),
                  ),
                  borderSide: BorderSide(color: Colors.brown[300]),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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
