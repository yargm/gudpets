import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
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
              key: _formKey,
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
                      padding:  EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            
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
<<<<<<< HEAD:lib/login.dart
                            color: Colors.brown[300],
                            onPressed: () => null,
                            textColor: Colors.white,
                            elevation: 12.0,
                            highlightElevation: 8.0,
=======
                            onPressed: () { 
                              Navigator.of(context).pushReplacementNamed('/home');
                            },
                            textColor: Colors.black,
                            elevation: 9.0,
                            highlightElevation: 6.0,
>>>>>>> master:lib/pages/login.dart
                            child: Text(
                              
                              "Iniciar Sesión",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
     floatingActionButton: FloatingActionButton.extended(onPressed: (){},
     label: Text(' Registrate'),
      icon: Icon(FontAwesomeIcons.userPlus),
      backgroundColor: Colors.brown[300],
    ),
    );
  }
}
