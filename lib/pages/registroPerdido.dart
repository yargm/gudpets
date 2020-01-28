import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'mapaejemplo.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class RegistroPerdido extends StatefulWidget {
  @override
  _RegistroPerdidoState createState() => _RegistroPerdidoState();
}

class _RegistroPerdidoState extends State<RegistroPerdido> {
  UserLocation _currentLocation;
  var location = Location();
  double latitud;
  double longitud;
  final TextEditingController textEditingControllerFecha =
      TextEditingController();

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
  final _perdidokey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;

  Map<String, dynamic> form_perdido = {
    'foto': null,
    'titulo': null,
    'descripcion': null,
    'tipoAnimal': null,
    'raza': null,
    'sexo': null,
    'senasPart': null,
    'fechaExtravio': null,
    'recompensa': false,
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
      appBar: AppBar(title: Text('Registro Extravio'),),
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
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    getImage();
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
                                  ? AssetImage('assets/perriti_pic.png')
                                  : FileImage(_image),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: secondaryColor,
                            child: IconButton(
                              icon: Icon(Icons.photo_camera),
                              onPressed: () => getImage(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
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
                //Señas particulares
                TextFormField(
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
                          form_perdido['recompensa'] = valor;
                        });
                      },
                      value: form_perdido['recompensa'],
                    ),
                  ],
                ),
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
                          onPressed: boton == true
                              ? () async {
                                  setState(() {
                                    isLoadig2 = true;
                                  });
                                  await getLocation();
                                  controlador1.latitudfinal = latitud;
                                  controlador1.longitudfinal = longitud;
                                  print('la latitud actual es:' +
                                      controlador1.latitudfinal.toString());
                                  print('la ongitud actual es:' +
                                      controlador1.longitudfinal.toString());
                                  showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        content: Text(
                                            'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.'),
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
                                                          longitud: longitud,
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
                                      ));
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
                              final String fileName = controlador1.usuario.correo +
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

                              final String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              print('URL Is $url');
                              setState(() {
                                form_perdido['foto'] = url;
                                form_perdido['userId'] =
                                    controlador1.usuario.documentId;
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);
    setState(() {
      _image = image;
    });
  }
}
