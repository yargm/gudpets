import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  TextEditingController textEditingController = TextEditingController();

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
                              placeholder: AssetImage('assets/dog.png'),
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
                                  return controlador1.loading ? false : true;
                                },
                                child: SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  children: <Widget>[
                                    DialogContent(
                                      foto: 'PP',
                                    ),
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
                    subtitle: Text(controlador1.usuario.descripcion),
                    title: Text('Descripción'),
                    trailing: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Descripción'),
                                  controller: textEditingController,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                FloatingActionButton.extended(
                                  backgroundColor: primaryColor,
                                  onPressed: () async {
                                    controlador1.loading = true;
                                    controlador1.notify();
                                    await controlador1.usuario.reference
                                        .updateData({
                                      'descripción': textEditingController.text
                                    });
                                    controlador1.usuario.descripcion =
                                        textEditingController.text;
                                    controlador1.loading = false;
                                    controlador1.notify();
                                    Navigator.of(context).pop();
                                  },
                                  label: Text(
                                    'Actualizar',
                                    style: TextStyle(color: secondaryLight),
                                  ),
                                  icon: Icon(
                                    Icons.system_update_alt,
                                    color: secondaryLight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.calendar),
                    subtitle: Text(controlador1.usuario.edad.toString()),
                    title: Text('Edad'),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.genderless),
                    subtitle: Text(controlador1.usuario.sexo ?? '???'),
                    title: Text('Sexo'),
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.phoneAlt),
                    subtitle: Text(controlador1.usuario.telefono.toString()),
                    title: Text('Telefono'),
                    trailing: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        child: WillPopScope(
                          onWillPop: () async {
                            return controlador1.loading ? false : true;
                          },
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: DialogChangePhone(),
                          ),
                        ),
                      ),
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
                                image: NetworkImage(
                                    controlador1.usuario.fotoINE ?? ''),
                                placeholder:
                                    AssetImage('assets/dog.png'),
                              ),
                              CircleAvatar(
                                backgroundColor: secondaryColor,
                                child: IconButton(
                                  icon: Icon(Icons.photo_camera),
                                  onPressed: () => showDialog(
                                    child: WillPopScope(
                                      onWillPop: () async {
                                        return controlador1.loading
                                            ? false
                                            : true;
                                      },
                                      child: SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        children: <Widget>[
                                          DialogContent(
                                            foto: 'INE',
                                          ),
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
                            child: Text(
                          controlador1.usuario.fotoINE == null
                              ? '* No cuentas con foto de tu INE y es necesaria para realizar un trámite de adopción'
                              : 'Foto INE',
                          style: TextStyle(
                              fontWeight: controlador1.usuario.fotoINE == null
                                  ? FontWeight.bold
                                  : null),
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
                                image: NetworkImage(
                                    controlador1.usuario.fotoCompDomi ?? ''),
                                placeholder:
                                    AssetImage('assets/dog.png'),
                              ),
                              CircleAvatar(
                                backgroundColor: secondaryColor,
                                child: IconButton(
                                  icon: Icon(Icons.photo_camera),
                                  onPressed: () => showDialog(
                                    child: WillPopScope(
                                      onWillPop: () async {
                                        return controlador1.loading
                                            ? false
                                            : true;
                                      },
                                      child: SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        children: <Widget>[
                                          DialogContent(
                                            foto: 'CompDomi',
                                          ),
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
                            child: Text(
                          controlador1.usuario.fotoCompDomi == null
                              ? '* No cuentas con foto de tu comprobante de domicilio y es necesaria para realizar un trámite de adopción'
                              : 'Foto Comprobante de domicilio',
                          style: TextStyle(
                              fontWeight: controlador1.usuario.fotoCompDomi== null
                                  ? FontWeight.bold
                                  : null),
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
                          'Estas imágenes son necesarias para realizar un trámite de adopción, en ellas se debe mostrar el lugar en donde vivirán las mascotas que desees adoptar. Esta información se usa para comprobar que la mascota tendrá un hogar adecuado',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        controlador1.usuario.galeriaFotos.isNotEmpty &&
                                controlador1.usuario.galeriaFotos != null
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(
                                    parent: NeverScrollableScrollPhysics()),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => showDialog(
                                      context: context,
                                      child: WillPopScope(
                                        onWillPop: () async {
                                          return controlador1.loading
                                              ? false
                                              : true;
                                        },
                                        child: Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: DialogContent(
                                            index: index,
                                          ),
                                        ),
                                      )),
                                  child: Image(
                                    image: NetworkImage(
                                      controlador1.usuario.galeriaFotos[index],
                                    ),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                itemCount:
                                    controlador1.usuario.galeriaFotos.length,
                              )
                            : Text('No hay fotos para mostrar'),
                        SizedBox(
                          height: 30,
                        ),
                        controlador1.usuario.galeriaFotos.length < 6
                            ? FloatingActionButton.extended(
                                elevation: 0,
                                backgroundColor: primaryColor,
                                onPressed: () => showDialog(
                                    context: context,
                                    child: WillPopScope(
                                      onWillPop: () async {
                                        return controlador1.loading
                                            ? false
                                            : true;
                                      },
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: DialogMultiImage(),
                                      ),
                                    )),
                                label: Text(
                                  'Añadir fotos',
                                  style: TextStyle(color: secondaryLight),
                                ),
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: secondaryLight,
                                ),
                              )
                            : Container()
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

class DialogMultiImage extends StatefulWidget {
  @override
  _DialogMultiImageState createState() => _DialogMultiImageState();
}

class _DialogMultiImageState extends State<DialogMultiImage> {
  List<Asset> images = List<Asset>();
  List<String> galeriaFotos = <String>[];
  List<String> galeriaFotosRefs = <String>[];

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    Future<void> loadAssets() async {
      List<Asset> resultList = List<Asset>();
      String error = 'No Error Dectected';

      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 6 - (controlador1.usuario.galeriaFotos.length ?? 0),
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#FF795548",
            actionBarTitle: "Adopción App",
            allViewTitle: "Todas las fotos",
            useDetailsView: true,
            selectCircleStrokeColor: "#FFFFFF",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        images = resultList;
      });
    }

    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          images.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  physics:
                      ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) => AssetThumb(
                    asset: images[index],
                    width: 300,
                    height: 300,
                  ),
                  itemCount: images.length,
                )
              : Text('No hay fotos para mostrar'),
          SizedBox(
            height: 30,
          ),
          controlador1.loading
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    FloatingActionButton.extended(
                      elevation: 0,
                      backgroundColor: primaryColor,
                      onPressed: () => loadAssets(),
                      label: Text(
                        'Añadir fotos',
                        style: TextStyle(color: secondaryLight),
                      ),
                      icon: Icon(
                        Icons.add_a_photo,
                        color: secondaryLight,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                      elevation: 0,
                      backgroundColor: secondaryLight,
                      onPressed: () async {
                        controlador1.loading = true;
                        controlador1.notify();
                        for (var image in images) {
                          Map<String, String> fotosRef =
                              await saveImage(image, controlador1);
                          galeriaFotos.add(fotosRef['url']);
                          galeriaFotosRefs.add(fotosRef['ref']);
                        }
                        await controlador1.usuario.reference.updateData({
                          'galeriaFotos': FieldValue.arrayUnion(galeriaFotos),
                          'galeriaFotosRefs':
                              FieldValue.arrayUnion(galeriaFotosRefs)
                        });
                        List<dynamic> urls =
                            controlador1.usuario.galeriaFotos.toList();
                        List<dynamic> refs =
                            controlador1.usuario.galeriaFotosRefs.toList();
                        for (var foto in galeriaFotos) {
                          urls.add(foto);
                        }
                        for (var fotoRef in galeriaFotosRefs) {
                          refs.add(fotoRef);
                        }
                        controlador1.usuario.galeriaFotos = urls;
                        controlador1.usuario.galeriaFotosRefs = refs;

                        controlador1.loading = false;
                        controlador1.notify();
                        Navigator.of(context).pop();
                      },
                      label: Text(
                        'Subir fotos',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.cloud_upload,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  Future saveImage(Asset asset, Controller controlador1) async {
    Map<String, String> fotosRef = {'url': null, 'ref': null};
    ByteData byteData = await asset.getThumbByteData(500, 500, quality: 100);
    List<int> imageData = byteData.buffer.asUint8List();
    final String fileName = controlador1.usuario.correo +
        '/perfil/galeria/foto' +
        DateTime.now().toString();
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putData(imageData);

    fotosRef['url'] = await (await uploadTask.onComplete).ref.getDownloadURL();
    fotosRef['ref'] = (await uploadTask.onComplete).ref.path;
    return fotosRef;
  }
}

class DialogContent extends StatefulWidget {
  final String foto;
  final int index;
  DialogContent({this.foto, this.index});
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FadeInImage(
              width: 350,
              height: 350,
              fit: widget.foto == 'PP' || widget.index != null
                  ? BoxFit.cover
                  : null,
              image: imagen == null
                  ? NetworkImage(widget.foto == 'PP'
                      ? controlador1.usuario.foto
                      : widget.foto == 'INE'
                          ? (controlador1.usuario.fotoINE ?? '')
                          : widget.index != null
                              ? controlador1.usuario.galeriaFotos[widget.index]
                              : (controlador1.usuario.fotoCompDomi ?? ''))
                  : FileImage(imagen),
              placeholder: AssetImage('assets/dog.png'),
            ),
          ),
        ),
        widget.index != null
            ? Container()
            : controlador1.loading
                ? CircularProgressIndicator()
                : Column(
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            backgroundColor: primaryColor,
                            onPressed: () async {
                              imagen = await getImage();
                              setState(() {
                                imagen = imagen;
                              });
                            },
                            label: Text(
                              'Foto Galeria',
                              style: TextStyle(color: secondaryLight),
                            ),
                            icon: Icon(
                              Icons.photo_library,
                              color: secondaryLight,
                            ),
                          )
                        ],
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            backgroundColor: primaryColor,
                            onPressed: () async {
                              imagen = await getImageCamera();
                              setState(() {
                                imagen = imagen;
                              });
                            },
                            label: Text(
                              'Foto Camara',
                              style: TextStyle(color: secondaryLight),
                            ),
                            icon: Icon(
                              Icons.photo_camera,
                              color: secondaryLight,
                            ),
                          )
                        ],
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            backgroundColor: primaryColor,
                            onPressed: () async {
                              controlador1.loading = true;
                              controlador1.notify();

                              final String fileName =
                                  controlador1.usuario.correo +
                                      '/perfil/${widget.foto}' +
                                      DateTime.now().toString();
                              StorageReference storageRef = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(fileName);

                              final StorageUploadTask uploadTask =
                                  storageRef.putFile(
                                imagen,
                              );

                              final StorageTaskSnapshot downloadUrl =
                                  (await uploadTask.onComplete);

                              if ((widget.foto == 'PP'
                                      ? controlador1.usuario.fotoStorageRef
                                      : widget.foto == 'INE'
                                          ? controlador1.usuario.fotoINERef
                                          : controlador1
                                              .usuario.fotoCompDomiRef) !=
                                  null) {
                                await FirebaseStorage.instance
                                    .ref()
                                    .child((widget.foto == 'PP'
                                        ? controlador1.usuario.fotoStorageRef
                                        : widget.foto == 'INE'
                                            ? controlador1.usuario.fotoINERef
                                            : controlador1
                                                .usuario.fotoCompDomiRef))
                                    .delete()
                                    .catchError((onError) {
                                  print(onError);
                                });
                              }

                              final String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              if (widget.foto == 'PP') {
                                await controlador1.usuario.reference
                                    .updateData({
                                  'foto': url,
                                  'fotoStorageRef': downloadUrl.ref.path
                                });

                                controlador1.usuario.foto = url;
                                controlador1.usuario.fotoStorageRef =
                                    downloadUrl.ref.path;
                              } else if (widget.foto == 'INE') {
                                await controlador1.usuario.reference
                                    .updateData({
                                  'fotoINE': url,
                                  'fotoINERef': downloadUrl.ref.path
                                });

                                controlador1.usuario.fotoINE = url;
                                controlador1.usuario.fotoINERef =
                                    downloadUrl.ref.path;
                              } else {
                                await controlador1.usuario.reference
                                    .updateData({
                                  'fotoCompDomi': url,
                                  'fotoCompDomiRef': downloadUrl.ref.path
                                });

                                controlador1.usuario.fotoCompDomi = url;
                                controlador1.usuario.fotoCompDomiRef =
                                    downloadUrl.ref.path;
                              }

                              controlador1.loading = false;
                              controlador1.notify();

                              Navigator.of(context).pop();
                            },
                            label: Text(
                              'Guardar',
                              style: TextStyle(color: secondaryLight),
                            ),
                            icon: Icon(
                              Icons.save,
                              color: secondaryLight,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
        widget.index != null && !controlador1.loading
            ? FloatingActionButton.extended(
                backgroundColor: primaryColor,
                onPressed: () async {
                  print(controlador1.usuario.galeriaFotosRefs.length);
                  controlador1.loading = true;
                  controlador1.notify();
                  await FirebaseStorage.instance
                      .ref()
                      .child(
                          controlador1.usuario.galeriaFotosRefs[widget.index])
                      .delete()
                      .catchError((onError) {
                    print(onError);
                  });

                  await controlador1.usuario.reference.updateData({
                    'galeriaFotos': FieldValue.arrayRemove(
                        [controlador1.usuario.galeriaFotos[widget.index]]),
                    'galeriaFotosRefs': FieldValue.arrayRemove(
                        [controlador1.usuario.galeriaFotosRefs[widget.index]])
                  });
                    List<dynamic> urls =
                            controlador1.usuario.galeriaFotos.toList();
                        List<dynamic> refs =
                            controlador1.usuario.galeriaFotosRefs.toList();
                  urls.removeAt(widget.index);
                  refs.removeAt(widget.index);

                  controlador1.usuario.galeriaFotos = urls;
                  controlador1.usuario.galeriaFotosRefs = refs;
                  controlador1.loading = false;
                  setState(() {
                    
                  });
                  controlador1.notify();
                  Navigator.of(context).pop();
                },
                label: Text(
                  'Eliminar foto',
                  style: TextStyle(color: secondaryLight),
                ),
                icon: Icon(
                  Icons.delete_forever,
                  color: secondaryLight,
                ),
              )
            : controlador1.loading && widget.index != null
                ? CircularProgressIndicator()
                : Container(),
        SizedBox(
          height: 15,
        )
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

class DialogChangePhone extends StatefulWidget {
  @override
  _DialogChangePhoneState createState() => _DialogChangePhoneState();
}

class _DialogChangePhoneState extends State<DialogChangePhone> {
  TextEditingController textEditingControllerTel = TextEditingController();

  String error;

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Telefono'),
            controller: textEditingControllerTel,
          ),
          SizedBox(
            height: 15,
          ),
          error == null || error == ''
              ? Container()
              : Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
          !controlador1.loading
              ? FloatingActionButton.extended(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    controlador1.loading = true;
                    controlador1.notify();
                    if (textEditingControllerTel.text.length < 10 ||
                        textEditingControllerTel.text.length > 10) {
                      setState(() {
                        error = 'Numero incorrecto';
                      });
                      return;
                    }
                    await controlador1.usuario.reference.updateData(
                        {'telefono': int.parse(textEditingControllerTel.text)});
                    setState(() {
                      error = '';
                    });
                    controlador1.usuario.telefono =
                        int.parse(textEditingControllerTel.text);
                    controlador1.loading = false;
                    controlador1.notify();
                    textEditingControllerTel.clear();
                    Navigator.of(context).pop();
                  },
                  label: Text(
                    'Actualizar',
                    style: TextStyle(color: secondaryLight),
                  ),
                  icon: Icon(
                    Icons.system_update_alt,
                    color: secondaryLight,
                  ),
                )
              : CircularProgressIndicator()
        ],
      ),
    );
  }
}
