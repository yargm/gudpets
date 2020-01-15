import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class AdopcionList extends StatefulWidget {
  @override
  _AdopcionListState createState() => _AdopcionListState();
}

class _AdopcionListState extends State<AdopcionList> {
  var adopciones = Firestore.instance.collection('adopciones').snapshots();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 40),
        StreamBuilder(
          stream: adopciones,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando...');
            return ListView.builder(
              itemBuilder: (context, index) => ListCard(
                  objeto: AdopcionModel.fromDocumentSnapshot(
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
