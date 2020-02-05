import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';
class UserBanner extends StatelessWidget {
  const UserBanner({
    Key key,
    @required this.controlador1,
    @required this.usuario,
  }) : super(key: key);

  final Controller controlador1;
  final dynamic usuario;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: FadeInImage(
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              image: NetworkImage(usuario.foto),
              placeholder: AssetImage('assets/dog.png'),
            ),
          ),
          SizedBox(width: 20,),
          Expanded(
                      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(usuario.nombre),
                Text(usuario.descripcion)
              ],
            ),
          )
        ],
      ),
    );
  }
}