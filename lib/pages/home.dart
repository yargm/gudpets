import 'dart:io';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:image_editor_pro/image_editor_pro.dart';

class Home extends StatefulWidget {
  final Controller controlador1;
  Home({this.controlador1});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final navigatorKey = GlobalKey<NavigatorState>();
  int seleccionado = 0;
  bool dialVisible = true;
  File _image;

  List<Widget> _widgetOptions = <Widget>[
    AdopcionList(),
    PerdidoList(),
    FotosPrincipal(),
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

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  // Future getimageditor(context) async {
  //   final geteditimage =
  //       await Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return ImageEditorPro(
  //       appBarColor: Colors.blue,
  //       bottomBarColor: Colors.blue,
  //     );
  //   })).then((geteditimage) {
  //     if (geteditimage != null) {
  //       setState(() {
  //         _image = geteditimage;
  //       });
  //     }
  //   }).catchError((er) {
  //     print(er);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    SpeedDial buildSpeedDial() {
      return SpeedDial(
        // animatedIcon: AnimatedIcons.add_event,

        animatedIconTheme: IconThemeData(size: 22.0),
        child: Icon(Icons.camera_enhance, color: Colors.white),
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        visible: dialVisible,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.cameraRetro, color: Colors.white),
            backgroundColor: secondaryColor,
            onTap: () async {
              _image = await controlador1.getImageCamera(context);
              if (_image != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubirFotos(image: _image)));
                // getImage(context, _image);
              } else {
                return;
              }
            },
            label: 'Foto Camára',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: primaryColor,
          ),
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.image, color: Colors.white),
              backgroundColor: secondaryColor,
              onTap: () async {
                // Navigator.popAndPushNamed(context, '/Filtros');
                // getimageditor(context);
                _image = await controlador1.getImage(context);
                if (_image != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubirFotos(image: _image)));
                  //   getImage(context, _image);
                } else {
                  return;
                }
              },
              label: 'Foto Galeria',
              labelStyle: TextStyle(fontWeight: FontWeight.w500),
              labelBackgroundColor: primaryColor,
              elevation: 0,
              foregroundColor: Colors.white60),
          // SpeedDialChild(
          //   child: Icon(Icons.keyboard_voice, color: Colors.white),
          //   backgroundColor: Colors.blue,
          //   onTap: () => print('THIRD CHILD'),
          //   labelWidget: Container(
          //     color: Colors.blue,
          //     margin: EdgeInsets.only(right: 10),
          //     padding: EdgeInsets.all(6),
          //     child: Text('Custom Label Widget'),
          //   ),
          // ),
        ],
      );
    }

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
        floatingActionButton: controlador1.pestanaAct == 2
            ? buildSpeedDial()
            : FloatingActionButton(
                mini: true,
                onPressed: () {
                  controlador1.pestanaAct == 0
                      ? Navigator.of(context).pushNamed('/registro_adopcion')
                      : controlador1.pestanaAct == 1
                          ? Navigator.of(context).pushNamed('/registro_perdido')
                          : controlador1.pestanaAct == 2
                              ? print('holi')

                              // Navigator.of(context).pushNamed('/fotosPrincipal')
                              : Navigator.of(context)
                                  .pushNamed('/registro_emergencia');
                },
                child: Icon(
                    controlador1.pestanaAct == 2
                        ? Icons.camera_enhance
                        : Icons.add,
                    color: primaryLight),
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
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cameraRetro),
              title: Text('Fotos'),
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
