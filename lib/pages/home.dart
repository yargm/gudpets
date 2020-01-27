import 'package:adoption_app/pages/rescateList.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int seleccionado = 0;

  List<Widget> _widgetOptions = <Widget>[
    AdopcionList(),
    PerdidoList(),
    RescateList(),
    EmergenciaList(),
  ];

  _onItemTapped(int index, Controller controlador1) {
    setState(() {
      seleccionado = index;
      controlador1.pestana_act = index;
      print('Estoy en : ' + controlador1.pestana_act.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    // TODO: implement build
    return Scaffold(
      drawer: MyDrawer(controlador1: controlador1),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              return Navigator.of(context).pushNamed('/avisos');
              // print('avisos');
            },
            icon: Icon(FontAwesomeIcons.bullhorn),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(seleccionado),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controlador1.pestana_act == 0
              ? print(' ir a registro adopcion')
              : controlador1.pestana_act == 1
                  ? print('ir a registro perdido')
                  : controlador1.pestana_act == 2
                      ? Navigator.of(context).pushNamed('/registro_rescate')
                      : Navigator.of(context).pushNamed('/registro_emergencia');
        },
        child: Icon(Icons.add, color: primaryLight),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedItemColor: primaryDark,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            title: Text('Adopcion'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.searchLocation),
            title: Text('Perdidos'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.handHoldingHeart),
            title: Text('Rescates'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.ambulance),
            title: Text('Emergencias'),
          ),
        ],
        currentIndex: seleccionado,
        selectedItemColor: Colors.brown,
        onTap: (int index) {
          _onItemTapped(index, controlador1);
        },
      ),
    );
  }
}
