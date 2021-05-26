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
    'album': <String>[],
    'albumrefs': <String>[],
    'titulo': null,
    'descripcion': null,
    'tipoAnimal': null,
    'sexo': null,
    'convivenciaotros': null,
    'desparacitacion': null,
    'vacunacion': null,
    'esterilizacion': null,
    'edad': null,
    'fecha': null,
    'favoritos': [],
    'userId': null,
    'userName' : null,
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
                              if (controlador1.images.isNotEmpty &&
                                  formAdopcion['tipoAnimal'] != null &&
                                  formAdopcion['sexo'] != null &&
                                  formAdopcion['convivenciaotros'] != null &&
                                  formAdopcion['desparacitacion'] != null &&
                                  formAdopcion['esterilizacion'] != null &&
                                  formAdopcion['vacunacion'] != null) {
                                for (var im in controlador1.images) {
                                  var fotos = await saveImage(im, controlador1);
                                  formAdopcion['album'].add(fotos['url']);
                                  formAdopcion['albumrefs'].add(fotos['ref']);
                                }
                                print(formAdopcion['album'].toString());
                                setState(() {
                                  formAdopcion['userId'] =
                                      controlador1.usuario.documentId;
                                  formAdopcion['status'] = 'en adopcion';
                                });
                              } else {
                                setState(() {
                                  isLoadig = false;
                                });
                                return datosIncompletos();
                              }

                              _adopcionkey.currentState.save();

                              var agregar = await FirebaseFirestore.instance
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

  datosIncompletos() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
          );
        });
  }

  Future saveImage(Asset asset, Controller controlador) async {
    Map<String, String> fotosRef = {'url': null, 'ref': null};

    ByteData byteData = await asset.getThumbByteData(500, 500, quality: 100);
    List<int> imageData = byteData.buffer.asUint8List();
    final String fileName =
        controlador.usuario.correo + '/adopcion/' + DateTime.now().toString();
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = ref.putData(imageData);

    fotosRef['url'] =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    fotosRef['ref'] = (await uploadTask.whenComplete(() => null)).ref.fullPath;
    return fotosRef;
  }
}
