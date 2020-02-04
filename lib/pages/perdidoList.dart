import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class PerdidoList extends StatefulWidget {
  @override
  _PerdidoListState createState() => _PerdidoListState();
}

class _PerdidoListState extends State<PerdidoList> {
  var perdidos = Firestore.instance.collection('perdidos').snapshots();

  @override
  Widget build(BuildContext context) {
     Controller controlador1 = Provider.of<Controller>(context);
    return ListView(
      children: <Widget>[
        SizedBox(height: 40),
        StreamBuilder(
          stream: perdidos,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text('Cargando...'),
              );
            return ListView.builder(
              itemBuilder: (context, index) => ListCard(
                controlador1: controlador1,
                  objeto: PerdidoModel.fromDocumentSnapshot(
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
