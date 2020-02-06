import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class AdopcionList extends StatefulWidget {
  @override
  _AdopcionListState createState() => _AdopcionListState();
}

class _AdopcionListState extends State<AdopcionList> {
  var adopciones = Firestore.instance.collection('adopciones').where('status',isEqualTo: 'en adopcion' ).snapshots();

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return ListView(
      children: <Widget>[
        FirebaseMessage(),
        SizedBox(height: 40),
        StreamBuilder(
          stream: adopciones,
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
              physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
            );
          },
        ),
      ],
    );
  }
}
