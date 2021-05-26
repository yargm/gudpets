import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class PerdidosList extends StatefulWidget {
  @override
  _PerdidosListState createState() => _PerdidosListState();
}

class _PerdidosListState extends State<PerdidosList> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('perdidos').snapshots(),
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
    );
  }
}
