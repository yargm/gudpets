import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
// import 'package:gudpets/shared/shared.dart';
//import 'package:provider/provider.dart';

class PerfilAmigos extends StatelessWidget {
  const PerfilAmigos({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;
  @override
  Widget build(BuildContext context) {
    // Controller controlador1 = Provider.of<Controller>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // // addSemanticIndexes: true, addRepaintBoundaries: true,
            // mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 140,
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(180),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: AssetImage('assets/dog.png'),
                          width: 120,
                          height: 120,
                          image: NetworkImage(usuario.foto),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.dog),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(FontAwesomeIcons.cat),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(FontAwesomeIcons.dove),
                              ],
                            ),
                            Text(
                              usuario.nombre,
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(usuario.correo),
                            Text(usuario.documentId)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
              ),
              ButtonBarOptions(usuario: usuario),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Información básica',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(Icons.description),
                      subtitle: Text(usuario.descripcion),
                      title: Text('Descripción'),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.calendar),
                      subtitle: Text(usuario.edad.toString()),
                      title: Text('Edad'),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.genderless),
                      subtitle: Text(usuario.sexo ?? '???'),
                      title: Text('Sexo'),
                    ),
                  ],
                ),
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
              ),
              Text(
                'Amigos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('usuarios')
                    .where('amigos', arrayContains: usuario.documentId)
                    .orderBy('nombre')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        height: 50, child: const CircularProgressIndicator());

                  List<DocumentSnapshot> documents = snapshot.data.documents;

                  return documents.isEmpty
                      ? Text('Usuario nuevo')
                      : Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    UsuarioModel usuario =
                                        UsuarioModel.fromDocumentSnapshot(
                                            documents[index]);

                                    return AvatarAmigo(usuario: usuario);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),              
            ]),
      ),
    );
  }
}

class AvatarAmigo extends StatelessWidget {
  const AvatarAmigo({
    Key key,
    @required this.usuario,
  }) : super(key: key);

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PerfilAmigos(usuario: usuario)));
          },
          child: Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image(image: NetworkImage(usuario.foto)),
            ),
          ),
        ),
      ],
    );
  }
}
