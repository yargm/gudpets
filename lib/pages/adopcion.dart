import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class Adopcion extends StatefulWidget {
  final AdopcionModel objeto;
  final bool favorito;

  Adopcion({this.objeto, this.favorito});

  @override
  _AdopcionState createState() => _AdopcionState();
}

class _AdopcionState extends State<Adopcion> {
  Map<String, dynamic> formsolicitud = {};

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    controlador1.adopcion = widget.objeto;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          Container(
              padding: EdgeInsets.all(10),
              child: Image(
                image: AssetImage('assets/gudpetsfirstNoText.png'),
              )),
        ],
        title: Text('GudPets'),
        // leading: IconButton(
        //   color: Colors.white,
        //   onPressed: () => Navigator.of(context).pop(),
        //   icon: Icon(
        //     FontAwesomeIcons.chevronCircleLeft,
        //   ),
        // ),
        // elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 350,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: FadeInImage(
                          image: NetworkImage(widget.objeto.foto),
                          placeholder: AssetImage('assets/dog.png'),
                        ),
                      ),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Hero(
                          tag: widget.objeto.documentId,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage('assets/dog.png'),
                            width: double.maxFinite,
                            height: 350,
                            image: NetworkImage(widget.objeto.foto),
                          )),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                            color: Colors.brown[300]),
                        padding: EdgeInsets.all(10.0),
                        width: widget.objeto.userName.length * 11.1,
                        height: 40,
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.objeto.userName,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.objeto.titulo,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: <Widget>[
                            Text('Tipo:', style: TextStyle(fontSize: 12)),
                            widget.objeto.tipoAnimal == 'perro'
                                ? Icon(FontAwesomeIcons.dog)
                                : widget.objeto.tipoAnimal == 'gato'
                                    ? Icon(FontAwesomeIcons.cat)
                                    : widget.objeto.tipoAnimal == 'ave'
                                        ? Icon(FontAwesomeIcons.dove)
                                        : Text(
                                            'otro',
                                            style: TextStyle(fontSize: 15),
                                          ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.description),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(widget.objeto.descripcion,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.venusMars),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Sexo: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(widget.objeto.sexo,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.grey))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.cake),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Edad:',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Text(widget.objeto.edad,
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.grey)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          widget.objeto.convivenciaotros
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.convivenciaotros
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Convivencia con otros: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        widget.objeto.convivenciaotros
                            ? Text('Sí',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey))
                            : Text('No'),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          widget.objeto.desparacitacion
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.desparacitacion
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Desparacitado: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        widget.objeto.desparacitacion
                            ? Text('Sí',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey))
                            : Text('No',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          widget.objeto.vacunacion
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.vacunacion
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Vacunado: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        widget.objeto.vacunacion
                            ? Text('Sí',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey))
                            : Text('No',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          widget.objeto.esterilizacion
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: widget.objeto.esterilizacion
                              ? Colors.green
                              : Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Esterilizado: ',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        widget.objeto.esterilizacion
                            ? Text('Si',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey))
                            : Text('No',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.calendar_today),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Fecha de publicación: ',
                                style: TextStyle(
                                  fontSize: 20.0,
                                )),
                            Text(
                              widget.objeto.fecha.day.toString() +
                                  '/' +
                                  widget.objeto.fecha.month.toString() +
                                  '/' +
                                  widget.objeto.fecha.year.toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      endIndent: 60,
                      indent: 60,
                      thickness: 1,
                      color: secondaryDark,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text('Álbum',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ),
                    SizedBox(height: 5),
                    widget.objeto.fotos.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Desliza hacia la derecha ",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                              Container(
                                height: 350,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(
                                      parent: BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics())),
                                  itemBuilder: (context, index) => FadeInImage(
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage('assets/dog.png'),
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    height: 300,
                                    image: NetworkImage(
                                        widget.objeto.fotos[index]),
                                  ),
                                  itemCount: widget.objeto.fotos.length,
                                ),
                              )
                            ],
                          )
                        : Text(
                            'No hay nada para mostrar',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                endIndent: 60,
                indent: 60,
                thickness: 1,
                color: secondaryDark,
              ),
              SizedBox(
                height: 30,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  controlador1.usuario.documentId == widget.objeto.userId &&
                          widget.objeto.status == 'en adopcion'
                      ? FloatingActionButton.extended(
                          icon: Icon(FontAwesomeIcons.userFriends),
                          label: Text('Ver solicitudes'),
                          onPressed: () {
                            print(widget.objeto.documentId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SolicitudAdopcion(
                                        docId: widget.objeto.reference,
                                      )),
                            );
                          },
                        )
                      : widget.objeto.status == 'en adopcion'
                          ? FloatingActionButton.extended(
                              icon: Icon(FontAwesomeIcons.home),
                              label: Text('Adoptar'),
                              onPressed: () async {
                                print('boton adoptar');
                                var query = widget.objeto.reference
                                    .collection('solicitudes')
                                    .where('userId',
                                        isEqualTo:
                                            controlador1.usuario.documentId)
                                    .getDocuments();
                                query.then((onValue) {
                                  if (onValue.documents.isNotEmpty) {
                                    return showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Solicitud realizada '),
                                        content:
                                            Text('Ya te encuentras postulado'),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              return Navigator.of(context)
                                                  .pop();
                                            },
                                            child: Text('CERRAR'),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    print('boton para adoptar');
                                    if (controlador1.usuario.fotoCompDomiRef ==
                                            null ||
                                        controlador1.usuario.fotoINERef ==
                                            null ||
                                        controlador1.usuario.galeriaFotosRefs ==
                                            null ||
                                        controlador1
                                            .usuario.galeriaFotosRefs.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                    'No puedes postularte'),
                                                content: Text(
                                                    'Para postularte es necesario completar tu información.'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      return Navigator.of(
                                                              context)
                                                          .pushNamed('/perfil');
                                                    },
                                                    child: Text('IR A PERFIL'),
                                                  )
                                                ],
                                              ));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                  'Al solicitar una adopción de esta mascota aceptas lo siguiente:',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Text(
                                                      "1. No tendrás a la mascota aislada, ya sea en azoteas, balcones, patios o para cuidar establecimientos. La mascota requiere de un ambiente familiar.\n\n2. No mutilar cola u orejas de la mascota.\n\n3. Todos en el hogar en el que la mascota vivirá deben estar de acuerdo con su adopción.\n\n4. La mascota no es un objeto, no puedes regalarla o venderla a terceras personas.\n\n5. La convivencia de la mascota con menores de edad siempre debe ser supervisada por un adulto.\n\n6. Es obligatorio continuar con el cuadro médico de la mascota, esto incluye desparacitación, vacunación y esterilización.\n\n7. No adopte con fines reproductivos o de venta, no lucre con la vida de un animal.\n\n8. En caso de que el actual poseedor de la mascota considere necesario, este puede hacer visitas de rutina a su nuevo hogar para supervisar el progreso o adaptación de este.\n\nPor favor, adopta con amor, paciencia y responsabilidad. Tener una mascota es un compromiso a largo plazo que requiere tiempo, dinero y esfuerzo."),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      return Navigator.of(
                                                              context)
                                                          .pop();
                                                    },
                                                    child: Text('CANCELAR'),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      print('solicitud valida');
                                                      formsolicitud['correo'] =
                                                          controlador1
                                                              .usuario.correo;
                                                      formsolicitud[
                                                              'descripcion'] =
                                                          controlador1.usuario
                                                              .descripcion;
                                                      formsolicitud[
                                                              'fnacimiento'] =
                                                          controlador1.usuario
                                                              .fnacimiento;
                                                      formsolicitud['foto'] =
                                                          controlador1
                                                              .usuario.foto;
                                                      formsolicitud['nombre'] =
                                                          controlador1
                                                              .usuario.nombre;
                                                      formsolicitud['sexo'] =
                                                          controlador1
                                                              .usuario.sexo;
                                                      formsolicitud[
                                                              'telefono'] =
                                                          controlador1
                                                              .usuario.telefono;
                                                      formsolicitud['userId'] =
                                                          controlador1.usuario
                                                              .documentId;
                                                      formsolicitud[
                                                              'referencia'] =
                                                          controlador1.usuario
                                                              .reference;
                                                      formsolicitud[
                                                              'fotoStorageRef'] =
                                                          controlador1.usuario
                                                              .fotoStorageRef;
                                                      formsolicitud[
                                                              'fotoCompDomi'] =
                                                          controlador1.usuario
                                                              .fotoCompDomi;
                                                      formsolicitud[
                                                              'fotoCompDomiRef'] =
                                                          controlador1.usuario
                                                              .fotoCompDomiRef;
                                                      formsolicitud['fotoINE'] =
                                                          controlador1
                                                              .usuario.fotoINE;
                                                      formsolicitud[
                                                              'fotoINERef'] =
                                                          controlador1.usuario
                                                              .fotoINERef;
                                                      formsolicitud[
                                                              'galeriaFotos'] =
                                                          controlador1.usuario
                                                              .galeriaFotos;
                                                      formsolicitud[
                                                              'galeriaFotosRefs'] =
                                                          controlador1.usuario
                                                              .galeriaFotosRefs;
                                                      formsolicitud[
                                                              'userIdPub'] =
                                                          widget.objeto.userId;
                                                      formsolicitud[
                                                              'tituloPub'] =
                                                          widget.objeto.titulo;

                                                      var agregar = widget
                                                          .objeto.reference
                                                          .collection(
                                                              'solicitudes')
                                                          .add(formsolicitud)
                                                          .then((value) {
                                                        if (value != null) {
                                                          return true;
                                                        } else {
                                                          return false;
                                                        }
                                                      });
                                                      if (agregar != null) {
                                                        showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          child: AlertDialog(
                                                            title: Text(
                                                              '¡Tu solicitud fue enviada!',
                                                            ),
                                                            content: Text(
                                                              'Gracias por enviar tus datos, te notificaremos cuando tu solicitud sea aceptada.',
                                                            ),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                child:
                                                                    Text('OK'),
                                                                onPressed: () {
                                                                  Navigator.popAndPushNamed(
                                                                      context,
                                                                      '/home');
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text('ACEPTAR'),
                                                  ),
                                                ],
                                              ));
                                    }
                                    return null;
                                  }
                                });
                              })
                          : Container(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: (widget.objeto.status == 'adoptado')
                    ? (widget.objeto.userId == controlador1.usuario.documentId
                        ? Text('Usuario que adoptó a la mascota')
                        : Text('Usuario que dio en adopción a tu mascota'))
                    : Container(),
              ),
              widget.objeto.adoptanteNombre != null
                  ? UserBanner(
                      usuario: UsuarioModel(
                          foto: widget.objeto.adoptanteFoto ?? '',
                          nombre: widget.objeto.adoptanteNombre ?? '',
                          correo: widget.objeto.adoptanteCorreo ?? '',
                          telefono: widget.objeto.adoptanteTelefono ?? 0,
                          fotoINE: widget.objeto.adoptanteINE ?? ''),
                      extended: true,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  favtrue(bool favorito, Controller controlador1, AdopcionModel objeto) {
    objeto.reference.updateData({
      'favoritos': FieldValue.arrayUnion([controlador1.usuario.documentId]),
    });
    controlador1.usuario.reference.updateData(
      {
        'adopciones': FieldValue.arrayUnion([
          {
            'imagen': objeto.foto,
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }

  favfalse(bool favorito, Controller controlador1, AdopcionModel objeto) {
    objeto.reference.updateData({
      'favoritos': FieldValue.arrayRemove([controlador1.usuario.documentId])
    });
    controlador1.usuario.reference.updateData(
      {
        'adopciones': FieldValue.arrayRemove([
          {
            'imagen': objeto.foto,
            'titulo': objeto.titulo,
            'documentId': objeto.documentId,
          }
        ])
      },
    );
  }
}
