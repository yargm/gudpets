import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _usuarioform = GlobalKey<FormState>();
  String tipotemp = '';
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> form_usuario = {
      'nombre': null,
      'edad': null,
      'correo': null,
      'contrasena': null,
      'telefono': null,
      'sexo': null,
      'foto': null,
      'descripcion': null,
      'tipo': null,
      'ubicacion': null,
      'cantidadmascotas': null,
    };
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _usuarioform,
            child: Column(
              children: <Widget>[
                Text(
                  'Ingresa tus datos:',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  initialValue: null,
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
                Text('* Sexo:'),
                RadioButtonGroup(
                    picked: null,
                    orientation: GroupedButtonsOrientation.HORIZONTAL,
                    labels: <String>[
                      'Mujer',
                      'Hombre',
                    ],
                    onSelected: (String opcion) {
                      setState(() {
                        form_usuario['sexo'] = opcion;
                      });
                    }),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: null,
                  onSaved: (String value) {
                    form_usuario['edad'] = value;
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Edad vacía';
                    } else if (value.length > 2 || value.length == 1) {
                      return 'Edad inválida';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: '* Edad',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                TextFormField(
                  initialValue: null,
                  onSaved: (String value) {
                    form_usuario['correo'] = value;
                  },
                  decoration: InputDecoration(
                      labelText: 'Correo electrónico (opcional)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
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
                    'Respalda tu contraseña, no podrás reestablecerla una vez guardes tus datos'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: null,
                  onSaved: (String value) {
                    form_usuario['telefono'] = value;
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
                    'Protegemos tus datos. Tu número telefónico no aparecerá en tu perfil,  \n sólo será visible cuando hagas un rescate o tengas animales en adopción.'),
                Text('* Foto: '),
                // Copiar la parte de fotos de vetec
                Text('* ¿Qué tipo de usuario eres?'),
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
                tipotemp == 'Represento a un refugio'
                    ? Column(
                        children: <Widget>[
                          Text('*Ubicación (google maps)'),
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
                          Text('Cantidad de mascotas refugiadas:'),
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
                        ],
                      )
                    : Column(
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
                RaisedButton.icon(
                    icon: Icon(Icons.playlist_add_check),
                    label: Text('Guardar'),
                    onPressed: () async {
                      setState(() {
                        _usuarioform.currentState.validate();
                        _usuarioform.currentState.save();
                      });

                      var agregar = await Firestore.instance
                          .collection('usuarios')
                          .add(form_usuario)
                          .then((value) {
                        if (value != null) {
                          return true;
                        } else {
                          return false;
                        }
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
