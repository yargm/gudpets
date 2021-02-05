import 'package:flutter/material.dart';
import 'dart:io';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final TextEditingController textEditingControllerFecha =
      TextEditingController();
  DateTime date = DateTime.now();
  File imagen;
  bool isLoadig = false;
  final _usuarioform = GlobalKey<FormState>();
  bool tos = false;
  String tipotemp = '';
  bool correov = true;

  Map<String, dynamic> formUsuario = {
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
    'fotoStorageRef': null,
    'edo': null,
    'municipio': null,
  };

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
    );

    setState(() {
      formUsuario['fnacimiento'] = picked;
      textEditingControllerFecha.text = 'Fecha nacimiento ' +
          picked.day.toString() +
          '/' +
          picked.month.toString() +
          '/' +
          picked.year.toString();
    });
  }

  _launchURL() async {
    const url =
        'https://firebasestorage.googleapis.com/v0/b/adoptionapp-8a76d.appspot.com/o/Pol%C3%ADticas%20de%20privacidad.pdf?alt=media&token=ff41a4f7-c898-4426-95e6-fa5bd7d45099';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return WillPopScope(
      onWillPop: () async {
        signOutGoogle();
        Navigator.of(context).pop();
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          return isLoadig ? false : true;
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
                    Text('* Foto: '),
                    GestureDetector(
                      onTap: () async {
                        imagen = await controlador1.getImage(context);
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
                                    radius: 45.0,
                                    backgroundImage: controlador1
                                                .imageUrl.isEmpty &&
                                            imagen == null
                                        ? AssetImage('assets/dog.png')
                                        : controlador1.imageUrl.isNotEmpty &&
                                                imagen == null
                                            ? NetworkImage(
                                                controlador1.imageUrl)
                                            : FileImage(imagen),
                                    backgroundColor: Colors.transparent,
                                  )),
                              CircleAvatar(
                                backgroundColor: secondaryColor,
                                child: IconButton(
                                    icon: Icon(Icons.photo_camera),
                                    onPressed: () async {
                                      imagen =
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
                    TextFormField(
                      initialValue:
                          controlador1.name.isEmpty ? null : controlador1.name,
                      onSaved: (String value) {
                        formUsuario['nombre'] = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Nombre vacío';
                        }
                        if (value.length < 5) {
                          return 'Se requiere al menos un apellido';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: '* Nombre completo',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Sexo:'),
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
                            formUsuario['sexo'] = opcion;
                          });
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (String value) {
                        if (textEditingControllerFecha.text == '' ||
                            textEditingControllerFecha.text == null ||
                            textEditingControllerFecha.text.isEmpty) {
                          return 'El campo fecha de nacimiento es obligatorio';
                        }
                        return null;
                      },
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
                      enabled: controlador1.email.isEmpty ? true : false,
                      initialValue: controlador1.email.isEmpty
                          ? null
                          : controlador1.email,
                      onSaved: (String value) {
                        formUsuario['correo'] = value.trim();
                      },
                      validator: (String value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (value == null || value.isEmpty) {
                          return 'llenar el campo correo electrónico es obligatorio';
                        } else if (!emailValid) {
                          return 'El correo electrónico es inválido';
                        } else if (correov == false) {
                          return 'Correo existente';
                        }
                        return null;
                      },
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                          labelText: 'Correo electrónico ',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: null,
                      onSaved: (String value) {
                        formUsuario['contrasena'] = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Contraseña vacía';
                        } else if (value.length < 3) {
                          return 'Contraseña demasiado corta';
                        }
                        return null;
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
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      initialValue: null,
                      onSaved: (String value) {
                        formUsuario['telefono'] = int.parse(value);
                        formUsuario['edo'] = controlador1.edo;
                        formUsuario['municipio'] = controlador1.municipio;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Teléfono vacío';
                        } else if (value.length != 10) {
                          return 'Ingrese 10 dígitos';
                        }
                        return null;
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

                    // GestureDetector(
                    //   onTap: () {
                    //     getImage();
                    //   },
                    //   child: Container(
                    //       width: 150.0,
                    //       height: 150.0,
                    //       margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
                    //       child: CircleAvatar(
                    //         radius: 45.0,
                    //         backgroundImage: controlador1.imageUrl.isEmpty &&
                    //                 imagen == null
                    //             ? AssetImage(
                    //                 'assets/dog.png')
                    //             : controlador1.imageUrl.isNotEmpty &&
                    //                     imagen == null
                    //                 ? NetworkImage(controlador1.imageUrl)
                    //                 : FileImage(imagen),
                    //         backgroundColor: Colors.transparent,
                    //       )),
                    // ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: <Widget>[
                        Switch(
                          value: tos,
                          onChanged: ((value) {
                            setState(() {
                              tos = value;
                            });
                          }),
                        ),
                        GestureDetector(
                          onTap: () => _launchURL(),
                          child: Text(
                            'Aceptar terminos y condiciones',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    tos
                        ? Text('')
                        : Text(
                            '* Es necesario aceptar nuestros terminos y condiciones para concluir el registro *',
                            style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.bold),
                          ),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        saveButton(controlador1),
                        FlatButton(
                          child: Container(
                            child: ListTile(
                              title: Text('Cancelar Registro'),
                              leading: Icon(Icons.cancel),
                            ),
                            width: double.maxFinite,
                          ),
                          onPressed: () {
                            signOutGoogle();
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
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
      ),
    );
  }

  Widget saveButton(Controller controlador1) {
    return isLoadig
        ? CircularProgressIndicator()
        : RaisedButton.icon(
            icon: Icon(Icons.check),
            label: Text('Guardar'),
            onPressed: () async {
              correov = true;
              if (!_usuarioform.currentState.validate()) {
                setState(() {
                  isLoadig = false;
                });
                return;
              }

              _usuarioform.currentState.save();

              await _validatorEmail(formUsuario['correo']);

              setState(() {
                isLoadig = true;
              });
              if (!_usuarioform.currentState.validate()) {
                setState(() {
                  isLoadig = false;
                });
                return;
              }

              if (controlador1.imageUrl == null) {
                setState(() {
                  isLoadig = false;
                });
                return null;
              }

              if (!tos) {
                setState(() {
                  isLoadig = false;
                });
                return;
              }
              _usuarioform.currentState.save();
              setState(() {
                isLoadig = true;
              });

              if (imagen != null) {
                final String fileName = formUsuario['correo'] +
                    '/perfil/PP' +
                    DateTime.now().toString();

                Reference storageRef =
                    FirebaseStorage.instance.ref().child(fileName);

                final UploadTask uploadTask = storageRef.putFile(
                  imagen,
                );

                final TaskSnapshot downloadUrl =
                    (await uploadTask.whenComplete(() => null));

                final String url = (await downloadUrl.ref.getDownloadURL());
                print('URL Is $url');

                formUsuario['foto'] = url;
                formUsuario['fotoStorageRef'] = downloadUrl.ref.fullPath;
              } else {
                formUsuario['foto'] = controlador1.imageUrl;
              }

              await FirebaseFirestore.instance
                  .collection('usuarios')
                  .add(formUsuario)
                  .then((value) async {
                if (value != null) {
                  var dsUsuario = await value.get();
                  controlador1.agregausuario(
                      UsuarioModel.fromDocumentSnapshot(dsUsuario, 'meh'));
                  controlador1.signIn();
                  Navigator.of(context).pushReplacementNamed('/home');

                  return true;
                } else {
                  return false;
                }
              });
            });
  }

  Future _validatorEmail(String value) async {
    print(value);
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('correo', isEqualTo: value)
        .get()
        .then((onValue) {
      if (onValue.docs.isNotEmpty) {
        print('correo existente');
        setState(() {
          correov = false;
        });
      } else {
        setState(() {
          correov = true;
        });
      }
    });
  }
}
