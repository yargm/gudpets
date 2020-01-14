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
      body: Center(
        child: _widgetOptions.elementAt(seleccionado),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Adopcion'),
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Perdidos'),
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Rescates'),
            backgroundColor: Colors.grey,
           ),
           BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('Emergencias'),
            backgroundColor: Colors.grey,
           ),
        ],
        currentIndex: seleccionado,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
