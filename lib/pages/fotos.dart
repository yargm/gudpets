import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';

class FotosPrincipal extends StatelessWidget {
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: Firestore.instance.collectionGroup('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: Container(
                  height: 40, child: const CircularProgressIndicator()),
            );
          List<DocumentSnapshot> documents = snapshot.data.documents;
          // bool amigo = amigos.contains(widget.usuario.documentId);
          // if (amigo) {
          //   print('amix');
          // } else {
          //   print('enemix');
          // }
          print(documents);
          print(documents.length);
          return documents.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text('No hay fotos para mostrar'),
                )
              : ListView.builder(
                  physics:
                      ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                  
                    PostsModel post =
                        PostsModel.fromDocumentSnapshot(documents[index]);
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Text(post.descripcion),
                          FadeInImage(
                            fit: BoxFit.contain,
                            placeholder: AssetImage('assets/dog.png'),
                            width: double.maxFinite,
                            height: 350,
                            image: NetworkImage(post.foto),
                          )
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
