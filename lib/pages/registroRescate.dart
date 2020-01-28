import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:location/location.dart';
import 'mapaejemplo.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class RegistroRescate extends StatefulWidget {
  @override
  _RegistroRescateState createState() => _RegistroRescateState();
}

class _RegistroRescateState extends State<RegistroRescate> {
  UserLocation _currentLocation;
  var location = Location();
  double latitud;
  double longitud;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  @override
  void initState() {
    super.initState();
  }

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

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

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
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  bool capturaubicacion = false;

  File _image = null;
  final _rescatekey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  String or = '';
  String tipoA = '';
  Map<String, dynamic> form_rescate = {
    'titulo': null,
    'ubicacion': <GeoPoint>[],
    'telefono': null,
    'foto': null,
    'descripcion': null,
    'tipoAnimal': null,
    'fecha': null,
    'userName': null,
    'fotos': <String>[],
    'favoritos': <String>[],
    'userId': null,
  };
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Registro Rescate'),),
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
                              ? AssetImage('assets/perriti_pic.png')
                              : FileImage(_image),
                          backgroundColor: Colors.transparent,
                        )),
                  ),
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
                      labelText: '* Titulo del Rescate',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
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
                          borderRadius: BorderRadius.circular(25))),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('* Selecciona el tipo de Animal'),
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
                  height: 20,
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
                              ? Center(
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
                                                  controlador1.latitudfinal =
                                                      latitud;
                                                  controlador1.longitudfinal =
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
                                                      context: context,
                                                      child: AlertDialog(
                                                        content: Text(
                                                            'Para cambiar la ubicación en el mapa, mantén presionado el marcador rojo y deslízalo hasta posicionarlo en la calle correcta.'),
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
                                                      ));
                                                }
                                              : null),
                                )
                              : SizedBox(
                                  width: 5,
                                ),
                        ],
                      )
                    : tipotemp == 'Veterinaria U Otros'
                        ? Center(
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
                                            controlador1.longitudfinal =
                                                longitud;
                                            print('la latitud actual es:' +
                                                controlador1.latitudfinal
                                                    .toString());
                                            print('la ongitud actual es:' +
                                                controlador1.longitudfinal
                                                    .toString());
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
                                                              builder:
                                                                  (context) =>
                                                                      MapSample(
                                                                        latitud:
                                                                            latitud,
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
                                                ));
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
                RaisedButton(
                    onPressed: loadAssets, child: Text('Más imagenes')),
                images.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(
                            parent: NeverScrollableScrollPhysics()),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => AssetThumb(
                          asset: images[index],
                          width: 300,
                          height: 300,
                        ),
                        itemCount: images.length,
                      )
                    : Text('No hay fotos para mostrar'),
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
                              form_rescate['userName'] =
                                  controlador1.usuario.nombre;
                              form_rescate['fecha'] = DateTime.now();
                              isLoadig = true;
                            });

                            if (images != null) {
                              for (var im in images) {
                                var url = await saveImage(im);
                                form_rescate['fotos'].add(url);
                              }
                              print(form_rescate['fotos'].toString());
                            }
                            if (_image != null &&
                                form_rescate['tipoAnimal'] != null) {
                              final String fileName = controlador1.usuario.correo +
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
                                form_rescate['userId'] =
                                    controlador1.usuario.documentId;
                                if (controlador1.latitudfinal != null && controlador1.longitudfinal != null) {
                                  form_rescate['ubicacion'] = GeoPoint(
                                      controlador1.latitudfinal,
                                      controlador1.longitudfinal);
                                } else {
 form_rescate['ubicacion'] = GeoPoint(0,0);

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
                              controlador1.latitudfinal = null;
                              controlador1.longitudfinal = null;
                              images.clear();
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

  Future saveImage(Asset asset) async {
    ByteData byteData = await asset.getThumbByteData(500, 500, quality: 100);
    List<int> imageData = byteData.buffer.asUint8List();
    final String fileName =
        form_rescate['userName'] + '/rescate/' + DateTime.now().toString();
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 750, maxWidth: 750);
    setState(() {
      _image = image;
    });
  }
}
