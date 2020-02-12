import 'pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/shared/shared.dart';

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
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            child: DialogBody(
                              controlador1: controlador1,
                              objeto: objeto,
                              foto: objeto.foto ?? '',
                            ),
                          ),
                          child: Hero(
                            tag: objeto.userId,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(180),
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder:
                                    AssetImage('assets/perriti_pic.png'),
                                width: 120,
                                height: 120,
                                image: NetworkImage(objeto.foto),
                              ),
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
                  Text(
                    'Información básica',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
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
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      child: DialogBody(
                        controlador1: controlador1,
                        objeto: objeto,
                        foto: objeto.fotoINE ?? '',
                      ),
                    ),
                    child: Container(
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
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      child: DialogBody(
                        controlador1: controlador1,
                        objeto: objeto,
                        foto: objeto.fotoCompDomi ?? '',
                      ),
                    ),
                    child: Container(
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
                                  image:
                                      NetworkImage(objeto.fotoCompDomi ?? ''),
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
                                child: DialogBody(
                                  controlador1: controlador1,
                                  objeto: objeto,
                                  foto: objeto.galeriaFotos[index],
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
                  ),
                  Divider(
                    endIndent: 20,
                    indent: 20,
                    thickness: 1,
                  ),
                  Text('¿Deseas que esta persona adopte a tu mascota?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: RaisedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("¿Estas seguro de esta decisión?"),
                              content: Text(
                                  "Una vez que aceptes a este usuario tu publicación en la sección de Adopción desaparecerá y no podrá ser restablecida. Esta decisión es muy importante tanto para ti como para la mascota. Recuerda que es tu responsabilidad verificar que esta persona cumpla con todo los requisitos necesarios que conlleva una adopción. Para confirmar da click sobre el botón Aceptar."),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("CANCELAR"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text("ACEPTAR"),
                                  onPressed: () async {
                                    await controlador1.adopcion.reference
                                        .updateData({
                                      'status': 'adoptado',
                                      'adoptanteNombre': objeto.nombre,
                                      'adoptanteINE': objeto.fotoINE,
                                      'adoptanteCorreo': objeto.correo,
                                      'adoptanteFoto': objeto.foto,
                                      'adoptanteTelefono': objeto.telefono,
                                      'adoptanteId': objeto.userId
                                    });

                                    controlador1.adopcion.adoptanteNombre =
                                        controlador1.usuario.nombre;
                                    controlador1.adopcion.adoptanteTelefono =
                                        controlador1.usuario.telefono;
                                    controlador1.adopcion.adoptanteCorreo =
                                        controlador1.usuario.correo;
                                    controlador1.adopcion.adoptanteFoto =
                                        controlador1.usuario.foto;
                                    controlador1.adopcion.adoptanteINE =
                                        controlador1.usuario.fotoINE;
                                    controlador1.adopcion.adoptanteId =
                                        controlador1.usuario.documentId;
                                    controlador1.adopcion.status = 'adoptado';
                                    await Firestore.instance
                                        .collection('usuarios')
                                        .document(objeto.userId)
                                        .collection('adoptados')
                                        .add(controlador1.adopcion.toMap());
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        child: WillPopScope(
                                            onWillPop: () async {
                                              return false;
                                            },
                                            child: AlertDialog(
                                              title: Text('Proceso concluido ',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              content: Text(
                                                  'El proceso de Adopción se completó con éxito',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              actions: <Widget>[
                                                FlatButton(
                                                    child: Text('OK'),
                                                    onPressed: () {
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                Home()),
                                                        ModalRoute.withName(
                                                            '/home'),
                                                      );
                                                    })
                                              ],
                                            )));
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Aceptar'),
                    ),
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

class DialogBody extends StatelessWidget {
  const DialogBody(
      {Key key,
      @required this.controlador1,
      @required this.objeto,
      @required this.foto})
      : super(key: key);

  final Controller controlador1;
  final SolicitudModel objeto;
  final String foto;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
              child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            UserBanner(
              usuario: objeto,
              extended: false,
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  height: 300,
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(foto),
                  placeholder: AssetImage('assets/dog.png'),
                  width: double.maxFinite,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
