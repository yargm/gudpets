import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  var _image;
  final _emergenciakey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  String or = '';
  String tipoA = '';

  Map<String, dynamic> formEmergencia = {
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

    return WillPopScope(
      onWillPop: () async {
        return isLoadig ? false : true;
      },
      child: Scaffold(
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
                  //Título
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      formEmergencia['titulo'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Título vacío';
                      }
                      return null;
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
                      formEmergencia['descripcion'] = value;
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
                            formEmergencia['tipoAnimal'] = opcion;
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
                          formEmergencia['tipoEmergencia'] = opcion;
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
                                    if (await controlador1
                                        .checkLocationPermisson()) {
                                      setState(() {
                                        isLoadig2 = true;
                                      });
                                      await controlador1.getLocation(context);
                                      controlador1.latitudfinal =
                                          controlador1.latitud;
                                      controlador1.longitudfinal =
                                          controlador1.longitud;
                                      print('la latitud actual es:' +
                                          controlador1.latitudfinal.toString());
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
                                              title: Text('Importante',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              content: Text(
                                                  'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.',
                                                  style:
                                                      TextStyle(fontSize: 20)),
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
                                                                latitud:
                                                                    controlador1
                                                                        .latitud,
                                                                longitud:
                                                                    controlador1
                                                                        .longitud,
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
                                    } else {
                                      setState(() {
                                        isLoadig2 = false;
                                      });
                                      return controlador1
                                          .permissonDeniedDialog(context);
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
                                formEmergencia['userName'] =
                                    controlador1.usuario.nombre;
                                formEmergencia['fecha'] = DateTime.now();
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
                                  formEmergencia['tipoAnimal'] != null &&
                                  formEmergencia['tipoEmergencia'] != null) {
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
                                  formEmergencia['foto'] = url;
                                  formEmergencia['reffoto'] = fotoref;
                                  formEmergencia['userId'] =
                                      controlador1.usuario.documentId;
                                  formEmergencia['ubicacion'] = GeoPoint(
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
                                  .add(formEmergencia)
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
}
