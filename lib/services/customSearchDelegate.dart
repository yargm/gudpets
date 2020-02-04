import 'package:adoption_app/shared/card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  var query1 = '';
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.tune),
        onPressed: () => showDialog(
          context: context,
          child: Dialog(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Elije tus filtros de búsqueda'),
              SizedBox(
                height: 10,
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null
              )
            ],
          )),
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
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

    return   StreamBuilder(
          stream: Firestore.instance
              .collection('adopciones')
              .where('titulo', isGreaterThanOrEqualTo: query)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.documents.length == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "Usuario no encontrado.",
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
                      objeto:
                          AdopcionModel.fromDocumentSnapshot(results[index]),
                      posicion: index);
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
