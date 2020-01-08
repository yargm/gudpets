import 'package:flutter/material.dart';
import 'animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var animales = Firestore.instance.collection('animales').snapshots();

  Widget _categoria(bool _isSelected, String categoria) {
    return GestureDetector(
      onTap: () => print('Seleccionó $categoria'),
      child: Container(
          margin: EdgeInsets.all(10.0),
          width: 80.0,
          decoration: BoxDecoration(
            color: _isSelected ? Colors.pinkAccent : Color(0xFFF8F2F7),
            borderRadius: BorderRadius.circular(20.0),
            border: _isSelected
                ? Border.all(width: 8.0, color: Color(0xFFFED8D3))
                : null,
          ),
          child: Center(
            child: Text(categoria,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 40.0, top: 40.0),
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                child: ClipOval(
                  child: Image(
                    height: 40.0,
                    width: 40.0,
                    image: NetworkImage(
                        'https://scontent.ftgz1-1.fna.fbcdn.net/v/t1.0-9/24796594_993022367517088_855613380982196329_n.jpg?_nc_cat=105&_nc_oc=AQn2hHkDWmh1UOiL8kx14dN_rzK2gYKdX3s1WSozLdz7A8v6fleVrxHVfGzCVSfEhdtH9SUvUQGGHds7g4IqJhHm&_nc_ht=scontent.ftgz1-1.fna&oh=2c209387fcede73bbc56e2ce84c35a46&oe=5E4E1518'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
                height: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(
                      width: 40.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () => print('Filtros'),
                        icon: Icon(
                          Icons.search,
                          size: 35.0,
                        ),
                      ),
                    ),
                    _categoria(true, 'Perros'),
                    _categoria(false, 'Gatos'),
                    _categoria(false, 'Aves'),
                    _categoria(false, 'Otros'),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            StreamBuilder(
              stream: animales,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Cargando...');
                return ListView.builder(
                  itemBuilder: (context, index) => Animal(
                      objeto: AnimalModel.fromDocumentSnapshot(
                          snapshot.data.documents[index])),
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  physics:
                      ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                );
              },
            ),
          ],
        ));
  }
}
