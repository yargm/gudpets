import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/shared/shared.dart';

class InteresadosAdopcion extends StatefulWidget {
  @override
  _InteresadosAdopcionState createState() => _InteresadosAdopcionState();
}

class _InteresadosAdopcionState extends State<InteresadosAdopcion> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                  trailing: Icon(
                    FontAwesomeIcons.userFriends,
                    color: Colors.pink,
                  ),
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  title: FittedBox(
                    child: Text(
                      'Personas Interesadas',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: Firestore.instance.collection('usuarios').snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData)
                    return Center(child: CircularProgressIndicator(),);
                    return ListView(
                     physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                     shrinkWrap: true,
                     children: <Widget>[
                       interesadosLista(
                        titulo: 'Adopciones',
                        iconData: Icons.home,
                       )

                     ],
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

Widget interesadosLista({String titulo, IconData iconData}) {
  return ExpansionTile(
    leading: Icon(iconData),
    title: Text(titulo),
    children: <Widget>[
      Text('data'),
      Text('data'),
      Text('data'),
    ],
  );
}
