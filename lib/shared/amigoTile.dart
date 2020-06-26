import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/pages/pages.dart';

class AmigoTile extends StatelessWidget {
  const AmigoTile({Key key, @required this.usuario, this.chat})
      : super(key: key);

  final UsuarioModel usuario;
  final bool chat;

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return ListTile(
      onTap: () {
        if (!chat) {
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Perfil(usuario: usuario)));
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Chat(
              usuario: usuario,
              usuarios: [
                usuario.documentId,
                controlador1.usuario.documentId,
              ],
              nombre: usuario.nombre,
              foto: usuario.foto,
            ),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(usuario.foto),
      ),
      title: Text(
        usuario.nombre,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: chat
          ? Text(controlador1.fecha(usuario.userLastMsg))
          : Text(usuario.descripcion),
    );
  }
}
