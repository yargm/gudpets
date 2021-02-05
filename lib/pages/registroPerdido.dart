import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'mapaejemplo.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class RegistroPerdido extends StatefulWidget {
  @override
  _RegistroPerdidoState createState() => _RegistroPerdidoState();
}

class _RegistroPerdidoState extends State<RegistroPerdido> {
  final TextEditingController textEditingControllerFecha =
      TextEditingController();

  File _image;
  final _perdidokey = GlobalKey<FormState>();
  String tipotemp = '';
  bool isLoadig = false;
  bool isLoadig2 = false;
  bool boton = true;
  bool recompensa = false;

  Map<String, dynamic> formPerdido = {
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
      formPerdido['fechaExtravio'] = picked;
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

    return WillPopScope(
      onWillPop: () async {
        return isLoadig ? false : true;
      },
      child: Scaffold(
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
                    height: 10,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Título
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      formPerdido['titulo'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Título vacío';
                      }
                      return null;
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
                      formPerdido['descripcion'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Descripción vacía';
                      }
                      return null;
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
                            formPerdido['tipoAnimal'] = opcion;
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
                          formPerdido['sexo'] = opcion;
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  //Raza
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      formPerdido['raza'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Raza vacía';
                      }
                      return null;
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
                      formPerdido['senasPart'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Señas particulares vacías';
                      }
                      return null;
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
                    validator: (String value) {
                      if (textEditingControllerFecha.text == '' ||
                          textEditingControllerFecha.text == null ||
                          textEditingControllerFecha.text.isEmpty ||
                          formPerdido['fechaExtravio'] == null) {
                        return 'El campo fecha de extravio es obligatorio';
                      }
                      return null;
                    },
                    controller: textEditingControllerFecha,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: '* Fecha de extravio',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
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
                            formPerdido['recompensa'] = value;
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Cantidad vacía';
                            }
                            return null;
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
                      formPerdido['telefono'] = int.parse(value);
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
                                      await controlador1.getAddress(
                                          context, false);
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
                                formPerdido['userName'] =
                                    controlador1.usuario.nombre;
                                formPerdido['fecha'] = DateTime.now();
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
                                  formPerdido['tipoAnimal'] != null &&
                                  formPerdido['sexo'] != null) {
                                final String fileName =
                                    controlador1.usuario.correo +
                                        '/perdido/' +
                                        DateTime.now().toString();

                                Reference storageRef = FirebaseStorage
                                    .instance
                                    .ref()
                                    .child(fileName);

                                final UploadTask uploadTask =
                                    storageRef.putFile(
                                  _image,
                                );

                                final TaskSnapshot downloadUrl =
                                    (await uploadTask.whenComplete(() => null));
                                final String fotoref = downloadUrl.ref.fullPath;

                                final String url =
                                    (await downloadUrl.ref.getDownloadURL());
                                print('URL Is $url');
                                setState(() {
                                  formPerdido['foto'] = url;
                                  formPerdido['userId'] =
                                      controlador1.usuario.documentId;
                                  formPerdido['reffoto'] = fotoref;
                                  formPerdido['ubicacion'] = GeoPoint(
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

                              var agregar = await FirebaseFirestore.instance
                                  .collection('perdidos')
                                  .add(formPerdido)
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
