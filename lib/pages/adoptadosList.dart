import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:adoption_app/pages/pages.dart';

class AdoptadosList extends StatefulWidget {
  @override
  _AdoptadosListState createState() => _AdoptadosListState();
}

class _AdoptadosListState extends State<AdoptadosList> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    var adoptados =
        controlador1.usuario.reference.collection('adoptados').snapshots();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis adopciones'),
      ),
      body: Card(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: adoptados,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Cargando...',style: TextStyle(fontSize: 30),));
                }

                if (snapshot.data.documents.length == 0) {
                  return Center(
                                      child: Text(
                      'No haz realizado ninguna adopción.',style: TextStyle(fontSize: 20),
                    ),
                  );
                }

                return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Adopcion(
                                    favorito: null,
                                    objeto: AdopcionModel.fromDocumentSnapshot(
                                        snapshot.data.documents[index]),
                                  )));
                        },
                        child: ListTile(
                          title: Text(
                            snapshot.data.documents[index]['titulo'],
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            'Edad: ' + snapshot.data.documents[index]['edad'],
                          ),
                          leading: Hero(
                              tag: snapshot.data.documents[index].documentID,
                              child: Image(
                                width: 40,
                                height: 40,
                                image: NetworkImage(
                                    snapshot.data.documents[index]['foto']),
                              )
                              ),
                              trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    });
              },
            ),
          ),
        ),
      ),
    );
  }
}
