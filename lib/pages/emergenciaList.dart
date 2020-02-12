import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class EmergenciaList extends StatefulWidget {
  @override
  _EmergenciaListState createState() => _EmergenciaListState();
}

class _EmergenciaListState extends State<EmergenciaList> {
  var emergencias = Firestore.instance.collection('emergencias').snapshots();

  @override
  Widget build(BuildContext context) {
     Controller controlador1 = Provider.of<Controller>(context);
    return ListView(
      children: <Widget>[
        SizedBox(height: 40),
        StreamBuilder(
          stream: emergencias,
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
              physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            );
          },
        ),
      ],
    );
  }
}
