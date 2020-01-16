import 'package:adoption_app/services/models.dart';
import 'package:adoption_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    Controller controlador1 = Provider.of<Controller>(context);
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(4.0),
            padding: const EdgeInsets.fromLTRB(0, 70, 0, 70),
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
                            height: 20.0,
                          ),
                          ButtonBar(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/registro_usuario');
                                },
                                child: Icon(FontAwesomeIcons.userPlus),
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
                                        controlador1.agregausuario(
                                            UsuarioModel.fromDocumentSnapshot(
                                                onValue.documents.first));
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  "Iniciar Sesión",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
