import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Perfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Card(
        margin: EdgeInsets.only(bottom: 10, top: 20, right: 5, left: 5),
        child: ListView(
          addSemanticIndexes: true,
          addRepaintBoundaries: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left:15 , right: 15, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Hero(
                    tag: controlador1.usuario.documentId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage('assets/perriti_pic.png'),
                        width: 120,
                        height: 120,
                        image: NetworkImage(controlador1.usuario.foto),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      // decoration: BoxDecoration(
                      //   border: Border(
                      //     bottom: BorderSide(color: secondaryColor),
                      //   ),
                      // ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.dog),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(FontAwesomeIcons.cat),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(FontAwesomeIcons.dove),
                            ],
                          ),
                          Text(
                            controlador1.usuario.nombre,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(controlador1.usuario.correo)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              endIndent: 20,
              indent: 20,
              thickness: 1,
            ),
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text('Información básica'),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    subtitle: Text(controlador1.usuario.descripcion),
                    title: Text('Descrcipcion'),
                    trailing: IconButton(
                      onPressed: () => null,
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.calendar),
                    subtitle: Text(controlador1.usuario.edad.toString()),
                    title: Text('Edad'),
                    trailing: IconButton(
                      onPressed: () => null,
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.genderless),
                    subtitle: Text(controlador1.usuario.sexo ?? '???'),
                    title: Text('Sexo'),
                    trailing: IconButton(
                      onPressed: () => null,
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.phoneAlt),
                    subtitle: Text(controlador1.usuario.telefono.toString()),
                    title: Text('Telefono'),
                    trailing: IconButton(
                      onPressed: () => null,
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              endIndent: 20,
              indent: 20,
              thickness: 1,
            ),
            Container(
              child: Column(
                children: <Widget>[
                   SizedBox(
                    height: 10,
                  ),
                  Text('Información necesaria para trámites de adopción', textAlign: TextAlign.center,),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
