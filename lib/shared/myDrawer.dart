import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
import 'package:adoption_app/shared/shared.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
    @required this.controlador1,
  }) : super(key: key);

  final Controller controlador1;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Hero(
                  tag: controlador1.usuario.documentId,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        NetworkImage(controlador1.usuario.foto ?? ''),
                  ),
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
              Navigator.of(context).pushNamed('/perfil');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.history),
            title: Text('Mis publicaciones'),
            onTap: () {
              Navigator.of(context).pushNamed('/publicaciones');
            },
          ),
          ListTile(
            leading: Hero(
                tag: 'favoritos', child: Icon(FontAwesomeIcons.solidHeart)),
            title: Text('Favoritos'),
            onTap: () {
              Navigator.of(context).pushNamed('/favoritos');
            },
          ),
          ListTile(
            title: Text('Información'),
            leading: Icon(
              Icons.info,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/info');
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
    );
  }
}
