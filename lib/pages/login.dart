import 'package:gudpets/services/models.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final key = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String error = '';

  bool isLoading = true;
  bool errorbase = false;

  Map<String, dynamic> loginMap = {'user': null, 'password': null};

  void initState() {
    super.initState();
    if (Platform.isIOS) {
    } else {
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.locationWhenInUse)
          .then((status) {
        print(status.toString());
        if (status.toString() == 'PermissionStatus.denied' ||
            status.toString() == 'PermissionStatus.unknown' ||
            status.toString() == 'PermissionStatus.disabled') {
          print('preguntar');
          _askpermission();
        } else {
          print('ya me aceptaste antes');
          return;
        }
      });
    }
  }

 

  Future<bool> _askpermission() async {
    await PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then((status) {
      if (status.toString() == 'PermissionStatus.denied') {
        exit(0);
      }

    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    controlador1.signInCheck().then((onValue) {
      setState(() {
        isLoading = true;
      });
      if (onValue) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(4.0),
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 90),
              child: Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 190.0,
                      height: 190.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  AssetImage('assets/gudpetsfirstNoText.png'))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'GudPets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 70,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'DESARROLLADO POR',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          ' GUDTECH',
                          style: TextStyle(color: gudtech, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    isLoading || controlador1.loading
                        ? CircularProgressIndicator()
                        : Column(
                          
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.symmetric(horizontal: 40),
                                elevation: 9.0,
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0)),
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      TextFormField(
                                        onSaved: (String texto) {
                                          loginMap['user'] = texto;
                                        },
                                        validator: (String texto) {
                                          if (texto.isEmpty ||
                                              texto == '' ||
                                              errorbase) {
                                            return 'Correo incorrecto';
                                          }
                                          return null;
                                          
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              30.0, 15.0, 20.0, 15.0),
                                          labelText: 'Usuario',
                                          prefixIcon:
                                              Icon(Icons.account_circle),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        onSaved: (String texto) {
                                          loginMap['password'] = texto;
                                        },
                                        validator: (String texto) {
                                          if (texto.isEmpty ||
                                              texto == '' ||
                                              errorbase) {
                                            return 'Contraseña incorrecta';

                                          }
                                         return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              30.0, 15.0, 20.0, 15.0),
                                          labelText: 'Contraseña',
                                          prefixIcon: Icon(Icons.lock),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          _singInButton(controlador1),
                                          SizedBox(
                                            width: 37,
                                          ),
                                          RaisedButton(
                                            onPressed: () async {
                                              errorbase = false;

                                              if (!key.currentState
                                                  .validate()) {
                                                return;
                                              }

                                              key.currentState.save();
                                              setState(() {
                                                isLoading = true;
                                              });
                                              var query = await Firestore
                                                  .instance
                                                  .collection('usuarios')
                                                  .where('correo',
                                                      isEqualTo:
                                                          loginMap['user'])
                                                  .where('contrasena',
                                                      isEqualTo:
                                                          loginMap['password'])
                                                  .getDocuments();

                                              if (query.documents.isEmpty) {
                                                setState(() {
                                                  errorbase = true;
                                                  isLoading = false;
                                                });
                                                if (!key.currentState
                                                    .validate()) {
                                                  return;
                                                }
                                              } else {
                                                var user =
                                                    query.documents.first;
                                                controlador1.usuarioActual =
                                                    UsuarioModel
                                                        .fromDocumentSnapshot(
                                                            user);
                                                await controlador1.signIn();
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/home',
                                                        ModalRoute.withName(
                                                            '/home'));
                                              }
                                            },
                                            color: Colors.brown[300],
                                            textColor: Colors.white,
                                            elevation: 9.0,
                                            highlightElevation: 6.0,
                                            child: Text(
                                              "Iniciar Sesión",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              RaisedButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .pushReplacementNamed('/registro_usuario'),
                                label: Text(' Registrate'),
                                icon: Icon(FontAwesomeIcons.userPlus),
                                color: Colors.brown[300],
                                textColor: Colors.white,
                                elevation: 9.0,
                                highlightElevation: 6.0,
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

  Widget _singInButton(Controller controlador1) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        print('entro al on pressed');
        signInWithGoogle(controlador1).whenComplete(() {
          print('estoy dentro y voy a navegar con' + controlador1.name);
          Firestore.instance
              .collection('usuarios')
              .where('correo', isEqualTo: controlador1.email)
              .getDocuments()
              .then((onValue) {
            if (onValue.documents.isEmpty) {
              Navigator.of(context).pushReplacementNamed('/registro_usuario');
            } else {
              controlador1.usuarioActual =
                  UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
              controlador1.signIn();
              Navigator.of(context).pushReplacementNamed('/home');
            }
          });
        }).catchError((onError) {
          print(onError);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      highlightElevation: 6,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.google,
                size: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Acceder con Google',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
