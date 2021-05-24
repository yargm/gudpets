import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                    onPressed: () => Navigator.of(context).pushNamed('/home'),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  title: Text(
                    'Tus Publicaciones',
                    style: TextStyle(fontSize: 30),
                  ),
                ),

                //PESTAÑA DE ADOPCIONES
                StreamBuilder(
                  stream: FirebaseFirestore.instance
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
                                            image: NetworkImage(snapshot.data
                                                .documents[index]['album'][0]),
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
                  stream: FirebaseFirestore.instance
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
                                            image: NetworkImage(snapshot.data
                                                .documents[index]['album'][0]),
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
                //PESTAÑA DE EMERGENCIAS
                StreamBuilder(
                  stream: FirebaseFirestore.instance
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
                                            image: NetworkImage(snapshot.data
                                                .documents[index]['album'][0]),
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
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Borrarás la publicación'),
            content: Text(
                'Los datos de esta publicación no podrán restaurarse en el futuro'),
            actions: <Widget>[
              FlatButton(
                child: Text('Borrar'),
                onPressed: () {
                  deleteData(tabla, objeto);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  deleteData(String tabla, dynamic objeto) async {
    for (var elemento in objeto['albumrefs']) {
      await FirebaseStorage.instance
          .ref()
          .child(elemento)
          .delete()
          .catchError((onError) {
        print('error en album ref');
      });
    }

    await FirebaseFirestore.instance
        .collection(tabla)
        .doc(objeto.documentID)
        .delete()
        .catchError((onError) {
      print('error en base de datos');
    });
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
