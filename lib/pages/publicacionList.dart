import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:adoption_app/shared/shared.dart';

class PublicacionList extends StatefulWidget {
  @override
  _PublicacionListState createState() => _PublicacionListState();
}

class _PublicacionListState extends State<PublicacionList> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    String tabla;

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
                    'Tus Publicaciones',
                    style: TextStyle(fontSize: 30),
                  ),
                ),

                //PESTAÑA DE ADOPCIONES
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('adopciones')
                      .where('userId',
                          isEqualTo: controlador1.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    return snapshot.data.documents.isNotEmpty
                        ? ExpansionTile(
                            title: Text('Adopciones',
                                style: TextStyle(fontSize: 30)),
                            leading: Icon(FontAwesomeIcons.home),
                            children: <Widget>[
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents[index]
                                          ['titulo']),
                                      leading: Hero(
                                        tag: snapshot
                                            .data.documents[index].documentID,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool favorito = _favorito(
                                                snapshot.data.documents[index]
                                                    ['favoritos'],
                                                controlador1);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Adopcion(
                                                favorito: favorito,
                                                objeto: AdopcionModel
                                                    .fromDocumentSnapshot(
                                                        snapshot.data
                                                            .documents[index]),
                                              );
                                            }));
                                          },
                                          child: Image(
                                            width: 40,
                                            height: 40,
                                            image: NetworkImage(snapshot
                                                .data.documents[index]['foto']),
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            tabla = 'adopciones';
                                          });
                                          _myshowDialog(
                                              context,
                                              snapshot.data.documents[index],
                                              tabla);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          )
                        : Container();
                  },
                ),

                //PESTAÑA DE PERDIDOS
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('perdidos')
                      .where('userId',
                          isEqualTo: controlador1.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    return snapshot.data.documents.isNotEmpty
                        ? ExpansionTile(
                            title: Text('Perdidos',
                                style: TextStyle(fontSize: 30)),
                            leading: Icon(FontAwesomeIcons.searchLocation),
                            children: <Widget>[
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents[index]
                                          ['titulo']),
                                      leading: Hero(
                                        tag: snapshot
                                            .data.documents[index].documentID,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool favorito = _favorito(
                                                snapshot.data.documents[index]
                                                    ['favoritos'],
                                                controlador1);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Perdido(
                                                favorito: favorito,
                                                objeto: PerdidoModel
                                                    .fromDocumentSnapshot(
                                                        snapshot.data
                                                            .documents[index]),
                                              );
                                            }));
                                          },
                                          child: Image(
                                            width: 40,
                                            height: 40,
                                            image: NetworkImage(snapshot
                                                .data.documents[index]['foto']),
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            tabla = 'perdidos';
                                          });
                                          _myshowDialog(
                                              context,
                                              snapshot.data.documents[index],
                                              tabla);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          )
                        : Container();
                  },
                ),

                //PESTAÑA DE RESCATES
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('rescates')
                      .where('userId',
                          isEqualTo: controlador1.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    return snapshot.data.documents.isNotEmpty
                        ? ExpansionTile(
                            title: Text('Rescates',
                                style: TextStyle(fontSize: 30)),
                            leading: Icon(FontAwesomeIcons.handHoldingHeart),
                            children: <Widget>[
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents[index]
                                          ['titulo']),
                                      leading: Hero(
                                        tag: snapshot
                                            .data.documents[index].documentID,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool favorito = _favorito(
                                                snapshot.data.documents[index]
                                                    ['favoritos'],
                                                controlador1);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Rescate(
                                                favorito: favorito,
                                                objeto: RescateModel
                                                    .fromDocumentSnapshot(
                                                        snapshot.data
                                                            .documents[index]),
                                              );
                                            }));
                                          },
                                          child: Image(
                                            width: 40,
                                            height: 40,
                                            image: NetworkImage(snapshot
                                                .data.documents[index]['foto']),
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            tabla = 'rescates';
                                          });
                                          _myshowDialog(
                                              context,
                                              snapshot.data.documents[index],
                                              tabla);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          )
                        : Container();
                  },
                ),

                //PESTAÑA DE EMERGENCIAS
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('emergencias')
                      .where('userId',
                          isEqualTo: controlador1.usuario.documentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    return snapshot.data.documents.isNotEmpty
                        ? ExpansionTile(
                            title: Text('Emergencias',
                                style: TextStyle(fontSize: 30)),
                            leading: Icon(FontAwesomeIcons.ambulance),
                            children: <Widget>[
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents[index]
                                          ['titulo']),
                                      leading: Hero(
                                        tag: snapshot
                                            .data.documents[index].documentID,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool favorito = _favorito(
                                                snapshot.data.documents[index]
                                                    ['favoritos'],
                                                controlador1);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Emergencia(
                                                favorito: favorito,
                                                objeto: EmergenciaModel
                                                    .fromDocumentSnapshot(
                                                        snapshot.data
                                                            .documents[index]),
                                              );
                                            }));
                                          },
                                          child: Image(
                                            width: 40,
                                            height: 40,
                                            image: NetworkImage(snapshot
                                                .data.documents[index]['foto']),
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            tabla = 'emergencias';
                                          });
                                          _myshowDialog(
                                              context,
                                              snapshot.data.documents[index],
                                              tabla);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.delete,
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

  _myshowDialog(context, dynamic objeto, String tabla) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Borrarás la publicación'),
          content: Text(
              'Los datos de esta publicación no podrán restausarse en el futuro'),
          actions: <Widget>[
            FlatButton(
              child: Text('Borrar'),
              onPressed: () async {

                await FirebaseStorage.instance
                    .ref()
                    .child(objeto['reffoto'])
                    .delete()
                    .catchError((onError) {
                  print(onError);
                });

                if (tabla == 'rescates' || tabla == 'adopciones') {
                  for (var elemento in objeto['albumrefs']) {
                    await FirebaseStorage.instance
                        .ref()
                        .child(elemento)
                        .delete()
                        .catchError((onError) {
                      print('error en album ref');
                    });
                  }
                }

                await Firestore.instance
                    .collection(tabla)
                    .document(objeto.documentID)
                    .delete().catchError((onError) {
                      print('error en base de datos');
                    });

                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ));
  }

  _favorito(dynamic favoritobjeto, Controller controlador1) {
    bool favorito = false;
    for (var usuario in favoritobjeto) {
      setState(() {
        if (controlador1.usuario.documentId == usuario) {
          favorito = true;
        } else {
          favorito = false;
        }
      });
    }
    
    return favorito;
  }
}
