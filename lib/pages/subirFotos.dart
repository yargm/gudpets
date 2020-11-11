import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:photofilters/photofilters.dart';

import 'package:image/image.dart' as imageLib;

class SubirFotos extends StatefulWidget {
  final File image;

  const SubirFotos({Key key, this.image}) : super(key: key);

  @override
  _SubirFotosState createState() => _SubirFotosState();
}

class _SubirFotosState extends State<SubirFotos> {
  bool isLoading = false;
  bool checkedValue = false;
  Map<String, dynamic> post = {
    'foto': '',
    'descripcion': '',
    'mascotas': [],
    'usuario': '',
    'fecha': '',
    'privacidad': false,
    'storageRef': '',
    'favoritos': [],
    'userId': '',
    'numlikes': 0
  };
  String fileName;

  List<Filter> filters = presetFiltersList;

  File imageFile;

  Future getImage(context, File image1) async {
    imageFile = image1;
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          appBarColor: primaryDark,
          title: Text("Aplica algún filtro"),
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile.path);
    }
  }

  final key0 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    Controller controlador1 = Provider.of<Controller>(context);
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        var hola = await showDialog(
            context: context,
            child: AlertDialog(
              title: Text('Saliendo'),
              content: Text('¿Estas seguro que deseas descartar los cambios?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Regresar',
                    style: TextStyle(color: secondaryDark),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    controlador1.mascotas.clear();
                  },
                  child: Text('Descartar cambios'),
                ),
              ],
            ));
        if (hola) {
          return true;
        }

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Subir Foto'),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
              key: key0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      maxLength: 150,
                      onSaved: (value) {
                        post['descripcion'] = value;
                      },
                      // validator: (value) {
                      //   // if (value == null || value.trim() == '') {
                      //   //   return 'El campo  no puede quedar vacio';
                      //   // }
                      //   // return null;
                      // },
                      decoration: InputDecoration(labelText: 'Descripción...'),
                    ),
                  ),
                  StreamBuilder(
                    stream: controlador1.usuarioActual.reference
                        .collection('mascotas')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                            height: 50,
                            child: const CircularProgressIndicator());

                      List<DocumentSnapshot> documents =
                          snapshot.data.documents;

                      return documents.isEmpty
                          ? Container()
                          : Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: ListTile(
                                      title: Text('Etiquetar Mascota'),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: Text(
                                            'Si alguna de tus mascotas aparece en la foto puedes etiquetarla para agregar la foto a su perfil'),
                                      ),
                                    )),
                                GridView.builder(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, bottom: 15, top: 10),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 0,
                                    childAspectRatio: 5,
                                  ),
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    MascotaModel mascota =
                                        MascotaModel.fromDocumentSnapshot(
                                            documents[index]);

                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Checkbox(
                                            activeColor: secondaryDark,
                                            checkColor: primaryDark,
                                            value: controlador1.mascotas
                                                .contains(mascota.documentId),
                                            onChanged: (value) {
                                              if (value) {
                                                controlador1.mascotas
                                                    .add(mascota.documentId);
                                                print(controlador1.mascotas);
                                                controlador1.notify();
                                              } else {
                                                controlador1.mascotas
                                                    .remove(mascota.documentId);
                                                print(controlador1.mascotas);
                                                controlador1.notify();
                                              }
                                              // checkedValue = value;

                                              // print(mascota.nombre);
                                              // controlador1.notify();
                                            }),
                                        Expanded(child: Text(mascota.nombre))
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                    },
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    margin:
                        EdgeInsets.only(top: 10, left: 5, bottom: 15, right: 5),
                    //height: 500,
                    width: MediaQuery.of(context).size.shortestSide,
                    child: Stack(
                      children: [
                        FadeInImage(
                          fit: BoxFit.cover,
                          image: widget.image == null
                              ? AssetImage('assets/dog.png')
                              : imageFile == null
                                  ? FileImage(widget.image)
                                  : FileImage(imageFile),
                          placeholder: AssetImage('assets/dog.png'),
                        ),
                        Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child: RaisedButton(
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.black45,
                              elevation: 10,
                              onPressed: () {
                                getImage(context, widget.image);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.magic,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Filtro'),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Privacidad:  '),
                      Text('Sólo amigos'),
                      Switch(
                        value: post['privacidad'],
                        onChanged: (bool valor) {
                          setState(() {
                            post['privacidad'] = valor;
                          });
                        },
                        activeColor: Colors.blueAccent,
                      ),
                      Text('Pública'),
                    ],
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: () async {
                            setState(() {
                              post['usuario'] = controlador1.usuario.nombre;
                              post['fecha'] = DateTime.now();
                              post['userId'] = controlador1.usuario.documentId;
                              post['mascotas'] = controlador1.mascotas;
                              if (post['mascotas'] == null) {
                                post['mascotas'] = '';
                              }
                              isLoading = true;
                            });
                            // if (!key0.currentState.validate()) {
                            //   setState(() {
                            //     isLoading = false;
                            //   });
                            //   return;
                            // }
                            if (widget.image != null) {
                              final String fileName =
                                  controlador1.usuario.correo +
                                      '/posts/' +
                                      DateTime.now().toString();

                              StorageReference storageRef = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(fileName);
                              final StorageUploadTask uploadTask =
                                  storageRef.putFile(
                                widget.image,
                              );
                              final StorageTaskSnapshot downloadUrl =
                                  (await uploadTask.onComplete);
                              final String fotoref = downloadUrl.ref.path;

                              final String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              print('URL Is $url');
                              setState(() {
                                post['foto'] = url;
                                post['storageRef'] = fotoref;
                                key0.currentState.save();
                                if (post['descripcion'] == null) {
                                  post['descripcion'] = '';
                                }
                              });
                            }
                            var agregar = await controlador1.usuario.reference
                                .collection('posts')
                                .add(post)
                                .then((value) {
                              if (value != null) {
                                return true;
                              } else {
                                return false;
                              }
                            });
                            if (agregar) {
                              controlador1.mascotas.clear();
                              Navigator.of(context).pushNamed('/home');
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Subir Foto'),
                            ],
                          ),
                        ),
                ],
              )),
        ),
      ),
    );
  }
}
