import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class RescateList extends StatefulWidget {
  @override
  _RescateListState createState() => _RescateListState();
}

class _RescateListState extends State<RescateList> {
  var rescates = Firestore.instance.collection('rescates').snapshots();

  @override
  Widget build(BuildContext context) {
     Controller controlador1 = Provider.of<Controller>(context);
    return ListView(
      children: <Widget>[
        SizedBox(height: 40),
        StreamBuilder(
          stream: rescates,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text('Cargando...'),
              );
            return ListView.builder(
              itemBuilder: (context, index) => ListCard(
                  controlador1: controlador1,
                  objeto: RescateModel.fromDocumentSnapshot(
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
