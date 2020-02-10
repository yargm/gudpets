import 'package:flutter/material.dart';

class UserBanner extends StatelessWidget {
  const UserBanner({
    Key key,
    @required this.usuario,
    @required this.extended,
  }) : super(key: key);

  final dynamic usuario;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () => extended
            ? showDialog(
                context: context,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('INE'),
                        FadeInImage(
                          image: NetworkImage(usuario.fotoINE),
                          placeholder: AssetImage('assets/dog.png'),
                        )
                      ],
                    ),
                  ),
                ))
            : null,
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
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(usuario.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  usuario.descripcion != null
                      ? Text(usuario.descripcion)
                      : Container(),
                      SizedBox(height: 3,),
                  extended
                      ? Row(
                          children: <Widget>[
                            Icon(
                              Icons.mail,
                              size: 15,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(usuario.correo),
                          ],
                        )
                      : Container(),
                  extended
                      ? Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              size: 15,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(usuario.telefono.toString()),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            extended ? Icon(Icons.details) : Container()
          ],
        ),
      ),
    );
  }
}
