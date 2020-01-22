import 'package:adoption_app/pages/rescateList.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'sign_in.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage(controlador1.usuario.foto ?? ''),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Text(controlador1.usuario.nombre,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryText,
                            fontSize: 20)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: secondaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                print('perfil');
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.history),
              title: Text('Mis publicaciones'),
              onTap: () {
                print('publicaciones');
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.solidHeart),
              title: Text('Favoritos'),
              onTap: () {
                print('favoritos');
              },
            ),
            ListTile(
              title: Text('Cerrar sesión'),
              leading: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onTap: () async {
                signOutGoogle();
                await controlador1.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
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
                      ? print('ir a registro rescate')
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
