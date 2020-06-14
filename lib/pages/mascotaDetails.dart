import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/colores.dart';

class MascotaDetails extends StatefulWidget {
  final MascotaModel mascota;

  const MascotaDetails({Key key, this.mascota}) : super(key: key);

  @override
  _MascotaDetailsState createState() => _MascotaDetailsState();
}

class _MascotaDetailsState extends State<MascotaDetails> {
  bool complete = false;
  bool loading = false;

  TextEditingController textEditingController = TextEditingController();
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    controlador1.mascota = widget.mascota;
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.trash,
                color: secondaryLight,
                size: 17,
              ),
              onPressed: () {
                return showDialog(
                    context: context,
                    child: loading
                        ? Expanded(
                            child: AlertDialog(
                              title: Text('Eliminando Mascota'),
                              content: LinearProgressIndicator(),
                            ),
                          )
                        : complete
                            ? Expanded(
                                child: AlertDialog(
                                  title: Text('¡Mascota eliminada!'),
                                  content: Icon(
                                    Icons.check_circle,
                                    color: secondaryDark,
                                    size: 40,
                                  ),
                                  actions: <Widget>[
                                    RaisedButton(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.pushReplacementNamed(
                                                context, '/perfil')
                                        // Navigator.of(context)
                                        //     .pushReplacementNamed('/home'),
                                        )
                                  ],
                                ),
                              )
                            : AlertDialog(
                                title: Text(
                                    '¡Estás a punto de eliminar una Mascota!'),
                                content: Text(
                                    '¿Estás seguro de eliminar está mascota?'),
                                actions: <Widget>[
                                  RaisedButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text('Si'),
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      // await controlador1.mascota.reference
                                      //     .delete()
                                      //     .catchError((onError) {
                                      //   print(onError);
                                      // });
                                      setState(() {
                                        loading = false;
                                        complete = true;
                                      });
                                      Navigator.of(context).popUntil(
                                          ModalRoute.withName('/perfil'));
                                      //  Navigator.pushNamedAndRemoveUntil(
                                      //           context, '/perfil',(Route<dynamic> route) => false);
                                      //Navigator.popAndPushNamed(context, routeName);
                                    },
                                  ),
                                ],
                              ));
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => showDialog(
              child: WillPopScope(
                onWillPop: () async {
                  return controlador1.loading ? false : true;
                },
                child: SimpleDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  children: <Widget>[
                    DialogContentM(
                      foto: 'PPM',
                    ),
                  ],
                ),
              ),
              context: context,
            ),
            child: Container(
              width: 120,
              height: 120,
              child: Stack(
                children: <Widget>[
                  Container(
                    foregroundDecoration: BoxDecoration(
                        border: Border.all(color: secondaryDark, width: 0.3),
                        borderRadius: BorderRadius.circular(180)),
                    margin: EdgeInsets.all(1),
                    padding: EdgeInsets.all(1),
                    //padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: secondaryLight,
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(180)),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(controlador1.mascota.foto),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(5),
                    //padding: EdgeInsets.only(top:15),
                    //padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(180)),
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                      size: 15,
                    ),

                    padding: EdgeInsets.only(bottom: 3),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Text(controlador1.mascota.nombre),
          Container(
            padding: EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('Edad: '),
                    controlador1.mascota.anios == 0
                        ? controlador1.mascota.meses == 1
                            ? Text(
                                '${controlador1.mascota.meses.toString()} mes')
                            : Text(
                                '${controlador1.mascota.meses.toString()} meses')
                        : controlador1.mascota.anios == 1
                            ? Text(
                                '${controlador1.mascota.anios.toString()} año')
                            : Text(
                                '${controlador1.mascota.anios.toString()} años'),
                  ],
                )),
                Container(
                  color: Colors.brown[100],
                  width: 2,
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('Sexo:'),
                      Text(controlador1.mascota.sexo)
                    ],
                  ),
                ),
                Container(
                  color: Colors.brown[100],
                  width: 2,
                  height: 30,
                ),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Text('Tamaño:'),
                    Text(controlador1.mascota.tamano),
                  ],
                )),
                Container(
                  color: Colors.brown[100],
                  width: 2,
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('Tipo:'),
                      Icon(
                        controlador1.mascota.tipoAnimal == 'perro'
                            ? FontAwesomeIcons.dog
                            : controlador1.mascota.tipoAnimal == 'gato'
                                ? FontAwesomeIcons.cat
                                : controlador1.mascota.tipoAnimal == 'ave'
                                    ? FontAwesomeIcons.dove
                                    : FontAwesomeIcons.fish,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text('Personalidad: '),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
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
                            maxLength: 100,
                            maxLines: 4,
                            minLines: 1,
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
                              await controlador1.mascota.reference.updateData(
                                  {'personalidad': textEditingController.text});
                              controlador1.mascota.personalidad =
                                  textEditingController.text;
                              controlador1.loading = false;
                              textEditingController.clear();
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
                icon: Icon(
                  FontAwesomeIcons.edit,
                  size: 15,
                  color: secondaryLight,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Text(
                    widget.mascota.personalidad,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DialogContentM extends StatefulWidget {
  final String foto;
  final int index;
  DialogContentM({this.foto, this.index});
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContentM> {
  var imagen;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            thickness: 1,
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                width: 350,
                height: 350,
                fit: BoxFit.cover,
                image: imagen == null
                    ? NetworkImage(controlador1.mascota.foto)
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                         backgroundColor: primaryColor,
                         onPressed: () async {
                           imagen = await controlador1.getImage(context);
                           setState(() {
                             imagen = imagen;
                           });
                         },
                         label: Text(
                           'Galeria',
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

                                imagen =
                                    await controlador1.getImageCamera(context);
                                setState(() {
                                  imagen = imagen;
                                });
                              },
                              label: Text(
                                'Cámara',
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
                                        '/mascotas/${widget.foto}' +
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

                                if ((controlador1.mascota.storageRef) !=
                                        null &&
                                    widget.foto != 'INE') {
                                  await FirebaseStorage.instance
                                      .ref()
                                      .child(
                                          (controlador1.mascota.storageRef))
                                      .delete()
                                      .catchError((onError) {
                                    print(onError);
                                  });
                                }

                                final String url =
                                    (await downloadUrl.ref.getDownloadURL());
                                if (widget.foto == 'PPM') {
                                  await controlador1.mascota.reference
                                      .updateData({
                                    'foto': url,
                                    'fotoStorageRef': downloadUrl.ref.path
                                  });

                                  controlador1.mascota.foto = url;
                                  controlador1.mascota.storageRef =
                                      downloadUrl.ref.path;
                                }

                                // else if (widget.foto == 'INE') {
                                //   await controlador1.usuario.reference
                                //       .updateData({
                                //     'fotoINE': url,
                                //     'fotoINERef': downloadUrl.ref.path
                                //   });

                                //   controlador1.usuario.fotoINE = url;
                                //   controlador1.usuario.fotoINERef =
                                //       downloadUrl.ref.path;
                                // } else {
                                //   await controlador1.usuario.reference
                                //       .updateData({
                                //     'fotoCompDomi': url,
                                //     'fotoCompDomiRef': downloadUrl.ref.path
                                //   });

                                //   controlador1.usuario.fotoCompDomi = url;
                                //   controlador1.usuario.fotoCompDomiRef =
                                //       downloadUrl.ref.path;
                                // }

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
                    // print(controlador1.usuario.galeriaFotosRefs.length);
                    // controlador1.loading = true;
                    // controlador1.notify();
                    // await FirebaseStorage.instance
                    //     .ref()
                    //     .child(
                    //         controlador1.usuario.galeriaFotosRefs[widget.index])
                    //     .delete()
                    //     .catchError((onError) {
                    //   print(onError);
                    // });

                    // await controlador1.usuario.reference.updateData({
                    //   'galeriaFotos': FieldValue.arrayRemove(
                    //       [controlador1.usuario.galeriaFotos[widget.index]]),
                    //   'galeriaFotosRefs': FieldValue.arrayRemove(
                    //       [controlador1.usuario.galeriaFotosRefs[widget.index]])
                    // });
                    // List<dynamic> urls =
                    //     controlador1.usuario.galeriaFotos.toList();
                    // List<dynamic> refs =
                    //     controlador1.usuario.galeriaFotosRefs.toList();
                    // urls.removeAt(widget.index);
                    // refs.removeAt(widget.index);

                    // controlador1.usuario.galeriaFotos = urls;
                    // controlador1.usuario.galeriaFotosRefs = refs;
                    // controlador1.loading = false;
                    // controlador1.notify();

                    // Navigator.of(context).pop(true);
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
      ),
    );
  }
}
