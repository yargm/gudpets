import 'package:gudpets/pages/rescateList.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  final Controller controlador1;
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
      controlador1.pestanaAct = index;
      print('Estoy en : ' + controlador1.pestanaAct.toString());
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    seleccionado = controlador1.pestanaAct;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        drawer: MyDrawer(controlador1: controlador1),
        appBar: AppBar(
          title: FittedBox(
            child: Row(
              children: <Widget>[
                Image(
                  width: 30,
                  height: 30,
                  image: AssetImage('assets/gudpetsfirstNoText.png'),
                ),
                SizedBox(
                  width: 10,
                ),
                Text('GudPets')
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () => showDialog(
                context: context,
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onDoubleTap: () => Navigator.of(context).pop(),
                    child: FadeInImage(
                      image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/adoptionapp-8a76d.appspot.com/o/infgudpets.png?alt=media&token=e37c4267-c4ec-4d3d-8286-5c726248f15c'),
                      placeholder: AssetImage('assets/dog.png'),
                    ),
                  ),
                ),
              ),
            ),
            controlador1.pestanaAct == 0 || controlador1.pestanaAct == 1
                ? IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(
                            controlador1.pestanaAct == 0
                                ? 'adopciones'
                                : controlador1.pestanaAct == 1
                                    ? 'perdidos'
                                    : ''),
                      );
                    },
                    icon: Icon(Icons.search),
                  )
                : Container(),
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
          mini: true,
          onPressed: () {
            controlador1.pestanaAct == 0
                ? Navigator.of(context).pushNamed('/registro_adopcion')
                   
                : controlador1.pestanaAct == 1
                    ? Navigator.of(context).pushNamed('/registro_perdido')
                    : controlador1.pestanaAct == 2
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
              title: Text('Adopción'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.searchLocation),
              title: Text('Perdidos'),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(FontAwesomeIcons.handHoldingHeart),
            //   title: Text('Rescates'),
            // ),
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
