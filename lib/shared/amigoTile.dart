import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/pages/pages.dart';

class AmigoTile extends StatelessWidget {
  const AmigoTile({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        return Navigator.push(context,
            MaterialPageRoute(builder: (context) => Perfil(usuario: usuario)));
      },
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(usuario.foto),
      ),
      title: Text(
        usuario.nombre,
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(usuario.descripcion),
    );
  }
}
