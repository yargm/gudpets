import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/pages/pages.dart';

class SolicitudAdopcion extends StatefulWidget {
  final DocumentReference docId;
  SolicitudAdopcion({this.docId});

  @override
  _SolicitudAdopcionState createState() => _SolicitudAdopcionState();
}

class _SolicitudAdopcionState extends State<SolicitudAdopcion> {
  get docId => null;

  @override
  Widget build(BuildContext context) {
    var query = widget.docId.collection('solicitudes').snapshots();

    return Scaffold(
      body: Card(
        margin: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 15),
        child: Container(
          height: double.maxFinite,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  title: Text(
                    'Solicitudes',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                StreamBuilder(
                  stream: query,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return ListView.builder(
                      physics:
                          ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemBuilder: (contex, index) => SolicitudAdopcionVista(
                          objeto: SolicitudModel.fromDocumentSnapshot(
                              snapshot.data.documents[index])),
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
