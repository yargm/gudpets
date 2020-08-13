import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Amigos extends StatefulWidget {
  @override
  _AmigosState createState() => _AmigosState();
}

class _AmigosState extends State<Amigos> {
  Future myFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<UsuarioModel>> buildChatList(
      List<DocumentSnapshot> list, Controller controller) async {
    //Recibí una lista con todos mis amigos, ahora dabo filtrar con cuales tengo chat
    List<UsuarioModel> chats = [];

    //Por cada elemento en la lista de amigos
    for (var element in list) {
      //Checar si mi amix contiene un atributo llamado miid+Chat;
      bool hasChat = element[controller.usuario.documentId + 'Chat'] ?? false;
      //Si existe
      if (hasChat)
        //Añade ese usuario a la lista de chats mandando element
        chats.add(
          UsuarioModel.fromDocumentSnapshot(
              element, controller.usuario.documentId),
        );
    }
    //Comparación extraña para que el usuario que te envió el último mensaje esté hasta arriba
    chats.sort((a, b) => b.userLastMsg.compareTo(a.userLastMsg));
    //Retorna la lista de chats
    return chats;
  }

  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return Scaffold(
      floatingActionButton: StreamBuilder(
          stream: Firestore.instance
              .collection('usuarios')
              .where('solicitudesAE',
                  arrayContains: controlador1.usuario.documentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            List<DocumentSnapshot> documents = snapshot.data.documents;
            return FloatingActionButton(
              heroTag: 'btnAA1',
              child: documents.isEmpty
                  ? Icon(
                      Icons.person_add,
                      size: 30,
                      color: Colors.white,
                    )
                  : Stack(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.add_alert,
                            size: 30,
                            color: Colors.white,
                          ),
                          width: 30,
                          height: 30,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.yellow),
                        )
                      ],
                    ),
              onPressed: () {
                showDialog(
                  context: context,
                  child: SolicitudesAmistad(
                    documents: snapshot.data.documents,
                  ),
                );
              },
            );
          }),
      appBar: AppBar(
          // title: Text('Amigos'),
          ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                'Amigos',
                style: TextStyle(fontSize: 23),
              ),
            ),
            Container(
              height: 137,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('usuarios')
                    .where('amigos',
                        arrayContains: controlador1.usuario.documentId)
                    .orderBy('nombre')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Container(
                          height: 50, child: const CircularProgressIndicator()),
                    );
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  print(documents);
                  print(documents.length);
                  return documents.isEmpty
                      ? Text(
                          'No tienes amigos :C , Haz click en el botón de abajo para buscar mas amigos')
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          //physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            UsuarioModel usuario =
                                UsuarioModel.fromDocumentSnapshot(
                                    documents[index], 'meh');
                            return AmigoTile(usuario: usuario, chat: false);
                          },
                        );
                },
              ),
            ),
            Divider(
              endIndent: 20,
              indent: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                'Chats',
                style: TextStyle(fontSize: 23),
              ),
            ),
            StreamBuilder(
              //Consulta que busca a todos los usuarios que me tienen como amigo
              stream: Firestore.instance
                  .collection('usuarios')
                  .where('amigos',
                      arrayContains: controlador1.usuario.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      height: 50, child: const CircularProgressIndicator());
                //Gurda a los usuarios en una lista de documentos
                List<DocumentSnapshot> documents = snapshot.data.documents;
                //Construye la lista de chats
                myFuture = buildChatList(documents, controlador1);
                return FutureBuilder<List<UsuarioModel>>(
                    future: myFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      //Guarda en la lista chats los usuarios con los que tengo chats
                      List<UsuarioModel> chats = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        //physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          //Asigna usuario al usuario que está en el index de la lista
                          UsuarioModel usuario = chats[index];
                          //Le pasa a mi amix y miniperfil en falso saber paque
                          return AmigoTile(
                            usuario: usuario,
                            chat: true,
                          );
                        },
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}

class SolicitudesAmistad extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  SolicitudesAmistad({this.documents});
  @override
  _SolicitudesAmistadState createState() => _SolicitudesAmistadState();
}

class _SolicitudesAmistadState extends State<SolicitudesAmistad> {
  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    return WillPopScope(
      onWillPop: () async {
        return !controller.loading;
      },
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Solicitudes de Amistad',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              widget.documents.isEmpty
                  ? Text(
                      'No tienes solicitudes',
                      style: TextStyle(color: Colors.black),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.documents.length,
                      itemBuilder: (context, index) {
                        UsuarioModel usuario =
                            UsuarioModel.fromDocumentSnapshot(
                                widget.documents[index], 'meh');
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(usuario.foto),
                          ),
                          title: Text(usuario.nombre,
                              style: TextStyle(color: Colors.black)),
                          trailing: controller.loading
                              ? CircularProgressIndicator()
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () async {
                                        controller.loading = true;
                                        controller.notify();
                                        await controller.usuario.reference
                                            .updateData({
                                          'amigos': FieldValue.arrayUnion(
                                              [usuario.documentId])
                                        });
                                        await usuario.reference.updateData({
                                          'solicitudesAE':
                                              FieldValue.arrayRemove([
                                            controller.usuario.documentId
                                          ]),
                                          'amigos': FieldValue.arrayUnion(
                                              [controller.usuario.documentId])
                                        });
                                        controller.usuario.amigos
                                            .add(usuario.documentId);
                                        controller.usuario.solicitudesAE
                                            .remove(usuario.documentId);
                                        controller.loading = false;
                                        controller.notify();
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.check,
                                        color: secondaryDark,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        controller.loading = true;
                                        controller.notify();
                                        await usuario.reference.updateData({
                                          'solicitudesAE':
                                              FieldValue.arrayRemove([
                                            controller.usuario.documentId
                                          ])
                                        });
                                        controller.loading = false;
                                        controller.notify();
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        color: secondaryDark,
                                      ),
                                    )
                                  ],
                                ),
                        );
                      },
                    ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton.extended(
                heroTag: 'btnA1',
                elevation: 0,
                shape: BeveledRectangleBorder(),
                onPressed: () => {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate('usuarios'),
                  )
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 17,
                ),
                label: Text(
                  'Buscar Amigos',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
