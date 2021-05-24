import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:gudpets/pages/pages.dart';

class Publicaciones extends StatefulWidget {
  @override
  _PublicacionesState createState() => _PublicacionesState();
}

class _PublicacionesState extends State<Publicaciones> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return ListView(
      children: <Widget>[
        FirebaseMessage(),
        SizedBox(height: 40),
        controlador1.pestanaAct == 1
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('adopciones')
                    .where('status', isEqualTo: 'en adopcion')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Text('Cargando...'),
                    );
                  return ListView.builder(
                    itemBuilder: (context, index) => ListCard(
                        controlador1: controlador1,
                        objeto: AdopcionModel.fromDocumentSnapshot(
                            snapshot.data.documents[index]),
                        posicion: index),
                    itemCount: snapshot.data.documents.length,
                    shrinkWrap: true,
                    physics:
                        ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  );
                },
              )
            : controlador1.pestanaAct == 2
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('emergencias')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: Text('Cargando...'),
                        );
                      return ListView.builder(
                        itemBuilder: (context, index) => ListCard(
                            controlador1: controlador1,
                            objeto: EmergenciaModel.fromDocumentSnapshot(
                                snapshot.data.documents[index]),
                            posicion: index),
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(
                            parent: NeverScrollableScrollPhysics()),
                      );
                    },
                  )
                : PerdidosList(),
      ],
    );
  }
}
