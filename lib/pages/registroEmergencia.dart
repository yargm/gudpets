import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'mapaejemplo.dart';
import 'package:gudpets/services/services.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistroEmergencia extends StatefulWidget {
  @override
  _RegistroEmergenciaState createState() => _RegistroEmergenciaState();
}

class _RegistroEmergenciaState extends State<RegistroEmergencia> {
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

  var _image;
  final _emergenciakey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  String or = '';
  String tipoA = '';

  Map<String, dynamic> form_emergencia = {
    'foto': null,
    'titulo': null,
    'descripcion': null,
    'tipoAnimal': null,
    'tipoEmergencia': null,
    'ubicacion': null,
    'userName': null,
    'fecha': null,
    'favoritos': [],
    'userId': null,
    'reffoto': null,
  };

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro Emergencia'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _emergenciakey,
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
                    ? '* Seleccione una imagen para la emergencia '
                    : 'Imagen seleccionada'),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => getImage(controlador1),
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
                              radius: 45,
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
                              onPressed: () => getImage(controlador1),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //Título
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_emergencia['titulo'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Título vacío';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Titulo de la emergencia',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                ),
                SizedBox(
                  height: 15,
                ),
                //Descripcion
                TextFormField(
                  maxLines: 10,
                  minLines: 2,
                  onSaved: (String value) {
                    form_emergencia['descripcion'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Descripción vacía';
                    }
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
                          form_emergencia['tipoAnimal'] = opcion;
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                //Tipo de emergencia
                Text('* Selecciona el tipo de emergencia'),
                RadioButtonGroup(
                    picked: null,
                    orientation: GroupedButtonsOrientation.VERTICAL,
                    labels: <String>[
                      'Hembra gestante o cachorros',
                      'Abuso y maltrato',
                      'Emergencia de salud',
                      'Otro'
                    ],
                    onSelected: (String opcion) {
                      setState(() {
                        form_emergencia['tipoEmergencia'] = opcion;
                      });
                    }),
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
                              form_emergencia['userName'] =
                                  controlador1.usuario.nombre;
                              form_emergencia['fecha'] = DateTime.now();
                              isLoadig = true;
                            });

                            if (!_emergenciakey.currentState.validate()) {
                              setState(() {
                                isLoadig = false;
                              });
                              return;
                            }

                            if (_image != null &&
                                controlador1.latitudfinal != null &&
                                controlador1.longitudfinal != null &&
                                form_emergencia['tipoAnimal'] != null &&
                                form_emergencia['tipoEmergencia'] != null) {
                              final String fileName =
                                  controlador1.usuario.correo +
                                      '/emergencia/' +
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
                                form_emergencia['foto'] = url;
                                form_emergencia['reffoto'] = fotoref;
                                form_emergencia['userId'] =
                                    controlador1.usuario.documentId;
                                form_emergencia['ubicacion'] = GeoPoint(
                                    controlador1.latitudfinal,
                                    controlador1.longitudfinal);
                              });
                            } else {
                              return showDialog(
                                  barrierDismissible: false,
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

                            _emergenciakey.currentState.save();

                            var agregar = await Firestore.instance
                                .collection('emergencias')
                                .add(form_emergencia)
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
