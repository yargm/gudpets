import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class AvisosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var avisos = Firestore.instance.collection('avisos').snapshots();
    // TODO: implement build
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('Avisos'),
    
      ),
      body: SingleChildScrollView(
        child: Container(
            color: primaryColor,
            child: StreamBuilder(
              stream: avisos,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Text('Cargando...'),
                  );
                return ListView.builder(
                  itemBuilder: (context, index) => AvisosCard(
                      objeto: AvisoModel.fromDocumentSnapshot(
                          snapshot.data.documents[index])),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  physics:
                      ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                );
              },
            )),
      ),
    );
  }
}
