import 'pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:flutter/material.dart';

class PerfilAdopcion extends StatelessWidget {
  final SolicitudModel objeto;
  PerfilAdopcion({this.objeto});

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
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: objeto.documentId,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(180),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage('assets/perriti_pic.png'),
                              width: 120,
                              height: 120,
                              image: NetworkImage(objeto.foto),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
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
                            objeto.nombre,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(objeto.correo)
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
                    subtitle: Text(objeto.descripcion),
                    title: Text('Descripción'),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.calendar),
                    subtitle: Text(objeto.edad.toString()),
                    title: Text('Edad'),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.genderless),
                    subtitle: Text(objeto.sexo ?? '???'),
                    title: Text('Sexo'),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.phoneAlt),
                    subtitle: Text(objeto.telefono.toString()),
                    title: Text('Teléfono'),
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
                  Text(
                    'Información necesaria para trámites de adopción',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 130,
                          width: 210,
                          child: Stack(
                            children: <Widget>[
                              FadeInImage(
                                height: 110,
                                width: 210,
                                fit: BoxFit.cover,
                                image: NetworkImage(objeto.fotoINE ?? ''),
                                placeholder:
                                    AssetImage('assets/perriti_pic.png'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Text(
                          'Foto INE',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 130,
                          width: 210,
                          child: Stack(
                            children: <Widget>[
                              FadeInImage(
                                height: 110,
                                width: 210,
                                fit: BoxFit.cover,
                                image: NetworkImage(objeto.fotoCompDomi ?? ''),
                                placeholder:
                                    AssetImage('assets/perriti_pic.png'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Text(
                          'Foto Comprobante de domicilio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ),
                  Divider(
                    endIndent: 20,
                    indent: 20,
                    thickness: 1,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Galeria Fotos de tu hogar',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Estas fotos son necesarias para realizar un trámite de adopción, y estas fotos deben de mostrar el lugar en donde viviran las mascotas que desees adoptar, estas fotos sirven para comprobar que la mascota tendra un hogar adecuado',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(
                              parent: NeverScrollableScrollPhysics()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                child: WillPopScope(
                                  onWillPop: () async {
                                    return controlador1.loading ? false : true;
                                  },
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(),
                                  ),
                                )),
                            child: Image(
                              image: NetworkImage(
                                objeto.galeriaFotos[index],
                              ),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          itemCount: objeto.galeriaFotos.length,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
