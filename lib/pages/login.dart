import 'package:adoption_app/pages/FirstScreen.dart';
import 'package:adoption_app/pages/sign_in.dart';
import 'package:adoption_app/services/models.dart';
import 'package:adoption_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final key = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String error = '';

  Map<String, dynamic> loginMap = {'user': null, 'password': null};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(4.0),
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Form(
              key: key,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'http://www.petcarevets.ie/wp-content/uploads/2019/08/Happy-Pets-PNG.png'),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Nombre e la App no?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
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
                              if (texto.isEmpty) {
                                return 'Correo Vacio';
                              }
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(30.0, 15.0, 20.0, 15.0),
                              labelText: 'Usuario',
                              prefixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
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
                              if (texto.isEmpty) {
                                return 'Contraseña vacia';
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(30.0, 15.0, 20.0, 15.0),
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (key.currentState.validate()) {
                                key.currentState.save();
                                var consulta = Firestore.instance
                                    .collection('usuarios')
                                    .where('correo',
                                        isEqualTo: loginMap['user'])
                                    .where('contrasena',
                                        isEqualTo: loginMap['password'])
                                    .getDocuments();

                                consulta.then((onValue) {
                                  if (onValue.documents.isEmpty) {
                                    print('Datos Incorrectos');
                                    return;
                                  } else {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  }
                                });
                              }
                            },
                            color: Colors.brown[300],
                            textColor: Colors.white,
                            elevation: 9.0,
                            highlightElevation: 6.0,
                            child: Text(
                              "Iniciar Sesión",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                          ),
                          _singInButton(),
                          SizedBox(
                            width: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => StateWidget.of(context).signInWithGoogle(),
      //   label: Text(' Registrate'),

      //   icon: Icon(FontAwesomeIcons.userPlus),
      //   backgroundColor: Colors.brown[300],
      // ),
    );
  }

  Widget _singInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).pushReplacementNamed('/home');
        }).catchError((onError) {
          print('error');
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.google),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Iniciar con Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
