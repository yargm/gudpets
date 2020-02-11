import 'package:adoption_app/pages/rescateList.dart';
import 'package:flutter/material.dart';
import 'package:adoption_app/pages/pages.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  Controller controlador1;
  Home({this.controlador1});
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        drawer: MyDrawer(controlador1: controlador1),

        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image(
                width: 30,
                height: 30,
                image: AssetImage('assets/gudpetsfirstNoText.png'),
              ),
              SizedBox(width: 10,),
              Text('GudPets')
            ],
          ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.help),
                    onPressed: () => showDialog(
                      context: context,
                      child: SingleChildScrollView(
                                              child: FadeInImage(
                          image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/adoptionapp-8a76d.appspot.com/o/infgudpets.png?alt=media&token=e37c4267-c4ec-4d3d-8286-5c726248f15c'),
                          placeholder: AssetImage('assets/dog.png'),
                        ),
                      )
                    ),
                  ),
                controlador1.pestana_act == 0 || controlador1.pestana_act == 1
            ?   IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(
                            controlador1.pestana_act == 0
                                ? 'adopciones'
                                : controlador1.pestana_act == 1
                                    ? 'perdidos'
                                    : ''),
                      );
                    },
                    icon: Icon(Icons.search),
                  ) : Container(),
                  IconButton(
                    onPressed: () {
                      return Navigator.of(context).pushNamed('/avisos');
                      // print('avisos');
                    },
                    icon: Icon(
                      FontAwesomeIcons.bullhorn,
                      size: 20,
                    ),
                  )
                ],
              ),
        

        body: Center(
          child: _widgetOptions.elementAt(seleccionado),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controlador1.pestana_act == 0
                ? controlador1.usuario.fotoINE != null
                    ? Navigator.of(context).pushNamed('/registro_adopcion')
                    : showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('No puedes realizar una publicación en esta sección.'),
                              content: Text(
                                  'Para realizar una publicación es necesario completar tu información.'),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    return Navigator.of(context)
                                        .pushNamed('/perfil');
                                  },
                                  child: Text('IR A PERFIL'),
                                )
                              ],
                            ))
                : controlador1.pestana_act == 1
                    ? Navigator.of(context).pushNamed('/registro_perdido')
                    : controlador1.pestana_act == 2
                        ? Navigator.of(context).pushNamed('/registro_rescate')
                        : Navigator.of(context)
                            .pushNamed('/registro_emergencia');
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
      ),
    );
  }
}
