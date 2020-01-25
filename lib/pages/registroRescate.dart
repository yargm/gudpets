import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'mapaejemplo.dart';

import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';


class RegistroRescate extends StatefulWidget {
  @override
  _RegistroRescateState createState() => _RegistroRescateState();
}

class _RegistroRescateState extends State<RegistroRescate> {
  UserLocation _currentLocation;
  var location = Location();
  double latitud;
  double longitud;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation = UserLocation(
            latitud: userLocation.latitude, longitud: userLocation.longitude);
        latitud = _currentLocation.latitud;
        longitud = _currentLocation.longitud;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  bool capturaubicacion = false;

  File _image = null;
  final _rescatekey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  String or = '';
  String tipoA = '';
  Map<String, dynamic> form_rescate = {
    'titulo': null,
    'ubicacion': null,
    'telefono': null,
    'foto': null,
    'descripcion': null,
    'tipoAnimal': null,
    'fecha': null,
    'userName': null,
    'fotos': [],
    'favoritos': [],
  };
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
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
                      fontFamily: 'Montserrat',
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
                capturaubicacion
                    ? Text('Ubicación capturada con éxito' +
                        controlador1.latitudfinal.toString() +
                        ',' +
                        controlador1.longitudfinal.toString())
                    : FlatButton(
                        child: Text('Capturar ubicación'),
                        onPressed: () async {
                          setState(() {
                            capturaubicacion = true;
                          });
                          await getLocation();
                          print('actual lat: ' + latitud.toString());
                          print('actual long: ' + longitud.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapSample(
                                      latitud: latitud,
                                      longitud: longitud,
                                      controlador1: controlador1,
                                    )),
                          );
                        },
                      ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_rescate['titulo'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Título vacío';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Titulo del Post',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_rescate['descripcion'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Descripción vacía';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Desripción',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Selecciona el tipo de Animal'),
                FittedBox(
                  child: RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>['perro', 'gato', 'ave', 'otro'],
                      onSelected: (String opcion) {
                        setState(() {
                          form_rescate['tipoAnimal'] = opcion;
                        });
                      }),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('¿En qué lugar Resguardas  la Mascota?'),
                RadioButtonGroup(
                    picked: null,
                    orientation: GroupedButtonsOrientation.VERTICAL,
                    labels: <String>[
                      'En tu Hogar',
                      'Veterinaria U Otros',
                    ],
                    onSelected: (String opcion) {
                      setState(() {
                        tipotemp = opcion;
                      });
                    }),
                tipotemp == 'En tu Hogar'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              '¿Quieres que las personas Puedan ver la ubicación de tu Hogar?'),
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
                              ? TextFormField(
                                  initialValue: null,
                                  onSaved: (String value) {
                                    form_rescate['ubicacion'] = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Ubicación',
                                      prefixIcon: Icon(Icons.location_on),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                )
                              : SizedBox(
                                  width: 5,
                                ),
                        ],
                      )
                    : tipotemp == 'Veterinaria U Otros'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                initialValue: null,
                                onSaved: (String value) {
                                  form_rescate['ubicacion'] = value;
                                },
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Campo Obligatorio';
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Ubicación',
                                    prefixIcon: Icon(Icons.location_on),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text('Agradecemos tu Apoyo')],
                          ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: controlador1.usuario.telefono.toString(),
                  onSaved: (String value) {
                    form_rescate['telefono'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Teléfono vacío';
                    } else if (value.length > 10) {
                      return 'Ingrese 10 dígitos';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Teléfono',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                Text(
                  'Protegemos tus datos. Tu número telefónico no aparecerá en tu perfil, sólo será visible cuando hagas un rescate o tengas animales en adopción',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('* Toca la Imagen para añadir una Foto: '),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Container(
                        width: 150.0,
                        height: 150.0,
                        margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage: _image == null
                              ? NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Dog.svg/900px-Dog.svg.png')
                              : FileImage(_image),
                          backgroundColor: Colors.transparent,
                        )),
                  ),
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
                            setState(() {
                              form_rescate['userName'] =
                                  controlador1.usuario.nombre;
                              form_rescate['fecha'] = DateTime.now();
                              isLoadig = true;
                            });

                            if (!_rescatekey.currentState.validate()) {
                              setState(() {
                                isLoadig = false;
                              });
                              return;
                            }

                            if (_image != null) {
                              final String fileName = form_rescate['userName'] +
                                  '/rescate/' +
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

                              final String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              print('URL Is $url');
                              setState(() {
                                form_rescate['foto'] = url;
                              });
                            } else {
                              return showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text(
                                              'Necesitas Añadir una Imagen para continuar'),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Regresar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                    title: Text('Campo Obligatorio'),
                                  ));
                            }

                            _rescatekey.currentState.save();

                            var agregar = await Firestore.instance
                                .collection('rescates')
                                .add(form_rescate)
                                .then((value) {
                              if (value != null) {
                                return true;
                              } else {
                                return false;
                              }
                            });

                            if (agregar) {
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
}
