import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'mapaejemplo.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistroPerdido extends StatefulWidget {
  @override
  _RegistroPerdidoState createState() => _RegistroPerdidoState();
}

class _RegistroPerdidoState extends State<RegistroPerdido> {
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
  var location = Location();
  double latitud;
  double longitud;

  final TextEditingController textEditingControllerFecha =
      TextEditingController();

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
  }

  File _image = null;
  final _perdidokey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  bool recompensa = false;

  Map<String, dynamic> form_perdido = {
    'foto': null,
    'reffoto': null,
    'titulo': null,
    'descripcion': null,
    'tipoAnimal': null,
    'raza': null,
    'sexo': null,
    'senasPart': null,
    'fechaExtravio': null,
    'recompensa': null,
    'ubicacion': null,
    'userName': null,
    'fecha': null,
    'favoritos': [],
  };

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );

    setState(() {
      form_perdido['fechaExtravio'] = picked;
      textEditingControllerFecha.text = 'Fecha extravío' +
          picked.day.toString() +
          '/' +
          picked.month.toString() +
          '/' +
          picked.year.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Extravio'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _perdidokey,
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
                Text(_image == null
                    ? '* Seleccione una imagen para la mascota extraviada '
                    : 'Imagen seleccionada'),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() async {
                      _image = await controlador1.getImage(context);
                    });
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
                              onPressed: () => setState(() async {
                                _image = await controlador1.getImage(context);
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15,
                ),
                //Título
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_perdido['titulo'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Título vacío';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: '* Titulo de la publicación',
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
                    form_perdido['descripcion'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Descripción vacía';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Desripción',
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
                          form_perdido['tipoAnimal'] = opcion;
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                //Sexo
                Text('* Selecciona el sexo'),
                RadioButtonGroup(
                    picked: null,
                    orientation: GroupedButtonsOrientation.VERTICAL,
                    labels: <String>[
                      'Hembra',
                      'Macho',
                    ],
                    onSelected: (String opcion) {
                      setState(() {
                        form_perdido['sexo'] = opcion;
                      });
                    }),
                SizedBox(
                  height: 15,
                ),
                //Raza
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_perdido['raza'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Raza vacía';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Raza',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
                SizedBox(
                  height: 15,
                ),

                //Señas particulares
                TextFormField(
                  maxLines: 10,
                  minLines: 2,
                  initialValue: null,
                  onSaved: (String value) {
                    form_perdido['senasPart'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Señas particulares vacías';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Señas particulares',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                //Fecha de extravio
                TextFormField(
                  controller: textEditingControllerFecha,
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: '* Fecha de extravío',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                //Recompensa
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('¿Se ofrece recompensa?'),
                    SizedBox(
                      width: 5,
                    ),
                    Switch(
                      activeColor: secondaryLight,
                      onChanged: (bool valor) {
                        setState(() {
                          recompensa = valor;
                        });
                      },
                      value: recompensa,
                    ),
                  ],
                ),
                recompensa
                    ? TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: null,
                        onSaved: (String value) {
                          form_perdido['recompensa'] = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Cantidad vacía';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: '* Cantidad',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0))),
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                //Teléfono
                TextFormField(
                  enabled: false,
                  initialValue: controlador1.usuario.telefono.toString(),
                  onSaved: (String value) {
                    form_perdido['telefono'] = int.parse(value);
                  },
                  decoration: InputDecoration(
                      labelText: '* Teléfono',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                //Ubicacion
                Center(
                  child: isLoadig2
                      ? CircularProgressIndicator()
                      : RaisedButton.icon(
                          icon: Icon(Icons.location_on),
                          label: Text('Capturar ubicación'),
                          onPressed: boton
                              ? () async {
                                  print('permiso al entrar al botón:' +
                                      permisoStatus.toString());
                                  setState(() {
                                    isLoadig2 = true;
                                  });
                                  await getLocation();
                                  print('permiso despues cuadro dialogo:' +
                                      permisoStatus.toString());
                                  await PermissionHandler()
                                      .checkPermissionStatus(
                                          PermissionGroup.locationWhenInUse)
                                      .then(_actualizaestado);
                                  print('permiso final: ' +
                                      permisoStatus.toString());
                                  if (permisoStatus.toString() ==
                                          'PermissionStatus.denied' ||
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                          child: Text(
                                            '¡La aplicación no puede acceder a la ubicación de tu dispositivo, es algo indispensable para llenar el formulario, ve a la configuración de tu celular y asignale los permisos!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(permisoStatus.toString());
                                    controlador1.latitudfinal = latitud;
                                    controlador1.longitudfinal = longitud;
                                    print('la latitud actual es:' +
                                        controlador1.latitudfinal.toString());
                                    print('la ongitud actual es:' +
                                        controlador1.longitudfinal.toString());
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
                                            title: Text('Importante',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            content: Text(
                                                'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.',
                                                style: TextStyle(fontSize: 20)),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapSample(
                                                              latitud: latitud,
                                                              longitud:
                                                                  longitud,
                                                              controlador1:
                                                                  controlador1,
                                                            )),
                                                  );
                                                  setState(() {
                                                    isLoadig2 = false;
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
                ),
                //Guardar
                Center(
                  child: isLoadig
                      ? CircularProgressIndicator()
                      : RaisedButton.icon(
                          icon: Icon(Icons.check),
                          label: Text('Guardar'),
                          onPressed: () async {
                            setState(() {
                              form_perdido['userName'] =
                                  controlador1.usuario.nombre;
                              form_perdido['fecha'] = DateTime.now();
                              isLoadig = true;
                            });

                            if (!_perdidokey.currentState.validate()) {
                              setState(() {
                                isLoadig = false;
                              });
                              return;
                            }

                            if (_image != null &&
                                controlador1.latitudfinal != null &&
                                controlador1.longitudfinal != null &&
                                form_perdido['tipoAnimal'] != null &&
                                form_perdido['sexo'] != null) {
                              final String fileName =
                                  controlador1.usuario.correo +
                                      '/perdido/' +
                                      DateTime.now().toString();

                              StorageReference storageRef = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(fileName);

                              final StorageUploadTask uploadTask =
                                  storageRef.putFile(
                                _image,
                              );

                              final StorageTaskSnapshot downloadUrl =
                                  (await uploadTask.onComplete);
                              final String fotoref = downloadUrl.ref.path;

                              final String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              print('URL Is $url');
                              setState(() {
                                form_perdido['foto'] = url;
                                form_perdido['userId'] =
                                    controlador1.usuario.documentId;
                                form_perdido['reffoto'] = fotoref;
                                form_perdido['ubicacion'] = GeoPoint(
                                    controlador1.latitudfinal,
                                    controlador1.longitudfinal);
                              });
                            } else {
                              return showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Algunos campos son obligatorios. Por favor, completa la información que se solicita.'),
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

                            _perdidokey.currentState.save();

                            var agregar = await Firestore.instance
                                .collection('perdidos')
                                .add(form_perdido)
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
                              Navigator.pop(context);
                            }
                          }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(Controller controlador1) async {
    var value = await controlador1.checkGalerryPermisson();
    print(value);

    if (value) {
      var image = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);
      setState(() {
        _image = image;
      });
      return image;
    } else {
      return showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            margin: EdgeInsets.all(20),
            child: Text(
              '¡La aplicación no puede acceder a tus fotos y a tu camara por que no le has asignado los permisos, ve a la configuración de tu celular y asignale los permisos!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }
}
