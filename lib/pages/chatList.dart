import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:gudpets/services/services.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Controller controlador1 = Provider.of<Controller>(context);
    dynamic otrousuario;
    return Scaffold(
        backgroundColor: primaryDark,
        appBar: AppBar(
          title: Text('Chats'),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('chats')
                        .where('ids',
                            arrayContains: controlador1.usuario.documentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      List<DocumentSnapshot> documents =
                          snapshot.data.documents;
                      return documents.isEmpty
                          ? Text('No tienes chats')
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                ChatModel chat = ChatModel.fromDocumentSnapshot(
                                    documents[index]);
                                if (chat.usuarios[0]['id'] ==
                                    controlador1.usuario.documentId) {
                                  otrousuario = chat.usuarios[1];
                                } else {
                                  otrousuario = chat.usuarios[0];
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 5, right: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      color:
                                          primaryColor, //leído o no leído cambia de color con un bool u_u
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                              radius: 35.0,
                                              backgroundImage: NetworkImage(
                                                  otrousuario['foto']
                                                      .toString())),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                otrousuario['nombre']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                child: StreamBuilder<Object>(
                                                  stream: null,
                                                  builder: (context, snapshot) {
                                                    return Text(
                                                      'Último mensaje que te enviaron jeje ahora qué escribo, ya no sé u_u',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    );
                                                  }
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            '1:00 PM',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                          SizedBox(height: 5),
                                          //Aquí if si el mensaje no está leído pone el new, si está leído pon un Text('')
                                          Container(
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'NEW',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
