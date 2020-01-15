import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class EmergenciaList extends StatefulWidget {
  @override
  _EmergenciaListState createState() => _EmergenciaListState();
}

class _EmergenciaListState extends State<EmergenciaList> {
  var emergencias = Firestore.instance.collection('emergencias').snapshots();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 40),
        StreamBuilder(
          stream: emergencias,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando...');
            return ListView.builder(
              itemBuilder: (context, index) => ListCard(
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
