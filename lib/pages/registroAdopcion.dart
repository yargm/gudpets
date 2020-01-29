import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class RegistroAdopcion extends StatefulWidget {
  @override
  _RegistroAdopcionState createState() => _RegistroAdopcionState();
}

class _RegistroAdopcionState extends State<RegistroAdopcion> {
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

  File _image = null;
  final _adopcionkey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  String or = '';
  String tipoA = '';

  Map<String, dynamic> form_adopcion = {
    'convivenciaotros': null,
    'descripcion': null,
    'desparacitacion': null,
    'edad': null,
    'esterilizacion': null,
    'favoritos': [],
    'fecha': null,
    'foto': null,
    'sexo': null,
    'tipoAnimal': null,
    'titulo': null,
    'userName': null,
    'vacunacion': null,
    'userId': null
  };

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return Scaffold(
      appBar: AppBar(),
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
                Text('* Toca la imagen para añadir una foto: '),
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
                              ? AssetImage('assets/perriti_pic.png')
                              : FileImage(_image),
                          backgroundColor: Colors.transparent,
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //Título
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_adopcion['titulo'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Título vacío';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: '* Titulo de adopción',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //Descripcion
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_adopcion['descripcion'] = value;
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
                          form_adopcion['tipoAnimal'] = opcion;
                        });
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                //Convivencia con otros?
                Text('* ¿La mascota onvive con otros animales?'),
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
                          form_adopcion['convivenciaotros'] = true;
                        } else {
                          form_adopcion['convivenciaotros'] = false;
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
                          form_adopcion['desparacitacion'] = true;
                        } else {
                          form_adopcion['desparacitacion'] = false;
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
                          form_adopcion['vacunacion'] = true;
                        } else {
                          form_adopcion['vacunacion'] = false;
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
                          form_adopcion['esterilizacion'] = true;
                        } else {
                          form_adopcion['esterilizacion'] = false;
                        }
                      });
                    }),
                SizedBox(
                  height: 15,
                ),
                //Edad
                Text('* Edad de la mascota'),
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_adopcion['edad'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Edad vacío';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Ej. 1 año',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),                
                //Sexo
                Text('* Sexo '),
                RadioButtonGroup(
                    picked: null,
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    labels: <String>[
                      'Macho ',
                      ' Hembra',
                    ],
                    onSelected: (String opcion) {
                      setState(() {
                        form_adopcion['sexo'] = opcion;
                      });
                    }),
                SizedBox(
                  height: 15,
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
                              form_adopcion['userName'] =
                                  controlador1.usuario.nombre;
                              form_adopcion['fecha'] = DateTime.now();
                              isLoadig = true;
                            });

                            if (!_adopcionkey.currentState.validate()) {
                              setState(() {
                                isLoadig = false;
                              });
                              return;
                            }

                            if (_image != null ) {
                              final String fileName =
                                  form_adopcion['userName'] +
                                      '/adopcion/' +
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
                                form_adopcion['foto'] = url;
                                form_adopcion['userId'] =
                                    controlador1.usuario.documentId;
                              });
                            } else {
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
                                .add(form_adopcion)
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
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);
    setState(() {
      _image = image;
    });
  }
}
