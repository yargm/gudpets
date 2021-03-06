import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart' as locations;
import 'package:permission/permission.dart' as permisos;
import 'mapaejemplo.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistroRescate extends StatefulWidget {
  @override
  _RegistroRescateState createState() => _RegistroRescateState();
}

class _RegistroRescateState extends State<RegistroRescate> {
  void initState() {
    super.initState();

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_actualizaestado);
  }

  PermissionStatus permisoStatus;

  void _actualizaestado(PermissionStatus status) {
    if (status != permisoStatus) {
      setState(() {
        permisoStatus = status;
      });
      print('permiso inicial:' + permisoStatus.toString());
    }
  }

  GeoPoint _currentLocation;
  var location = locations.Location();
  double latitud;
  double longitud;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

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
      print(_error);
    }
    return _currentLocation;
  }

  bool capturaubicacion = false;

  File _image;
  final _rescatekey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  String or = '';
  String tipoA = '';
  Map<String, dynamic> formRescate = {
    'titulo': null,
    'ubicacion': <GeoPoint>[],
    'telefono': null,
    'foto': null,
    'descripcion': null,
    'tipoAnimal': null,
    'fecha': null,
    'fotos': <String>[],
    'favoritos': <String>[],
    'reffoto': null,
    'albumrefs': <String>[],
    'userId': null,
    'userName': null
  };
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    Future<void> loadAssets() async {
      List<Asset> resultList = List<Asset>();
      String error = 'No Error Dectected';
      var permisson = await controlador1.checkGalerryPermisson(false);
      if (permisson) {
        try {
          resultList = await MultiImagePicker.pickImages(
            maxImages: 3,
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
          print(error);
        }

        // If the widget was removed from the tree while the asynchronous platform
        // message was in flight, we want to discard the reply rather than calling
        // setState to update our non-existent appearance.
        if (!mounted) return;

        setState(() {
          images = resultList;
        });
      } else {
        return controlador1.permissonDeniedDialog(context);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return isLoadig ? false : true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registro Rescate'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _rescatekey,
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
                  Text('* Selecciona una imagen de la mascota rescatada: '),
                  GestureDetector(
                    onTap: () async {
                      _image = await controlador1.getImage(context);
                      setState(() {});
                    },
                    child: Center(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 150.0,
                              height: 150.0,
                              child: CircleAvatar(
                                backgroundImage: _image == null
                                    ? AssetImage('assets/dog.png')
                                    : FileImage(_image),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: secondaryColor,
                              child: IconButton(
                                  icon: Icon(Icons.photo_camera),
                                  onPressed: () async {
                                    _image =
                                        await controlador1.getImage(context);
                                    setState(() {});
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Botón fotos
                  images.isNotEmpty
                      ? Text('Fotos del álbum')
                      : Text(' ¿Deseas crear un álbum? (opcional)'),
                  SizedBox(
                    height: 15,
                  ),
                  images.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(
                              parent: NeverScrollableScrollPhysics()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) => AssetThumb(
                            asset: images[index],
                            width: 300,
                            height: 300,
                          ),
                          itemCount: images.length,
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
                        onPressed: loadAssets, child: Text('Añadir imágenes')),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      formRescate['titulo'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Título vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: '* Título del rescate',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    maxLines: 10,
                    minLines: 2,
                    initialValue: null,
                    onSaved: (String value) {
                      formRescate['descripcion'] = value;
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
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('* Selecciona el tipo de animal'),
                  FittedBox(
                    child: RadioButtonGroup(
                        picked: null,
                        orientation: GroupedButtonsOrientation.HORIZONTAL,
                        labels: <String>['perro', 'gato', 'ave', 'otro'],
                        onSelected: (String opcion) {
                          setState(() {
                            formRescate['tipoAnimal'] = opcion;
                          });
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('¿En qué lugar resguardas la mascota?'),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.VERTICAL,
                      labels: <String>[
                        'En tu hogar',
                        'Veterinaria u otros',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          tipotemp = opcion;
                        });
                      }),
                  tipotemp == 'En tu hogar'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                '¿Quieres que las personas puedan ver la ubicación de tu hogar?'),
                            RadioButtonGroup(
                                picked: null,
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                labels: <String>[
                                  'Si',
                                  'No',
                                ],
                                onSelected: (String opcion) {
                                  setState(() {
                                    or = opcion;
                                  });
                                }),
                            or == 'Si'
                                ? //Ubicacion
                                Center(
                                    child: isLoadig2
                                        ? CircularProgressIndicator()
                                        : RaisedButton.icon(
                                            icon: Icon(Icons.location_on),
                                            label: Text('Capturar ubicación'),
                                            onPressed: boton
                                                ? () async {
                                                    print(
                                                        'permiso al entrar al botón:' +
                                                            permisoStatus
                                                                .toString());
                                                    setState(() {
                                                      isLoadig2 = true;
                                                    });
                                                    await getLocation();
                                                    print(
                                                        'permiso despues cuadro dialogo:' +
                                                            permisoStatus
                                                                .toString());
                                                    await PermissionHandler()
                                                        .checkPermissionStatus(
                                                            PermissionGroup
                                                                .locationWhenInUse)
                                                        .then(_actualizaestado);
                                                    print('permiso final: ' +
                                                        permisoStatus
                                                            .toString());
                                                    if (permisoStatus.toString() == 'PermissionStatus.denied' ||
                                                        permisoStatus
                                                                .toString() ==
                                                            'PermissionStatus.unknown' ||
                                                        permisoStatus
                                                                .toString() ==
                                                            'PermissionStatus.disabled' ||
                                                        permisoStatus
                                                                .toString() ==
                                                            'PermissionStatus.neverAskAgain') {
                                                      setState(() {
                                                        isLoadig2 = false;
                                                      });
                                                      return showDialog(
                                                        context: context,
                                                        child: Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child: Text(
                                                              '¡La aplicación no puede acceder a la ubicación de tu dispositivo, es algo indispensable para llenar el formulario, ve a la configuración de tu celular y asignale los permisos!',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      print(permisoStatus
                                                          .toString());
                                                      controlador1
                                                              .latitudfinal =
                                                          latitud;
                                                      controlador1
                                                              .longitudfinal =
                                                          longitud;
                                                      print(
                                                          'la latitud actual es:' +
                                                              controlador1
                                                                  .latitudfinal
                                                                  .toString());
                                                      print(
                                                          'la ongitud actual es:' +
                                                              controlador1
                                                                  .longitudfinal
                                                                  .toString());
                                                      showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          child: WillPopScope(
                                                            onWillPop:
                                                                () async {
                                                              setState(() {
                                                                isLoadig2 =
                                                                    false;
                                                              });
                                                              return true;
                                                            },
                                                            child: AlertDialog(
                                                              title: Text(
                                                                  'Importante',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red)),
                                                              content: Text(
                                                                  'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20)),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text(
                                                                      'OK'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MapSample(
                                                                                latitud: latitud,
                                                                                longitud: longitud,
                                                                                controlador1: controlador1,
                                                                              )),
                                                                    );
                                                                    setState(
                                                                        () {
                                                                      isLoadig2 =
                                                                          false;
                                                                      boton =
                                                                          false;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ));
                                                    }
                                                  }
                                                : null),
                                  )
                                : SizedBox(
                                    width: 5,
                                  ),
                          ],
                        )
                      : tipotemp == 'Veterinaria u otros'
                          ? //Ubicacion
                          Center(
                              child: isLoadig2
                                  ? CircularProgressIndicator()
                                  : RaisedButton.icon(
                                      icon: Icon(Icons.location_on),
                                      label: Text('Capturar ubicación'),
                                      onPressed: boton
                                          ? () async {
                                              print(
                                                  'permiso al entrar al botón:' +
                                                      permisoStatus.toString());
                                              setState(() {
                                                isLoadig2 = true;
                                              });
                                              await getLocation();
                                              print(
                                                  'permiso despues cuadro dialogo:' +
                                                      permisoStatus.toString());
                                              await PermissionHandler()
                                                  .checkPermissionStatus(
                                                      PermissionGroup
                                                          .locationWhenInUse)
                                                  .then(_actualizaestado);
                                              print('permiso final: ' +
                                                  permisoStatus.toString());
                                              if (permisoStatus.toString() == 'PermissionStatus.denied' ||
                                                  permisoStatus.toString() ==
                                                      'PermissionStatus.unknown' ||
                                                  permisoStatus.toString() ==
                                                      'PermissionStatus.disabled' ||
                                                  permisoStatus.toString() ==
                                                      'PermissionStatus.neverAskAgain') {
                                                setState(() {
                                                  isLoadig2 = false;
                                                });
                                                return showDialog(
                                                  context: context,
                                                  child: Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(20),
                                                      child: Text(
                                                        '¡La aplicación no puede acceder a la ubicación de tu dispositivo, es algo indispensable para llenar el formulario, ve a la configuración de tu celular y asignale los permisos!',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print(permisoStatus.toString());
                                                controlador1.latitudfinal =
                                                    latitud;
                                                controlador1.longitudfinal =
                                                    longitud;
                                                print('la latitud actual es:' +
                                                    controlador1.latitudfinal
                                                        .toString());
                                                print('la ongitud actual es:' +
                                                    controlador1.longitudfinal
                                                        .toString());
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    child: WillPopScope(
                                                      onWillPop: () async {
                                                        setState(() {
                                                          isLoadig2 = false;
                                                        });
                                                        return true;
                                                      },
                                                      child: AlertDialog(
                                                        title: Text(
                                                            'Importante',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                        content: Text(
                                                            'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.',
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('OK'),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            MapSample(
                                                                              latitud: latitud,
                                                                              longitud: longitud,
                                                                              controlador1: controlador1,
                                                                            )),
                                                              );
                                                              setState(() {
                                                                isLoadig2 =
                                                                    false;
                                                                boton = false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                              }
                                            }
                                          : null),
                            )
                          : Center(
                              child: Text('Agradecemos tu Apoyo'),
                            ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.number,
                    initialValue: controlador1.usuario.telefono.toString(),
                    onSaved: (String value) {
                      formRescate['telefono'] = int.parse(value);
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Teléfono vacío';
                      } else if (value.length > 10) {
                        return 'Ingrese 10 dígitos';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: '* Teléfono',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: isLoadig
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            icon: Icon(Icons.check),
                            label: Text('Guardar'),
                            onPressed: () async {
                              if (!_rescatekey.currentState.validate()) {
                                setState(() {
                                  isLoadig = false;
                                });
                                return;
                              }

                              setState(() {
                                formRescate['userName'] =
                                    controlador1.usuario.nombre;
                                formRescate['fecha'] = DateTime.now();
                                isLoadig = true;
                              });

                              if (images != null) {
                                for (var im in images) {
                                  var fotos = await saveImage(im, controlador1);

                                  formRescate['fotos'].add(fotos['url']);
                                  formRescate['albumrefs'].add(fotos['ref']);
                                }
                                print(formRescate['fotos'].toString());
                              }
                              if (_image != null &&
                                  formRescate['tipoAnimal'] != null) {
                                final String fileName =
                                    controlador1.usuario.correo +
                                        '/rescate/' +
                                        DateTime.now().toString();

                                Reference storageRef = FirebaseStorage.instance
                                    .ref()
                                    .child(fileName);

                                final UploadTask uploadTask =
                                    storageRef.putFile(
                                  _image,
                                );

                                final TaskSnapshot downloadUrl =
                                    (await uploadTask.whenComplete(() => null));

                                final String url =
                                    (await downloadUrl.ref.getDownloadURL());
                                final String fotoref = downloadUrl.ref.fullPath;
                                print('URL Is $url');
                                setState(() {
                                  formRescate['foto'] = url;
                                  formRescate['reffoto'] = fotoref;
                                  formRescate['userId'] =
                                      controlador1.usuario.documentId;
                                  if (controlador1.latitudfinal != null &&
                                      controlador1.longitudfinal != null) {
                                    formRescate['ubicacion'] = GeoPoint(
                                        controlador1.latitudfinal,
                                        controlador1.longitudfinal);
                                  } else {
                                    formRescate['ubicacion'] = GeoPoint(0, 0);
                                  }
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
                                      title: Text('Has olvidado añadir algo'),
                                    ));
                              }

                              _rescatekey.currentState.save();

                              var agregar = await FirebaseFirestore.instance
                                  .collection('rescates')
                                  .add(formRescate)
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
                                images.clear();
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

  Future saveImage(Asset asset, Controller controlador1) async {
    Map<String, String> fotosRef = {'url': null, 'ref': null};
    ByteData byteData = await asset.getThumbByteData(500, 500, quality: 100);
    List<int> imageData = byteData.buffer.asUint8List();
    final String fileName =
        controlador1.usuario.correo + '/rescate/' + DateTime.now().toString();
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = ref.putData(imageData);

    fotosRef['url'] =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    fotosRef['ref'] = (await uploadTask.whenComplete(() => null)).ref.fullPath;
    return fotosRef;
  }
}
