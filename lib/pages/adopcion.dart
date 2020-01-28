import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Adopcion extends StatefulWidget {
  final AdopcionModel objeto;
  bool favorito;

  Adopcion({this.objeto, this.favorito});

  @override
  _AdopcionState createState() => _AdopcionState();
}

class _AdopcionState extends State<Adopcion> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            FontAwesomeIcons.chevronCircleLeft,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      placeholder: AssetImage('assets/perriti_pic.png'),
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
        ],
      )),
    );
  }
}
