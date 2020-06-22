import 'package:gudpets/shared/card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services.dart';
import 'package:gudpets/shared/shared.dart';

class CustomSearchDelegate extends SearchDelegate {
  String coleccion;
  CustomSearchDelegate(this.coleccion);

  var query1 = '';
  List<Widget> buildActions(BuildContext context) {
    return coleccion == 'adopciones' || coleccion == 'perdidos'
        ? [
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () => showDialog(context: context, child: DialogBody())
                  .whenComplete(() => buildResults(context)),
            )
          ]
        : [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        controlador1.pestanaAct = 0;
        Navigator.of(context).pushReplacementNamed('/home');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    // if (query.length < 8) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Center(
    //         child: Text(
    //           "NĂºmero de control incompleto.",
    //         ),
    //       )
    //     ],
    //   );
    // }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
// InheritedBlocs.of(context)
//       .searchBloc
//     .searchTerm
//     .add(query);
    var stream = coleccion == 'adopciones'
        ? Firestore.instance
            .collection(coleccion)
            .where('tipoAnimal',
                isEqualTo: controlador1.tipo == null
                    ? null
                    : controlador1.tipo.toLowerCase())
            .where('sexo', isEqualTo: controlador1.sexo)
            .where('titulo', isGreaterThanOrEqualTo: query)
            .where('status', isEqualTo: 'en adopcion')
            .snapshots()
        : coleccion == 'perdidos'
            ? Firestore.instance
                .collection(coleccion)
                .where('tipoAnimal',
                    isEqualTo: controlador1.tipo == null
                        ? null
                        : controlador1.tipo.toLowerCase())
                .where('sexo', isEqualTo: controlador1.sexo)
                .where('titulo', isGreaterThanOrEqualTo: query)
                .snapshots()
            : Firestore.instance
                .collection('usuarios')
                .where('nombre', isEqualTo: query.trim())
                .snapshots();

    print(query);
    return coleccion == 'adopciones' || coleccion == 'perdidos'
        ? StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.documents.length == 0) {
                return Column(
                  children: <Widget>[
                    Text(
                      "No hay mascotas con esa caracteristicas.",
                    ),
                  ],
                );
              } else {
                var results = snapshot.data.documents;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListCard(
                        controlador1: controlador1,
                        objeto: coleccion == 'adopciones'
                            ? AdopcionModel.fromDocumentSnapshot(results[index])
                            : coleccion == 'perdidos'
                                ? PerdidoModel.fromDocumentSnapshot(
                                    results[index])
                                : Container(),
                        posicion: index);
                  },
                );
              }
            },
          )
        : StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.documents.length == 0) {
                return Column(
                  children: <Widget>[
                    Text(
                      "No se encontraron resultados",
                    ),
                  ],
                );
              } else {
                List<DocumentSnapshot> documents = snapshot.data.documents;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    List<dynamic> bloqueados =
                        documents[index]['bloqueados'] ?? [];
                    String usuario = documents[index]['nombre'] ?? '';
                    if (bloqueados.contains(controlador1.usuario.nombre)) {
                      return Container();
                    }
                    if (controlador1.usuario.bloqueados.contains(usuario)) {
                      return Container();
                    }
                    return AmigoTile(
                      usuario:
                          UsuarioModel.fromDocumentSnapshot(documents[index]),
                    );
                  },
                );
              }
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

class DialogBody extends StatefulWidget {
  @override
  _DialogBodyState createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Elije tus filtros de búsqueda'),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text('Sexo:'),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                      value: controlador1.sexo,
                      onChanged: ((value) {
                        setState(() {
                          controlador1.sexo = value;
                        });
                      }),
                      items: [
                        DropdownMenuItem(
                          value: 'Hembra',
                          child: Text('Hembra'),
                        ),
                        DropdownMenuItem(
                          value: 'Macho',
                          child: Text('Macho'),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Tipo:'),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                      value: controlador1.tipo,
                      onChanged: ((value) {
                        setState(() {
                          controlador1.tipo = value;
                        });
                      }),
                      items: [
                        DropdownMenuItem(
                          value: 'Perro',
                          child: Text('Perro'),
                        ),
                        DropdownMenuItem(
                          value: 'Gato',
                          child: Text('Gato'),
                        ),
                        DropdownMenuItem(
                          value: 'Ave',
                          child: Text('Ave'),
                        ),
                        DropdownMenuItem(
                          value: 'Otro',
                          child: Text('Otro'),
                        )
                      ],
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    controlador1.notify();
                    Navigator.of(context).pop();
                  },
                  child: Text('Filtrar lista'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
