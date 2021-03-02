import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/pages/postView.dart';

import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/colores.dart';
import 'package:gudpets/shared/postCard.dart';

class MascotaDetails extends StatefulWidget {
  final UsuarioModel usuario;
  final MascotaModel mascota;

  const MascotaDetails({Key key, this.mascota, this.usuario}) : super(key: key);

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
    List<String> amigos = controlador1.usuario.amigos;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(controlador1.mascota.nombre),
        actions: <Widget>[
          controlador1.usuario.documentId == widget.usuario.documentId
              ? IconButton(
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
                                          await controlador1.mascota.reference
                                              .delete()
                                              .catchError((onError) {
                                            print(onError);
                                          });
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
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  controlador1.usuario.documentId == widget.usuario.documentId
                      ? showDialog(
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
                        )
                      : null,
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
                        backgroundImage:
                            NetworkImage(controlador1.mascota.foto),
                      ),
                    ),
                    controlador1.usuario.documentId == widget.usuario.documentId
                        ? Container(
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
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  controlador1.mascota.nombre,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  controlador1.mascota.tipoAnimal == 'perro'
                      ? FontAwesomeIcons.dog
                      : controlador1.mascota.tipoAnimal == 'gato'
                          ? FontAwesomeIcons.cat
                          : controlador1.mascota.tipoAnimal == 'ave'
                              ? FontAwesomeIcons.dove
                              : FontAwesomeIcons.fish,
                  size: 15,
                ),
              ],
            ),
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
                      Text(
                        'Edad',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
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
                        Text(controlador1.mascota.sexo),
                        Text(
                          'Sexo',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
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
                      Text(controlador1.mascota.tamano),
                      Text(
                        'Tamaño',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  )),
                  // Container(
                  //   color: Colors.brown[100],
                  //   width: 2,
                  //   height: 30,
                  // ),
                  // Expanded(
                  //   child: Column(
                  //     children: <Widget>[

                  //       SizedBox(height: 3,),
                  //       //Text('Tipo',style: TextStyle(color: Colors.grey,fontSize: 10),),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            // controlador1.usuario.documentId == widget.usuario.documentId
            //     ? Row(
            //         mainAxisSize: MainAxisSize.max,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: <Widget>[
            //           // Padding(
            //           //   padding: const EdgeInsets.only(left: 15),
            //           //   child: Text('Personalidad: '),
            //           // ),
            //           Container(
            //               padding: EdgeInsets.all(15),
            //               child: Text('Buscar Amigos: ',
            //                   style: TextStyle(
            //                       color: Colors.black54, fontSize: 13))),
            //           controlador1.loading
            //               ? CircularProgressIndicator()
            //               : Switch(
            //                   value: controlador1.mascota.buscaAmigos,
            //                   onChanged: (bool valor) {
            //                     setState(() async {
            //                       controlador1.loading = true;
            //                       controlador1.notify();
            //                       await controlador1.mascota.reference
            //                           .updateData({'buscaAmigos': valor});
            //                       controlador1.mascota.buscaAmigos = valor;
            //                       controlador1.loading = false;
            //                       textEditingController.clear();
            //                       controlador1.notify();
            //                     });
            //                   },
            //                   activeColor: Colors.blueAccent,
            //                 )
            //         ],
            //       )
            //     : Padding(padding: EdgeInsets.all(15)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                            top: 25, left: 40.0, right: 50, bottom: 10),
                        child: Text(
                          widget.mascota.personalidad,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      controlador1.usuario.documentId ==
                              widget.usuario.documentId
                          ? Container(
                              padding: EdgeInsets.only(bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                padding: EdgeInsets.only(top: 20),
                                onPressed: () => showDialog(
                                  context: context,
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            maxLength: 100,
                                            maxLines: 4,
                                            minLines: 1,
                                            decoration: InputDecoration(
                                                labelText: 'Descripción'),
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
                                              await controlador1
                                                  .mascota.reference
                                                  .update({
                                                'personalidad':
                                                    textEditingController.text
                                              });
                                              controlador1
                                                      .mascota.personalidad =
                                                  textEditingController.text;
                                              controlador1.loading = false;
                                              textEditingController.clear();
                                              controlador1.notify();
                                              Navigator.of(context).pop();
                                            },
                                            label: Text(
                                              'Actualizar',
                                              style: TextStyle(
                                                  color: secondaryLight),
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
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Fotos',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              thickness: 1,
              color: primaryDark,
            ),
            StreamBuilder(
              stream: amigos.contains(widget.usuario.documentId)
                  ? widget.usuario.reference
                      .collection('posts')
                      .where('mascotas',
                          arrayContains: controlador1.mascota.documentId)
                      .orderBy('fecha', descending: true)
                      .snapshots()
                  : controlador1.usuario.documentId == widget.usuario.documentId
                      ? widget.usuario.reference
                          .collection('posts')
                          .where('mascotas',
                              arrayContains: controlador1.mascota.documentId)
                          .orderBy('fecha', descending: true)
                          .snapshots()
                      : widget.usuario.reference
                          .collection('posts')
                          .where('mascotas',
                              arrayContains: controlador1.mascota.documentId)
                          .where('privacidad', isEqualTo: true)
                          .orderBy('fecha', descending: true)
                          .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Container(
                        height: 50, child: const CircularProgressIndicator()),
                  );
                List<DocumentSnapshot> documents = snapshot.data.documents;
                bool amigo = amigos.contains(widget.usuario.documentId);
                if (amigo) {
                  print('amix');
                } else {
                  print('enemix');
                }
                print(documents);
                print(documents.length);
                return documents.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('No hay fotos para mostrar'),
                      )
                    : GridView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, crossAxisSpacing: 2),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          PostsModel post =
                              PostsModel.fromDocumentSnapshot(documents[index]);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PostView(
                                    post: post,
                                    controlador1: controlador1,
                                  ),
                                ),
                              );
                            },
                            // onTap: () {
                            //   showDialog(
                            //     useSafeArea: true,
                            //     //barrierDismissible: false,
                            //     barrierColor: Colors.black54,
                            //     context: context,
                            //     builder: (_) => WillPopScope(
                            //         onWillPop: () async {
                            //           controlador1.pestanaAct = 0;
                            //           //controlador1.notify();
                            //           return true;
                            //         },
                            //         child: AlertDialog(
                            //           backgroundColor: Colors.transparent,
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(10.0))),
                            //           contentPadding: EdgeInsets.all(0.0),
                            //           insetPadding: EdgeInsets.all(5),
                            //           content: Builder(
                            //             builder: (context) {
                            //               // Get available height and width of the build area of this widget. Make a choice depending on the size.
                            //               var height = MediaQuery.of(context)
                            //                   .size
                            //                   .height;
                            //               var width =
                            //                   MediaQuery.of(context).size.width;
                            //               print(width);

                            //               return Container(
                            //                 color: Colors.transparent,
                            //                 //height: ,
                            //                 width: width,
                            //                 child: SingleChildScrollView(
                            //                   child: Fotos(
                            //                     controlador1: controlador1,
                            //                     index: 2,
                            //                     post: post,
                            //                   ),
                            //                 ),
                            //               );
                            //             },
                            //           ),
                            //         )),

                            //     //     (BuildContext context) {
                            //     //   var height =
                            //     //       MediaQuery.of(context).size.height;
                            //     //   var width = MediaQuery.of(context).size.width;
                            //     //   print(width);

                            //     //   return WillPopScope(
                            //     //       onWillPop: () async {
                            //     //         controlador1.pestanaAct = 0;
                            //     //         controlador1.notify();
                            //     //         return true;
                            //     //       },
                            //     //       child: Container(
                            //     //         width:
                            //     //             MediaQuery.of(context).size.width,
                            //     //         child: Fotos(
                            //     //           index: 2,
                            //     //           controlador1: controlador1,
                            //     //           post: post,
                            //     //         ),
                            //     //       ));
                            //     // },
                            //   );
                            // },
                            child: FadeInImage(
                              placeholder: AssetImage('assets/dog.png'),
                              image: NetworkImage(post.foto),
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TarjetaDialog extends StatefulWidget {
  PostsModel post;
  TarjetaDialog({this.post});

  @override
  _TarjetaDialogState createState() => _TarjetaDialogState();
}

class _TarjetaDialogState extends State<TarjetaDialog> {
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return Fotos(
      controlador1: controlador1,
      post: widget.post,
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
                                Reference storageRef = FirebaseStorage.instance
                                    .ref()
                                    .child(fileName);

                                final UploadTask uploadTask =
                                    storageRef.putFile(
                                  imagen,
                                );

                                final TaskSnapshot downloadUrl =
                                    (await uploadTask.whenComplete(() => null));

                                if ((controlador1.mascota.storageRef) != null &&
                                    widget.foto != 'INE') {
                                  await FirebaseStorage.instance
                                      .ref()
                                      .child((controlador1.mascota.storageRef))
                                      .delete()
                                      .catchError((onError) {
                                    print(onError);
                                  });
                                }

                                final String url =
                                    (await downloadUrl.ref.getDownloadURL());

                                if (widget.foto == 'PPM') {
                                  await controlador1.mascota.reference.update({
                                    'foto': url,
                                    'fotoStorageRef': downloadUrl.ref.fullPath
                                  });

                                  controlador1.mascota.foto = url;
                                  controlador1.mascota.storageRef =
                                      downloadUrl.ref.fullPath;
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
