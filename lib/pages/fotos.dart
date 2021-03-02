import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';

class FotosPrincipal extends StatefulWidget {
  @override
  _FotosPrincipalState createState() => _FotosPrincipalState();
}

class _FotosPrincipalState extends State<FotosPrincipal> {
  bool contenido = false;
  int queryprincipal;
  var query;

  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    List<String> amigos = controlador1.usuario.amigos;
    // Future<List<DocumentSnapshot>> posts(
    //     List<DocumentSnapshot> documents) async {
    //   List<DocumentSnapshot> posts1 = [];
    //   List<DocumentSnapshot> posts2 = [];
    //   documents.forEach((element) {
    //     UsuarioModel amigo = UsuarioModel.fromDocumentSnapshot(element, 'ok');
    //     Stream<QuerySnapshot> posts =
    //         amigo.reference.collection('posts').snapshots();

    //     posts.forEach((element) {
    //       posts1 = element.documents;

    //       posts1.forEach((element) {
    //         posts2.add(element);
    //         print(posts2);
    //         PostsModel pos = PostsModel.fromDocumentSnapshot(element);
    //         print(pos.descripcion);
    //       });

    //       print(element.documents);
    //     });

    //     print('${element['correo']} estoy dentro de el future posts');
    //   });
    //   return posts2;
    // }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text('Amigos'),
                    Switch(
                      value: contenido,
                      onChanged: (bool valor) {
                        setState(() {
                          contenido = valor;
                        });
                      },
                      activeColor: secondaryDark,
                    ),
                    Text('Amigos y Más'),
                  ],
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     PopupMenuButton(
                //       elevation: 8,
                //       padding: EdgeInsets.all(8),
                //       offset: Offset.zero,
                //       onCanceled: () {
                //         print("You have canceled the menu.");
                //       },
                //       onSelected: (value) {
                //         print(value);
                //         if (value == 1) {
                //           queryprincipal = 1;
                //           setState(() {});
                //         } else if (value == 2) {
                //           queryprincipal = 2;
                //           setState(() {});
                //         } else if (value == 3) {
                //           queryprincipal = 3;
                //           setState(() {});
                //         } else if (value == 4) {
                //           queryprincipal = 4;
                //         }
                //       },
                //       icon: Icon(
                //         FontAwesomeIcons.sortAmountDownAlt,
                //         color: secondaryDark,
                //       ),
                //       itemBuilder: (context) => [
                //         PopupMenuItem(
                //           value: 1,
                //           child: Text("Nuevas"),
                //         ),
                //         PopupMenuItem(
                //           value: 2,
                //           child: Text("Más antigua"),
                //         ),
                //         PopupMenuItem(
                //           value: 3,
                //           child: Text("Me gusta"),
                //         ),
                //         // PopupMenuItem(
                //         //   value: 4,
                //         //   child: Text("Tipo de Máscota"),
                //         // ),
                //       ],
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(left: 5, right: 10),
                //       child: Text('Ordenar por'),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collectionGroup('posts')
                .orderBy('fecha', descending: true)
                .snapshots(),
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
              List<DocumentSnapshot> listaver = [];

              contenido
                  ? documents.forEach((element) {
                      if (controlador1.usuario.amigos
                          .contains(element['userId'])) {
                        listaver.add(element);

                        print(element['userId']);
                      } else if (element['userId'] ==
                          controlador1.usuario.documentId) {
                        listaver.add(element);
                        print('soy io');
                      } else if (element['privacidad'] == true) {
                        listaver.add(element);
                      }
                    })
                  : documents.forEach((element) {
                      if (controlador1.usuario.amigos
                          .contains(element['userId'])) {
                        listaver.add(element);

                        print(element['userId']);
                      } else if (element['userId'] ==
                          controlador1.usuario.documentId) {
                        listaver.add(element);
                        print('soy io');
                      }
                      //  else if (element['privacidad'] == true) {
                      //   listaver.add(element);
                      // }
                    });
              print(listaver);
              print(documents);
              //print(documents.length);

              return listaver.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text('No hay fotos para mostrar'),
                    )
                  : ListView.builder(
                      physics:
                          ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: listaver.length,
                      itemBuilder: (context, index) {
                        PostsModel post =
                            PostsModel.fromDocumentSnapshot(listaver[index]);
                        bool fav = post.favoritos
                            .contains(controlador1.usuario.documentId);
                        return Fotos(
                          post: post,
                          controlador1: controlador1,
                          fav: fav,
                        );

                        // Card(
                        //   child: Column(
                        //     children: <Widget>[
                        //       Text(post.descripcion),
                        //       FadeInImage(
                        //         fit: BoxFit.contain,
                        //         placeholder: AssetImage('assets/dog.png'),
                        //         width: double.maxFinite,
                        //         height: 350,
                        //         image: NetworkImage(post.foto),
                        //       )
                        //     ],
                        //   ),
                        // );
                      },
                    );

              // FutureBuilder<List<DocumentSnapshot>>(
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Center(child: CircularProgressIndicator());
              //     }

              //     return snapshot.data.isEmpty
              //         ? Center(
              //             child: Text('No hay resultados'),
              //           )
              //         : ListView.builder(
              //             itemBuilder: (context, index) {
              //               PostsModel post = PostsModel.fromDocumentSnapshot(
              //                   snapshot.data[index]);
              //               print(post.descripcion);
              //             },
              //             itemCount: snapshot.data.length,
              //             shrinkWrap: true,
              //             physics:
              //                 ScrollPhysics(parent: NeverScrollableScrollPhysics()),
              //           );
              //   },
              //   future: posts(documents),
              // );
            },
          ),
        ],
      ),
    );
  }
}
