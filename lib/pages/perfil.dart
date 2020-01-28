import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
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
                        CircleAvatar(
                          backgroundColor: secondaryColor,
                          child: IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () => showDialog(
                              child: WillPopScope(
                                onWillPop: () async {
                                  return false;
                                },
                                child: SimpleDialog(
                                  children: <Widget>[
                                    DialogContent(),
                                  ],
                                ),
                              ),
                              context: context,
                            ),
                          ),
                        )
                      ],
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
                  Text(
                    'Información necesaria para trámites de adopción',
                    textAlign: TextAlign.center,
                  ),
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

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 750, maxWidth: 750);
    setState(() {
      return image;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);
    setState(() {
      return image;
    });
  }
}

class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  var imagen;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              image: imagen == null
                  ? NetworkImage(controlador1.usuario.foto)
                  : FileImage(imagen),
              placeholder: AssetImage('assets/perriti_pic.png'),
            ),
          ),
        ),
        !loading
            ? Column(
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        onPressed: () async {
                          imagen = await getImage();
                          setState(() {
                            imagen = imagen;
                          });
                        },
                        label: Text('Foto Galeria'),
                        icon: Icon(Icons.photo_library),
                      )
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        onPressed: () async {
                          imagen = await getImageCamera();
                          setState(() {
                            imagen = imagen;
                          });
                        },
                        label: Text('Foto Camara'),
                        icon: Icon(Icons.photo_camera),
                      )
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          final String fileName = controlador1.usuario.correo +
                              '/perfil/PP' +
                              DateTime.now().toString();
                          StorageReference storageRef =
                              FirebaseStorage.instance.ref().child(fileName);

                          final StorageUploadTask uploadTask =
                              storageRef.putFile(
                            imagen,
                          );

                          final StorageTaskSnapshot downloadUrl =
                              (await uploadTask.onComplete);

                          if (controlador1.usuario.fotoStorageRef != null) {
                            await FirebaseStorage.instance
                                .ref()
                                .child(controlador1.usuario.fotoStorageRef)
                                .delete()
                                .catchError((onError) {
                              print(onError);
                            });
                          }

                          final String url =
                              (await downloadUrl.ref.getDownloadURL());

                          await controlador1.usuario.reference.updateData({
                            'foto': url,
                            'fotoStorageRef': downloadUrl.ref.path
                          });

                          controlador1.usuario.foto = url;
                          controlador1.usuario.fotoStorageRef =
                              downloadUrl.ref.path;
                          controlador1.notify();

                          Navigator.of(context).pop();
                        },
                        label: Text('Guardar'),
                        icon: Icon(
                          Icons.save,
                        ),
                      )
                    ],
                  )
                ],
              )
            : CircularProgressIndicator(),
      ],
    );
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 750, maxWidth: 750);

    return image;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);

    return image;
  }
}
