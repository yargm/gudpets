import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class AvisosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    var avisos = Firestore.instance.collection('avisos').snapshots();
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
