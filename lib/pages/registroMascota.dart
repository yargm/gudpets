import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/colores.dart';

class RegistroMascota extends StatefulWidget {
  @override
  _RegistroMascotaState createState() => _RegistroMascotaState();
}

class _RegistroMascotaState extends State<RegistroMascota> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingControllerFecha = TextEditingController();
  Map<String, dynamic> mascota = {
    'foto': '',
    'nombre': '',
    'fnacimiento': '',
    'edad': '',
    'personalidad': '',
    'tamano': '',
    'tipoAnimal': '',
    'buscaAmigos': false,
    'storageRef': '',
    'sexo': ''
  };

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().subtract(Duration(days: 30)),
    );

    setState(() {
      mascota['fnacimiento'] = picked;
      textEditingControllerFecha.text = 'Fecha nacimiento ' +
          picked.day.toString() +
          '/' +
          picked.month.toString() +
          '/' +
          picked.year.toString();
    });
  }

  final key0 = GlobalKey<FormState>();
  final key1 = GlobalKey<FormState>();
  final key2 = GlobalKey<FormState>();
  var imagen;
  String error = '';
  bool complete = false;
  bool loading = false;
  StepperType stepperType = StepperType.vertical;
  int currentStep = 0;
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    List<Step> steps = [
      Step(
          title: Text('Información Importante'),
          content: Form(
            key: key0,
            child: Column(
              children: <Widget>[
                Text('Sube una foto de tu mascota'),
                error == ''
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage(
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          image: imagen == null
                              ? AssetImage('assets/dog.png')
                              : FileImage(imagen),
                          placeholder: AssetImage('assets/dog.png'),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () async {
                              imagen = await controlador1.getImage(context);
                              setState(() {
                                error = '';
                              });
                            }),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  onSaved: (value) {
                    mascota['nombre'] = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim() == '') {
                      return 'El campo nombre no puede quedar vacio';
                    }
                    return null;
                  },
                  decoration:
                      InputDecoration(labelText: 'Nombre de la mascota'),
                )
              ],
            ),
          )),
      Step(
          title: Text('Detalles de la Mascota'),
          content: Form(
            key: key1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(''),
                SizedBox(
                  height: 10,
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
                Text('Tamaño de tú mascota'),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onSaved: (value) {
                    mascota['tamano'] = value.trim();
                  },
                  validator: (value) {
                    if (value == null || value.trim() == '') {
                      return 'El campo tamaño no puede quedar vacio';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Ej: Mediano'),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('* Sexo'),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.VERTICAL,
                      labels: <String>['Hembra', 'Macho'],
                      onSelected: (String opcion) {
                        setState(() {
                          mascota['sexo'] = opcion;
                        });
                      }),
                ),
                SizedBox(
                  height: 15,
                ),
                Text('* Selecciona el tipo de animal'),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: RadioButtonGroup(
                      picked: null,
                      orientation: GroupedButtonsOrientation.HORIZONTAL,
                      labels: <String>['perro', 'gato', 'ave', 'otro'],
                      onSelected: (String opcion) {
                        setState(() {
                          mascota['tipoAnimal'] = opcion;
                        });
                      }),
                ),
              ],
            ),
          )),
      Step(
          title: Text('Datos Sociales'),
          content: Form(
              key: key2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Describe su personalidad'),
                  TextFormField(
                    maxLength: 100,
                    maxLines: 4,
                    minLines: 1,
                    onSaved: (value) {
                      mascota['personalidad'] = value;
                    },
                    // validator: (value) {
                    //   // if (value == null || value.trim() == '') {
                    //   //  // return 'El campo personalidad no puede quedar vacio';
                    //   // }
                    //   // return null;
                    // },
                    decoration:
                        InputDecoration(labelText: 'Describe a tu Mascota'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ))),
    ];
    goTo(int step) {
      setState(() => currentStep = step);
    }

    next() async {
      switch (currentStep) {
        case 0:
          setState(() {
            error = '';
          });

          if (imagen == null) {
            setState(() {
              error = '¡Es necesario seleccionar una foto para Mascota!';
            });
            return;
          }
          if (!key0.currentState.validate()) {
            return;
          }

          key0.currentState.save();

          break;
        case 1:
          if (!key1.currentState.validate()) {
            return;
          }

          key1.currentState.save();
          break;
        case 2:
          if (!key2.currentState.validate()) {
            return;
          }
          key2.currentState.save();
          break;
      }

      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() => loading = true);

      if (loading) {
        if (imagen != null) {
          final String fileName = controlador1.usuario.correo +
              '/mascotas/photos' +
              DateTime.now().toString();

          StorageReference storageRef =
              FirebaseStorage.instance.ref().child(fileName);

          final StorageUploadTask uploadTask = storageRef.putFile(
            imagen,
          );

          final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

          final String url = (await downloadUrl.ref.getDownloadURL());
          print('URL Is $url');
          print('Ref: $storageRef');
          mascota['foto'] = url;
          mascota['storageRef'] = downloadUrl.ref.path;
        }

        await controlador1.usuario.reference
            .collection('mascotas')
            .add(mascota);

        setState(() {
          loading = false;
          complete = true;
        });
      }
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        var hola = await showDialog(
            context: context,
            child: AlertDialog(
              title: Text('Saliendo de registro de Mascota'),
              content: Text(
                  '¿Estas seguro que deseas cancelar el registro de esta Mascota?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Regresar',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Cancelar registro'),
                ),
              ],
            ));
        if (hola) {
          return true;
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: <Widget>[
            loading
                ? Expanded(
                    child: AlertDialog(
                      title: Text('Registrando Mascota'),
                      content: LinearProgressIndicator(),
                    ),
                  )
                : complete
                    ? Expanded(
                        child: AlertDialog(
                          title: Text('¡Mascota añadida con exito!'),
                          content: Icon(
                            Icons.check_circle,
                            color: secondaryDark,
                            size: 40,
                          ),
                          actions: <Widget>[
                            RaisedButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.of(context).pop(true)
                                // Navigator.of(context)
                                //     .pushReplacementNamed('/home'),
                                )
                          ],
                        ),
                      )
                    : Expanded(
                        child: Stepper(
                          type: stepperType,
                          steps: steps,
                          currentStep: currentStep,
                          onStepContinue: next,
                          onStepCancel: cancel,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
