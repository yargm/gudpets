import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:provider/provider.dart';

class ButtonBarOptions extends StatefulWidget {
  final UsuarioModel usuario;
  ButtonBarOptions({this.usuario});

  @override
  _ButtonBarOptionsState createState() => _ButtonBarOptionsState();
}

class _ButtonBarOptionsState extends State<ButtonBarOptions> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    print(controlador1.usuario.amigos);
    print(controlador1.usuario.documentId + ' ' + widget.usuario.documentId);

    if (verifyFriendship(controlador1)) {
      controlador1.usuario.solicitudesAE.remove(widget.usuario.documentId);
    }

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        FlatButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  child: WillPopScope(
                    onWillPop: () async {
                      Navigator.of(context).pop();

                      return !controlador1.loading;
                    },
                    child: WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        content: Text(
                          '¿Seguro que deseas bloquear a este usuario?',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          RaisedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              return;
                            },
                            child: Text('No'),
                          ),
                          RaisedButton(
                            onPressed: () async {
                              controlador1.loading = true;
                              controlador1.notify();
                              await controlador1.usuario.reference.update({
                                'amigos': FieldValue.arrayRemove(
                                    [widget.usuario.documentId]),
                              });
                              await widget.usuario.reference.update({
                                'amigos': FieldValue.arrayRemove(
                                    [controlador1.usuario.documentId]),
                                'bloqueados': FieldValue.arrayUnion(
                                    [controlador1.usuario.documentId]),
                              });
                              controlador1.loading = false;
                              controlador1.notify();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              return;
                            },
                            child: Text('Si'),
                          )
                        ],
                        title: Text(
                          'Bloquear Usuario',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                    ),
                  ));
            },
            icon: Icon(Icons.report, size: 15, color: secondaryDark),
            label: Text(
              'Bloquear \nUsuario',
              style: TextStyle(fontSize: 15, color: secondaryDark),
            )),
        FlatButton.icon(
            onPressed: () {
              List<String> razones = [
                'Contenido Ofensivo',
                'Contenido Pornográfico',
                'Difamasión',
                'Robo de identidad',
              ];
              showDialog(
                  context: context,
                  child: ReportDialog(
                    razones: razones,
                    usuarioModel: widget.usuario,
                  ));
            },
            icon: Icon(Icons.block, size: 15, color: secondaryDark),
            label: Text(
              'Reportar \nUsuario',
              style: TextStyle(fontSize: 15, color: secondaryDark),
            )),
        controlador1.usuario.documentId == widget.usuario.documentId
            ? Container()
            : controlador1.loading
                ? CircularProgressIndicator()
                : verifyMyFRequest(controlador1)
                    ? FlatButton.icon(
                        onPressed: () async {
                          print(widget.usuario.documentId.length);
                          await controlador1.usuario.reference.update({
                            'solicitudesAE': FieldValue.arrayRemove(
                                [widget.usuario.documentId])
                          });
                          controlador1.usuario.solicitudesAE
                              .remove(widget.usuario.documentId);
                          controlador1.notify();
                        },
                        icon: Icon(
                          Icons.cancel,
                          size: 15,
                          color: secondaryDark,
                        ),
                        label: Text(
                          'Cancelar \nSolicitud',
                          style: TextStyle(color: secondaryDark),
                        ))
                    : verifyItsFRequest(controlador1)
                        ? Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  controlador1.loading = true;
                                  controlador1.notify();
                                  await controlador1.usuario.reference
                                      .update({
                                    'amigos': FieldValue.arrayUnion(
                                        [widget.usuario.documentId])
                                  });
                                  await widget.usuario.reference.update({
                                    'amigos': FieldValue.arrayUnion(
                                        [controlador1.usuario.documentId]),
                                    'solicitudesAE': FieldValue.arrayRemove(
                                        [controlador1.usuario.documentId]),
                                  });
                                  controlador1.usuario.amigos
                                      .add(widget.usuario.documentId);
                                  controlador1.usuario.solicitudesAE
                                      .remove(widget.usuario.documentId);
                                  controlador1.loading = false;
                                  controlador1.notify();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: secondaryDark,
                                  size: 15,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  controlador1.loading = true;
                                  controlador1.notify();
                                  await widget.usuario.reference.update({
                                    'solicitudesAE': FieldValue.arrayRemove(
                                        [controlador1.usuario.documentId])
                                  });
                                  controlador1.loading = false;
                                  controlador1.notify();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: secondaryDark,
                                  size: 15,
                                ),
                              ),
                            ],
                          )
                        : verifyFriendship(controlador1)
                            ? FlatButton.icon(
                                label: Text(
                                  'Eliminar',
                                  style: TextStyle(
                                      color: secondaryDark, fontSize: 15),
                                ),
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: secondaryDark,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  controlador1.loading = true;
                                  controlador1.notify();
                                  await controlador1.usuario.reference
                                      .update({
                                    'amigos': FieldValue.arrayRemove(
                                        [widget.usuario.documentId])
                                  });
                                  await widget.usuario.reference.update({
                                    'amigos': FieldValue.arrayRemove(
                                        [controlador1.usuario.documentId])
                                  });

                                  controlador1.usuario.amigos
                                      .remove(widget.usuario.documentId);

                                  controlador1.loading = false;
                                  controlador1.notify();
                                  print('yeeeeeh');
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              )
                            : FlatButton.icon(
                                label: Text(
                                  'Agregar',
                                  style: TextStyle(
                                      color: secondaryDark, fontSize: 15),
                                ),
                                onPressed: () async {
                                  controlador1.loading = true;
                                  controlador1.notify();
                                  await controlador1.usuario.reference
                                      .update({
                                    'solicitudesAE': FieldValue.arrayUnion(
                                        [widget.usuario.documentId]),
                                  });
                                  controlador1.usuario.solicitudesAE
                                      .add(widget.usuario.documentId);
                                  print('hi');
                                  controlador1.loading = false;
                                  controlador1.notify();
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.person_add,
                                  color: secondaryDark,
                                  size: 20,
                                ),
                              ),
      ],
    );
  }

  bool verifyFriendship(Controller controlador1) {
    return widget.usuario.amigos.contains(controlador1.usuario.documentId);
  }

  bool verifyMyFRequest(Controller controlador1) {
    return controlador1.usuario.solicitudesAE
        .contains(widget.usuario.documentId);
  }

  bool verifyItsFRequest(Controller controlador1) {
    return widget.usuario.solicitudesAE
        .contains(controlador1.usuario.documentId);
  }
}

