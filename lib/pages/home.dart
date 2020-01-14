import 'package:adoption_app/pages/rescateList.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int seleccionado = 0;

  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Adopción',
    ),
    Text(
      'Perdidos',
    ),
    RescateList(),
    EmergenciaList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      seleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('avisos');
              //Ir a avisos
            },
            icon: Icon(Icons.warning, color: Colors.black),
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: _widgetOptions.elementAt(seleccionado),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Adopcion'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Perdidos'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Rescates'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Emergencias'),
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: seleccionado,
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
    );
  }
}
