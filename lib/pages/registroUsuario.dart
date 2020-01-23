import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:adoption_app/pages/sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final TextEditingController textEditingControllerFecha =
      TextEditingController();
  DateTime date = DateTime.now();
  File imagen = null;
  bool isLoadig = false;
  final _usuarioform = GlobalKey<FormState>();
  String tipotemp = '';

  Map<String, dynamic> form_usuario = {
    'nombre': null,
    'fnacimiento': null,
    'correo': null,
    'contrasena': null,
    'telefono': null,
    'sexo': null,
    'foto': null,
    'descripcion': null,
    'tipo': null,
    'user_id': null,
  };

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
    );

    setState(() {
      form_usuario['fnacimiento'] = picked;
      textEditingControllerFecha.text = 'Fecha nacimiento ' +
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
    return WillPopScope(
      onWillPop: () async {
        signOutGoogle();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: _usuarioform,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Text(
                      'Ingresa tus datos:',
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
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue:
                        controlador1.name.isNotEmpty ? controlador1.name : null,
                    onSaved: (String value) {
                      form_usuario['nombre'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Nombre vacío';
                      }
                      if (value.length < 5) {
                        return 'Se requiere al menos un apellido';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: '* Nombre completo',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('* Sexo:'),
                  SizedBox(
                    height: 3,
                  ),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.VERTICAL,
                      labels: <String>[
                        'Mujer',
                        'Hombre',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          form_usuario['sexo'] = opcion;
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: textEditingControllerFecha,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    keyboardType: TextInputType.number,
                   
                    decoration: InputDecoration(
                        labelText: '* Fecha de nacimiento',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: controlador1.email.isNotEmpty
                        ? controlador1.email
                        : null,
                    onSaved: (String value) {
                      form_usuario['correo'] = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Correo electrónico (opcional)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: null,
                    onSaved: (String value) {
                      form_usuario['contrasena'] = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Contraseña vacía';
                      } else if (value.length < 3) {
                        return 'Contraseña demasiado corta';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: '* Contraseña',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  Text(
                    'Respalda tu contraseña, no podrás reestablecerla una vez guardes tus datos',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: null,
                    onSaved: (String value) {
                      form_usuario['telefono'] = int.parse(value);
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
                  Text('* Foto: '),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                        width: 150.0,
                        height: 150.0,
                        margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage: controlador1.imageUrl.isEmpty &&
                                  imagen == null
                              ? NetworkImage(
                                  'http://mjcnuapada.com/wp-content/uploads/2018/03/no-photo-925faf7029ff24e9d19075149c4f2dfe.jpeg')
                              : controlador1.imageUrl.isNotEmpty &&
                                      imagen == null
                                  ? NetworkImage(controlador1.imageUrl)
                                  : FileImage(imagen),
                          backgroundColor: Colors.transparent,
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('* ¿Qué tipo de usuario eres?'),
                  SizedBox(
                    height: 3,
                  ),
                  RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.VERTICAL,
                      labels: <String>[
                        'Usuario independiente',
                        'Represento a un refugio',
                      ],
                      onSelected: (String opcion) {
                        setState(() {
                          tipotemp = opcion;
                        });
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  tipotemp == 'Represento a un refugio'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              initialValue: null,
                              onSaved: (String value) {
                                form_usuario['tipo'] = tipotemp;
                                form_usuario['descripcion'] = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Descripción vacía';
                                } else if (value.length > 120) {
                                  return 'Ingrese al menos 120 caracteres';
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: '* Descripción',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('* Cantidad de mascotas refugiadas:'),
                            RadioButtonGroup(
                                picked: null,
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                labels: <String>[
                                  'Más de cinco',
                                  'Más de veinte',
                                  'Más de cuarenta'
                                ],
                                onSelected: (String opcion) {
                                  setState(() {
                                    form_usuario['cantidadmascotas'] = opcion;
                                  });
                                }),
                            SizedBox(
                              height: 15,
                            ),
                            Text('*Ubicación (google maps)'),
                            //Pendiente por hacer
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              initialValue: null,
                              onSaved: (String value) {
                                form_usuario['tipo'] = tipotemp;
                                form_usuario['descripcion'] = value;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Descripción (opcional)',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: <Widget>[
                      saveButton(controlador1),
                      FlatButton(
                        child: Container(child: ListTile(title: Text('Cancelar Registro'), leading: Icon(Icons.cancel),), width: double.maxFinite,),
                        
                        onPressed: () {
                          signOutGoogle();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      ),
                    ],
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget saveButton(Controller controlador1) {
    return  isLoadig ? CircularProgressIndicator() : RaisedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text('Guardar'),
                      onPressed: () async {
                        setState(() {
                          isLoadig = true;
                        });
                        if (!_usuarioform.currentState.validate()) {
                          setState(() {
                            isLoadig = false;
                          });
                          return;
                        }

                        _usuarioform.currentState.save();

                        if (imagen != null) {
                          final String fileName = form_usuario['nombre'] +
                              '/evidencia/' +
                              DateTime.now().toString();

                          StorageReference storageRef =
                              FirebaseStorage.instance.ref().child(fileName);

                          final StorageUploadTask uploadTask =
                              storageRef.putFile(
                            imagen,
                          );

                          final StorageTaskSnapshot downloadUrl =
                              (await uploadTask.onComplete);

                          final String url =
                              (await downloadUrl.ref.getDownloadURL());
                          print('URL Is $url');

                          form_usuario['foto'] = url;
                        } else {
                          form_usuario['foto'] = controlador1.imageUrl;
                        }

                        var agregar = await Firestore.instance
                            .collection('usuarios')
                            .add(form_usuario)
                            .then((value) async {
                          if (value != null) {
                            var dsUsuario = await value.get();
                            controlador1.agregausuario(
                                UsuarioModel.fromDocumentSnapshot(dsUsuario));
                            controlador1.signIn();
                            Navigator.of(context).pushReplacementNamed('/home');

                            return true;
                          } else {
                            return false;
                          }
                        });
                      });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagen = image;
    });
  }
}
