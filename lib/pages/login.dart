
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

  bool isLoading = true;

  Map<String, dynamic> loginMap = {'user': null, 'password': null};

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    controlador1.signInCheck().then((onValue) {
      setState(() {
        isLoading = true;
      });
      if (onValue) {
        Navigator.of(context).pushReplacementNamed('/');
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
                                  image: AssetImage('assets/gudpetsfirstNoText.png')

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
                          isLoading ? CircularProgressIndicator() : Card(
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
                                      contentPadding: EdgeInsets.fromLTRB(
                                          30.0, 15.0, 20.0, 15.0),
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
                                      contentPadding: EdgeInsets.fromLTRB(
                                          30.0, 15.0, 20.0, 15.0),
                                      labelText: 'Contraseña',
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _singInButton(controlador1),
                                      SizedBox(
                                        width: 37,
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
                                                    isEqualTo:
                                                        loginMap['password'])
                                                .getDocuments();

                                            consulta.then((onValue) {
                                              if (onValue.documents.isEmpty) {
                                                print('Datos Incorrectos');
                                                return;
                                              } else {
                                                controlador1.agregausuario(
                                                    UsuarioModel
                                                        .fromDocumentSnapshot(
                                                            onValue.documents
                                                                .first));
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/home', ModalRoute.withName('/home')  );
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                    ],
                                  ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {},
        label: Text(' Registrate'),
        icon: Icon(FontAwesomeIcons.userPlus),
        backgroundColor: Colors.brown[300],
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
              controlador1.usuario_act =
                  UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
              controlador1.signIn();
              Navigator.of(context).pushReplacementNamed('/');
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
                  'Registrate con Google',
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