class ReportDialog extends StatefulWidget {
  const ReportDialog(
      {Key key, @required this.razones, @required this.usuarioModel})
      : super(key: key);

  final List<String> razones;
  final UsuarioModel usuarioModel;

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  bool value = false;
  List<String> razones = [];
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        return !controlador1.loading;
      },
      child: AlertDialog(
        title: Text(
          'Reportar Usuario',
          style: TextStyle(fontSize: 30),
        ),
        content: Container(
          height: 300,
          width: 500,
          child: Column(
            children: <Widget>[
              Text('Selecciona el/los motivos para reportar a este usuario:'),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.razones.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                        title: Text(
                          widget.razones[index],
                          style: TextStyle(color: Colors.white),
                        ),
                        value: razones.contains(widget.razones[index]),
                        onChanged: (val) {
                          if (val) {
                            razones.add(widget.razones[index]);
                          } else {
                            razones.remove((widget.razones[index]));
                          }
                          setState(() {});
                        });
                  }),
            ],
          ),
        ),
        actions: controlador1.loading
            ? <Widget>[CircularProgressIndicator()]
            : <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                RaisedButton(
                    child: Text('Enviar reporte'),
                    onPressed: () async {
                      if (razones.isEmpty) {
                        return;
                      }

                      controlador1.loading = true;
                      controlador1.notify();

                      await FirebaseFirestore.instance
                          .collection('reportes')
                          .add(widget.usuarioModel.toReport(razones));

                      showDialog(
                          context: context,
                          child: WillPopScope(
                            onWillPop: () async {
                              controlador1.loading = false;
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                              return !controlador1.loading;
                            },
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Estamos revisando tu reporte, si tu reporte es valido, la libreta sera eliminada en aproximadamente 24 horas',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 100,
                                  )
                                ],
                              ),
                            ),
                          ));
                    })
              ],
      ),
    );
  }
}
