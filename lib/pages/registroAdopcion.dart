import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class RegistroAdopcion extends StatefulWidget {
  @override
  _RegistroAdopcionState createState() => _RegistroAdopcionState();
}

class _RegistroAdopcionState extends State<RegistroAdopcion> {
  GeoPoint _currentLocation;
  var location = Location();
  double latitud;
  double longitud;

  Future<GeoPoint> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation =
            GeoPoint(userLocation.latitude, userLocation.longitude);
        latitud = _currentLocation.latitude;
        longitud = _currentLocation.longitude;
      });
    } catch (e) {
      print(e.toString());
    }
    return _currentLocation;
  }

  //File _image;
  final _adopcionkey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  String or = '';
  String tipoA = '';

  Map<String, dynamic> formAdopcion = {
    'convivenciaotros': null,
    'descripcion': null,
    'desparacitacion': null,
    'edad': null,
    'esterilizacion': null,
    'favoritos': [],
    'fecha': null,
    'sexo': null,
    'tipoAnimal': null,
    'titulo': null,
    'vacunacion': null,
    'userId': null,
    'fotos': <String>[],
    'albumrefs': <String>[],
    'lugar': null,
  };

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return WillPopScope(
      onWillPop: () async {
        controlador1.images.clear();
        return isLoadig ? false : true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              controlador1.images.clear();
              Navigator.of(context).pop();
            },
          ),
          title: Text('Registro Adopción'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _adopcionkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Ingresa los datos requeridos',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Los campos marcados con * son obligatorios.',
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Foto
                  Text(
                      '* Selecciona al menos una imagen de la mascota en adopción: '),
                  // GestureDetector(
                  //   onTap: () async {
                  //     _image = await controlador1.getImage(context);
                  //     setState(() {});
                  //   },
                  //   child: Center(
                  //     child: SizedBox(
                  //       width: 150,
                  //       height: 150,
                  //       child: Stack(
                  //         children: <Widget>[
                  //           Container(
                  //             width: 150.0,
                  //             height: 150.0,
                  //             child: CircleAvatar(
                  //               backgroundImage: _image == null
                  //                   ? AssetImage('assets/dog.png')
                  //                   : FileImage(_image),
                  //               backgroundColor: Colors.transparent,
                  //             ),
                  //           ),
                  //           CircleAvatar(
                  //             backgroundColor: secondaryColor,
                  //             child: IconButton(
                  //                 icon: Icon(Icons.photo_camera),
                  //                 onPressed: () async {
                  //                   _image =
                  //                       await controlador1.getImage(context);
                  //                   setState(() {});
                  //                 }),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // controlador1.images.isNotEmpty
                  //     ? Text('Fotos del álbum')
                  //     : Text(' ¿Deseas crear un álbum? (opcional)'),
                  SizedBox(
                    height: 15,
                  ),
                  //Botón fotos
                  controlador1.images.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(
                              parent: NeverScrollableScrollPhysics()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) => AssetThumb(
                            asset: controlador1.images[index],
                            width: 300,
                            height: 300,
                          ),
                          itemCount: controlador1.images.length,
                        )
                      : Center(
                          child: Text(
                          'No hay fotos para mostrar',
                          style: TextStyle(color: Colors.grey),
                        )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: RaisedButton(
                        onPressed: () async {
                          await controlador1.multiImage(context);
                          setState(() {});
                        },
                        child: Text('Añadir imágenes')),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Nombre
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      formAdopcion['titulo'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Nombre vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: '* Nombre de la mascota',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Descripcion
                  TextFormField(
                    maxLines: 10,
                    minLines: 2,
                    initialValue: null,
                    onSaved: (String value) {
                      formAdopcion['descripcion'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Descripción vacía';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: '* Descripción',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Tipo de animal
                  Text('* Selecciona el tipo de animal'),
                  FittedBox(
                    child: RadioButtonGroup(
                        picked: null,
                        orientation: GroupedButtonsOrientation.HORIZONTAL,
                        labels: <String>['perro', 'gato', 'ave', 'otro'],
                        onSelected: (String opcion) {
                          setState(() {
                            formAdopcion['tipoAnimal'] = opcion;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Sexo
                  Text('* Sexo '),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.VERTICAL,
                      labels: <String>[
                        'Macho',
                        'Hembra',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          formAdopcion['sexo'] = opcion;
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  //Convivencia con otros?
                  Text('* ¿La mascota convive con otros animales?'),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>[
                        'Si',
                        'No',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          if (opcion == 'Si') {
                            formAdopcion['convivenciaotros'] = true;
                          } else {
                            formAdopcion['convivenciaotros'] = false;
                          }
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  //Desparaacitado?
                  Text('* ¿La mascota se encuentra desparacitada?'),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>[
                        'Si',
                        'No',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          if (opcion == 'Si') {
                            formAdopcion['desparacitacion'] = true;
                          } else {
                            formAdopcion['desparacitacion'] = false;
                          }
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  //Vacunacion?
                  Text('* ¿La mascota se encuentra vacunada?'),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>[
                        'Si',
                        'No',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          if (opcion == 'Si') {
                            formAdopcion['vacunacion'] = true;
                          } else {
                            formAdopcion['vacunacion'] = false;
                          }
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  //Esterilizado?
                  Text('* ¿La mascota se encuentra esterilizada?'),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>[
                        'Si',
                        'No',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          if (opcion == 'Si') {
                            formAdopcion['esterilizacion'] = true;
                          } else {
                            formAdopcion['esterilizacion'] = false;
                          }
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  //Edad
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      formAdopcion['edad'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Edad vacía';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Edad (Ej. 1 año)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Ubicacion
                  // Center(
                  //   child: isLoadig2
                  //       ? CircularProgressIndicator()
                  //       : RaisedButton.icon(
                  //           icon: Icon(Icons.location_on),
                  //           label: Text('Capturar ubicación'),
                  //           onPressed: boton
                  //               ? () async {
                  //                   if (await controlador1
                  //                       .checkLocationPermisson()) {
                  //                     setState(() {
                  //                       isLoadig2 = true;
                  //                     });
                  //                     await controlador1.getLocation(context);
                  //                     controlador1.latitudfinal =
                  //                         controlador1.latitud;
                  //                     controlador1.longitudfinal =
                  //                         controlador1.longitud;
                  //                     await controlador1.getAddress(
                  //                         context, false);
                  //                     showDialog(
                  //                         barrierDismissible: false,
                  //                         context: context,
                  //                         child: WillPopScope(
                  //                           onWillPop: () async {
                  //                             setState(() {
                  //                               isLoadig2 = false;
                  //                             });
                  //                             return true;
                  //                           },
                  //                           child: AlertDialog(
                  //                             title: Text('Importante',
                  //                                 style: TextStyle(
                  //                                     color: Colors.red)),
                  //                             content: Text(
                  //                                 'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.',
                  //                                 style:
                  //                                     TextStyle(fontSize: 20)),
                  //                             actions: <Widget>[
                  //                               FlatButton(
                  //                                 child: Text('OK'),
                  //                                 onPressed: () {
                  //                                   Navigator.pop(context);
                  //                                   Navigator.push(
                  //                                     context,
                  //                                     MaterialPageRoute(
                  //                                         builder: (context) =>
                  //                                             MapSample(
                  //                                               latitud:
                  //                                                   controlador1
                  //                                                       .latitud,
                  //                                               longitud:
                  //                                                   controlador1
                  //                                                       .longitud,
                  //                                               controlador1:
                  //                                                   controlador1,
                  //                                             )),
                  //                                   );
                  //                                   setState(() {
                  //                                     isLoadig2 = false;
                  //                                     boton = false;
                  //                                   });
                  //                                 },
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ));
                  //                   } else {
                  //                     setState(() {
                  //                       isLoadig2 = false;
                  //                     });
                  //                     return controlador1
                  //                         .permissonDeniedDialog(context);
                  //                   }
                  //                 }
                  //               : null),
                  // ),
                  //Guardar
                  Center(
                    child: isLoadig
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            icon: Icon(Icons.check),
                            label: Text('Guardar'),
                            onPressed: () async {
                              setState(() {
                                formAdopcion['userName'] =
                                    controlador1.usuario.nombre;
                                formAdopcion['fecha'] = DateTime.now();
                                isLoadig = true;
                              });

                              if (!_adopcionkey.currentState.validate()) {
                                setState(() {
                                  isLoadig = false;
                                });
                                return;
                              }
                              // if (controlador1.images != null) {
                              //   for (var im in controlador1.images) {
                              //     var fotos = await saveImage(im, controlador1);
                              //     formAdopcion['fotos'].add(fotos['url']);
                              //     formAdopcion['albumrefs'].add(fotos['ref']);
                              //   }
                              //   print(formAdopcion['fotos'].toString());
                              // }
                              if (controlador1.images != null &&
                                  formAdopcion['tipoAnimal'] != null &&
                                  formAdopcion['sexo'] != null &&
                                  formAdopcion['convivenciaotros'] != null &&
                                  formAdopcion['desparacitacion'] != null &&
                                  formAdopcion['esterilizacion'] != null &&
                                  formAdopcion['vacunacion'] != null) {
                                for (var im in controlador1.images) {
                                  var fotos = await saveImage(im, controlador1);
                                  formAdopcion['fotos'].add(fotos['url']);
                                  formAdopcion['albumrefs'].add(fotos['ref']);
                                }
                                print(formAdopcion['fotos'].toString());

                                // final String fileName =
                                //     controlador1.usuario.correo +
                                //         '/adopcion/' +
                                //         DateTime.now().toString();

                                // StorageReference storageRef = FirebaseStorage
                                //     .instance
                                //     .ref()
                                //     .child(fileName);

                                // final StorageUploadTask uploadTask =
                                //     storageRef.putFile(
                                //   _image,
                                // );

                                // final StorageTaskSnapshot downloadUrl =
                                //     (await uploadTask.onComplete);
                                // final String fotoref = downloadUrl.ref.path;

                                // final String url =
                                //     (await downloadUrl.ref.getDownloadURL());
                                // print('URL Is $url');
                                setState(() {
                                  // formAdopcion['foto'] = url;
                                  // formAdopcion['reffoto'] = fotoref;
                                  formAdopcion['userId'] =
                                      controlador1.usuario.documentId;
                                  formAdopcion['status'] = 'en adopcion';
                                  formAdopcion['lugar'] = controlador1.usuario.municipio+', ' +controlador1.usuario.edo;
                                });
                              } else {
                                setState(() {
                                  isLoadig = false;
                                });
                                return showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Todos los campos son obligatorios. Por favor, completa la información que se solicita.'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Regresar'),
                                          onPressed: () {
                                            setState(() {
                                              isLoadig = false;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      title: Text('Olvidaste añadir algo'),
                                    ));
                              }

                              _adopcionkey.currentState.save();

                              var agregar = await Firestore.instance
                                  .collection('adopciones')
                                  .add(formAdopcion)
                                  .then((value) {
                                if (value != null) {
                                  return true;
                                } else {
                                  return false;
                                }
                              });
                              if (agregar) {
                                controlador1.latitudfinal = null;
                                controlador1.longitudfinal = null;
                                controlador1.images.clear();
                                Navigator.of(context).pushNamed('/home');
                              }
                            }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future saveImage(Asset asset, Controller controlador) async {
    Map<String, String> fotosRef = {'url': null, 'ref': null};

    ByteData byteData = await asset.getThumbByteData(500, 500, quality: 100);
    List<int> imageData = byteData.buffer.asUint8List();
    final String fileName =
        controlador.usuario.correo + '/adopcion/' + DateTime.now().toString();
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = ref.putData(imageData);

    fotosRef['url'] = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    fotosRef['ref'] = (await uploadTask.whenComplete(() => null)).ref.fullPath;
    return fotosRef;
  }
}
