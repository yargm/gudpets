import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class AdopcionList extends StatefulWidget {
  @override
  _AdopcionListState createState() => _AdopcionListState();
}

class _AdopcionListState extends State<AdopcionList> {
  var adopciones = FirebaseFirestore.instance
      .collection('adopciones')
      .where('status', isEqualTo: 'en adopcion')
      .snapshots();

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      Controller controller = Provider.of<Controller>(context, listen: false);
      await controller.getLocation(context);
      await controller.getAddress(context, true);
      await controller.setAddress();
    });
  }

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
