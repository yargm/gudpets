import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/shared/shared.dart';

class FavoritosList extends StatefulWidget {
  @override
  _FavoritosListState createState() => _FavoritosListState();
}

class _FavoritosListState extends State<FavoritosList> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return Scaffold(
      // appBar: AppBar(
      //    leading: IconButton(
      //     onPressed: () => Navigator.of(context).pop(),
      //     icon: Icon(Icons.arrow_back_ios),
      //   ),
      //   // centerTitle: true,
      //   // actions: <Widget>[
      //   //   Icon(Icons.favorite, color: Colors.pink,),
      //   //   SizedBox(width: 30,)
      //   // ],
      //   backgroundColor: Colors.transparent,
      //   // title: Text(
      //   //   'Tus Favoritos',
      //   //   style: TextStyle(fontSize: 30),
      //   // ),
      // ),
      extendBodyBehindAppBar: true,
      body: Card(
        margin: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 15),
        child: Container(
          height: double.maxFinite,
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  trailing: Hero(
                    tag: 'favoritos',
                    child: Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      controlador1.pestanaAct = 0;
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: secondaryColor,
                    ),
                  ),
                  title: Text(
                    'Tus Favoritos',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                StreamBuilder(
                  stream: controlador1.usuario.reference.get().asStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    return ListView(
                      physics:
                          ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      shrinkWrap: true,
                      children: <Widget>[
                        snapshot.data['adopciones'] != null &&
                                snapshot.data['adopciones'].isNotEmpty
                            ? favoriteTile(
                                titulo: 'Adopciones',
                                iconData: Icons.home,
                                list: snapshot.data['adopciones'],
                                controlador1: controlador1)
                            : Container(),
                        snapshot.data['perdidos'] != null &&
                                snapshot.data['perdidos'].isNotEmpty
                            ? favoriteTile(
                                titulo: 'Perdidos',
                                iconData: FontAwesomeIcons.searchLocation,
                                list: snapshot.data['perdidos'],
                                controlador1: controlador1)
                            : Container(),
                        snapshot.data['rescates'] != null &&
                                snapshot.data['rescates'].isNotEmpty
                            ? favoriteTile(
                                titulo: 'Rescates',
                                iconData: FontAwesomeIcons.handHoldingHeart,
                                list: snapshot.data['rescates'],
                                controlador1: controlador1)
                            : Container(),
                        snapshot.data['emergencias'] != null &&
                                snapshot.data['emergencias'].isNotEmpty
                            ? favoriteTile(
                                titulo: 'Emergencias',
                                iconData: FontAwesomeIcons.ambulance,
                                list: snapshot.data['emergencias'],
                                controlador1: controlador1)
                            : Container()
                      ],
                    );
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collectionGroup('posts')
                      .where('favoritos',
                          arrayContains: controlador1.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    print(snapshot);
                    if (!snapshot.hasData && snapshot != null)
                      return Container();

                    List<DocumentSnapshot> documents = snapshot.data.documents;
                    print(documents);
                    print('holaaaaaaaaaaaaaaaaaaa');
                    return documents.isNotEmpty && documents != null
                        ? ExpansionTile(
                            leading: Icon(FontAwesomeIcons.cameraRetro),
                            title: Text(
                              'Posts',
                              style: TextStyle(fontSize: 30),
                            ),
                            children: <Widget>[
                              ListView.builder(
                                  itemCount: documents.length,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  itemBuilder: (context, index) {
                                    PostsModel post =
                                        PostsModel.fromDocumentSnapshot(
                                            documents[index]);
                                    return ListTile(
                                      title: Text(post.descripcion),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          await post.reference.update({
                                            'favoritos':
                                                FieldValue.arrayRemove([
                                              controlador1.usuario.documentId
                                            ]),
                                          });
                                          if (post.numlikes != 0) {
                                            post.reference.update({
                                              'numlikes': post.numlikes - 1
                                            });
                                          }

                                          controlador1.notify();
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Colors.pink,
                                        ),
                                      ),
                                      leading: Hero(
                                        tag: post.documentId,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // var query = await Firestore.instance
                                            //     .collection(titulo.toLowerCase())
                                            //     .document(list[index]['documentId'])
                                            //     .get();
                                            // switch (titulo) {
                                            //   case 'Adopciones':
                                            //     Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //         builder: (context) => Adopcion(
                                            //           objeto: AdopcionModel.fromDocumentSnapshot(query),
                                            //         ),
                                            //       ),
                                            //     );
                                            //     break;
                                            //   case 'Perdidos':
                                            //     Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //         builder: (context) => Perdido(
                                            //           objeto: PerdidoModel.fromDocumentSnapshot(query),
                                            //         ),
                                            //       ),
                                            //     );
                                            //     break;
                                            //   case 'Rescates':
                                            //     Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //         builder: (context) => Rescate(
                                            //           objeto: RescateModel.fromDocumentSnapshot(query),
                                            //         ),
                                            //       ),
                                            //     );
                                            //     break;

                                            //   case 'Emergencias':
                                            //     Navigator.of(context).push(
                                            //       MaterialPageRoute(
                                            //         builder: (context) => Emergencia(
                                            //           objeto: EmergenciaModel.fromDocumentSnapshot(query),
                                            //           favorito: true,
                                            //         ),
                                            //       ),
                                            //     );
                                            //     break;
                                            // }
                                          },
                                          child: Image(
                                            width: 40,
                                            height: 40,
                                            image: NetworkImage(post.foto),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget favoriteTile(
      {String titulo,
      IconData iconData,
      List<dynamic> list,
      Controller controlador1}) {
    return ExpansionTile(
      leading: Icon(iconData),
      title: Text(
        titulo,
        style: TextStyle(fontSize: 30),
      ),
      children: <Widget>[
        ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          itemBuilder: (context, index) => ListTile(
            title: Text(list[index]['titulo']),
            trailing: IconButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(titulo.toLowerCase())
                    .doc(list[index]['documentId'])
                    .update({
                  'favoritos':
                      FieldValue.arrayRemove([controlador1.usuario.documentId]),
                });
                await controlador1.usuario.reference.update(
                  {
                    titulo.toLowerCase(): FieldValue.arrayRemove([list[index]])
                  },
                );
                setState(() {});
              },
              icon: Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
            ),
            leading: Hero(
              tag: list[index]['documentId'],
              child: GestureDetector(
                onTap: () async {
                  var query = await FirebaseFirestore.instance
                      .collection(titulo.toLowerCase())
                      .doc(list[index]['documentId'])
                      .get();
                  switch (titulo) {
                    case 'Adopciones':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Adopcion(
                            objeto: AdopcionModel.fromDocumentSnapshot(query),
                          ),
                        ),
                      );
                      break;
                    case 'Perdidos':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Perdido(
                            objeto: PerdidoModel.fromDocumentSnapshot(query),
                          ),
                        ),
                      );
                      break;
                    case 'Rescates':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Rescate(
                            objeto: RescateModel.fromDocumentSnapshot(query),
                          ),
                        ),
                      );
                      break;

                    case 'Emergencias':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Emergencia(
                            objeto: EmergenciaModel.fromDocumentSnapshot(query),
                            favorito: true,
                          ),
                        ),
                      );
                      break;
                  }
                },
                child: Image(
                  width: 40,
                  height: 40,
                  image: NetworkImage(list[index]['imagen']),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
