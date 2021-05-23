import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/pages/postView.dart';
import 'package:gudpets/services/models.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/colores.dart';
import 'package:like_button/like_button.dart';

class Fotos extends StatefulWidget {
  final PostsModel post;
  final int index;
  final Controller controlador1;
  final bool fav;

  const Fotos({Key key, this.post, this.controlador1, this.index, this.fav})
      : super(key: key);

  @override
  _FotosState createState() => _FotosState();
}

class _FotosState extends State<Fotos> {
  int numlikes;
  bool expanded = false;
  bool contenido = false;
  bool fav1 = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fav1 = widget.fav;
    if (widget.post.favoritos
        .contains(widget.controlador1.usuario.documentId)) {
      setState(() {
        fav1 = true;
      });
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    print(!isLiked);
    if (!isLiked) {
      widget.post.reference.update({
        'favoritos':
            FieldValue.arrayUnion([widget.controlador1.usuario.documentId])
      });
      numlikes = widget.post.numlikes;

      //widget.post.reference.update({'numlikes': widget.post.numlikes + 1});
    } else {
      widget.post.reference.update({
        'favoritos':
            FieldValue.arrayRemove([widget.controlador1.usuario.documentId])
      });
    }
    return !isLiked;
  }

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(widget.post.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Container(
                        height: 50, child: const CircularProgressIndicator()),
                  );

                var documents = snapshot.data;

                // print(documents['foto']);
                UsuarioModel usu =
                    UsuarioModel.fromDocumentSnapshot(documents, '');
                return ListTile(
                  onTap: () async {
                    return Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Perfil(usuario: usu)));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(usu.foto),
                    // backgroundColor: Colors.black,
                    radius: 25,
                  ),
                  title: Text(
                    usu.nombre,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text(
                    '${widget.post.fecha.day.toString()}/${widget.post.fecha.month.toString()}/${widget.post.fecha.year.toString()}   a las ${widget.post.fecha.hour.toString()}:${widget.post.fecha.minute.toString()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: PopupMenuButton(
                    elevation: 8,
                    padding: EdgeInsets.all(8),
                    offset: Offset.zero,
                    onCanceled: () {
                      print("You have canceled the menu.");
                    },
                    onSelected: (value) {
                      if (value == 1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EliminarPostsContent(
                                index: widget.index, post: widget.post);
                          },
                        );
                      } else {
                        print(value);
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: secondaryDark,
                    ),
                    itemBuilder: (context) => [
                      controlador1.usuario.documentId == usu.documentId
                          ? PopupMenuItem(
                              value: 1,
                              child: Text("Eliminar"),
                            )
                          : null,
                      PopupMenuItem(
                        value: 2,
                        child: Text("Reportar"),
                      ),
                    ],
                  ),
                );
              }),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostView(
                    post: widget.post,
                    controlador1: widget.controlador1,
                  ),
                ),
              );
            },
            child: FadeInImage.assetNetwork(
              fadeInCurve: Curves.decelerate,
              placeholder: 'assets/Ripple.gif',
              image: widget.post.foto,
              fit: BoxFit.cover,
            ),
          ),
          widget.post.descripcion == ''
              ? Container()
              : Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 5, left: 10),
                  child: Text(
                    widget.post.descripcion,
                    // 'Del nacimiento del teléfono móvil a las apps'
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
          Divider(),
          widget.index == 2
              ? Container()
              : LikeButton(
                  isLiked: widget.fav,
                  size: 25,
                  circleColor: CircleColor(
                      start: Colors.yellow, end: Colors.yellowAccent),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Colors.yellow[900],
                    dotSecondaryColor: Colors.yellow,
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.pink[600] : Colors.grey,
                      size: 25,
                    );
                  },
                  likeCount: widget.post.favoritos.length,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.black : Colors.grey;
                    Widget result;
                    if (count == 0) {
                      result = Text(
                        "",
                        style: TextStyle(color: color),
                      );
                    } else
                      result = Text(
                        text,
                        style: TextStyle(color: color),
                      );
                    return result;
                  },
                  onTap: onLikeButtonTapped,
                ),
          SizedBox(
            height: 10,
          )
          // ButtonBar(
          //     buttonPadding: EdgeInsets.all(5),
          //     alignment: MainAxisAlignment.center,
          //     children: [
          //       IconButton(
          //         splashColor: Colors.pink,
          //         padding: EdgeInsets.all(0),
          //         onPressed: () {
          //           controlador1.loading = true;
          //           controlador1.notify();
          //           if (!fav) {
          //             widget.post.reference.update({
          //               'favoritos': FieldValue.arrayUnion(
          //                   [controlador1.usuario.documentId])
          //             });
          //             numlikes = widget.post.numlikes;
          //             widget.post.reference
          //                 .update({'numlikes': widget.post.numlikes + 1});
          //           } else {
          //             widget.post.reference.update({
          //               'favoritos': FieldValue.arrayRemove(
          //                   [controlador1.usuario.documentId])
          //             });
          //             if (widget.post.numlikes != 0) {
          //               widget.post.reference
          //                   .update({'numlikes': widget.post.numlikes - 1});
          //             }
          //           }
          //           print('hello');
          //           controlador1.loading = false;
          //           controlador1.notify();
          //           setState(() {
          //             fav ? fav = false : fav = true;
          //           });
          //         },
          //         icon: controlador1.loading
          //             ? CircularProgressIndicator()
          //             : Icon(
          //                 fav ? Icons.favorite : Icons.favorite_border,
          //                 color: Colors.pink[200],
          //               ),
          //       ),
          //       widget.post.favoritos.length == 0
          //           ? Container()
          //           : widget.index == 2
          //               ? Container()
          //               : Text('${widget.post.favoritos.length} Me gusta'),
          //       IconButton(
          //         onPressed: () {
          //           return showDialog(
          //               context: context,
          //               child: Comments(
          //                 post: widget.post,
          //               ));
          //         },
          //         icon: Icon(Icons.comment),
          //       )
          //     ],
          //   ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Comments extends StatefulWidget {
  PostsModel post;
  Comments({this.post});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool eliminar = false;
  Map<String, dynamic> comentario = {
    'comentario': '',
    'fecha': '',
    'likes': [],
    'userId': '',
  };
  TextEditingController textEditingController = TextEditingController();
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: EdgeInsets.only(top: 60),
      backgroundColor: Colors.transparent,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 0),
              child: Text(
                'Comentarios',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: widget.post.reference
                      .collection('comentarios')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: LinearProgressIndicator(
                          backgroundColor: secondaryDark,
                        ),
                      );

                    List<DocumentSnapshot> documents = snapshot.data.documents;

                    return documents.isNotEmpty
                        ? ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              ComentarioModel comentario =
                                  ComentarioModel.fromDocumentSnapshot(
                                      documents[index]);
                              List likes = comentario.likes;
                              return Row(
                                children: <Widget>[
                                  Flexible(
                                    child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('usuarios')
                                            .doc(comentario.userId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: secondaryColor,
                                              ),
                                            );
                                          UsuarioModel usuario =
                                              UsuarioModel.fromDocumentSnapshot(
                                                  snapshot.data, 'nose');
                                          bool like = false;
                                          if (likes
                                              .contains(usuario.documentId)) {
                                            like = true;
                                          }
                                          return ListaComentario(
                                            comentario: comentario,
                                            index: 1,
                                            like: like,
                                            usuario: usuario,
                                          );
                                        }),
                                  ),
                                ],
                              );
                            },
                          )
                        : Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.center,
                            child: Text(
                                'No hay ningun comentario.\nSe el primero en comentar'),
                          );
                  }),
            ),
            Divider(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: controlador1.loading
                        ? LinearProgressIndicator(
                            // backgroundColor: secondaryDark,
                            )
                        : ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(controlador1.usuario.foto),
                            ),
                            title: TextField(
                              maxLength: 100,
                              maxLines: 4,
                              minLines: 1,
                              decoration:
                                  InputDecoration(labelText: 'Escribe algo...'),
                              controller: textEditingController,
                            ),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(180),
                                  color: secondaryLight),
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  controlador1.loading = true;
                                  controlador1.notify();
                                  comentario['comentario'] =
                                      textEditingController.text.trim();
                                  comentario['fecha'] = DateTime.now();
                                  comentario['userId'] =
                                      controlador1.usuario.documentId;

                                  if (comentario['comentario'] != '' &&
                                      comentario['comentario'] != null &&
                                      comentario['fecha'] != '' &&
                                      comentario['fecha'] != null &&
                                      comentario['userId'] != '' &&
                                      comentario['userId'] != null) {
                                    await widget.post.reference
                                        .collection('comentarios')
                                        .add(comentario);
                                  }
                                  controlador1.loading = false;
                                  textEditingController.clear();
                                  controlador1.notify();
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListaComentario extends StatefulWidget {
  ComentarioModel comentario;
  UsuarioModel usuario;
  bool like;
  int index;
  ListaComentario({this.comentario, this.like, this.index, this.usuario});

  @override
  _ListaComentarioState createState() => _ListaComentarioState();
}

class _ListaComentarioState extends State<ListaComentario> {
  TextEditingController textEditingController = TextEditingController();
  bool expandedcomentario = false;
  bool eliminar = false;
  Map<String, dynamic> respuesta = {
    'comentario': '',
    'fecha': '',
    'likes': [],
    'userId': '',
  };

  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return Column(
      children: <Widget>[
        GestureDetector(
          onLongPress: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogLongPressedContent(
                  comentario: widget.comentario,
                  usuario: widget.usuario,
                  index: widget.index);
            },
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: widget.index == 2 ? 17 : 25,
              backgroundImage: NetworkImage(widget.usuario.foto),
            ),
            title: Container(
              margin: EdgeInsets.only(top: 10, bottom: 5),
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.all(
                    color: primaryLight,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.usuario.nombre,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                    widget.comentario.comentario,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  )
                ],
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.comentario.fecha.month.toString()}/${widget.comentario.fecha.day.toString()}  a las ${widget.comentario.fecha.hour.toString()}:${widget.comentario.fecha.minute.toString()}',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  width: 15,
                ),
                // widget.index == 1
                //     ? GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             expandedcomentario
                //                 ? expandedcomentario = false
                //                 : expandedcomentario = true;
                //           });
                //         },
                //         child: Text(
                //           expandedcomentario ? 'Minimizar' : 'Responder',
                //           style: TextStyle(
                //               color: expandedcomentario
                //                   ? secondaryDark
                //                   : secondaryLight,
                //               fontSize: 13),
                //         ),
                //       )
                //     : Container()
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    color: Colors.pink[200],
                    icon: Icon(
                      widget.like ? Icons.favorite : Icons.favorite_border,
                      size: 15,
                    ),
                    onPressed: () async {
                      if (!widget.like) {
                        widget.comentario.reference.update({
                          'likes': FieldValue.arrayUnion(
                              [controlador1.usuario.documentId])
                        });
                      } else {
                        widget.comentario.reference.update({
                          'likes': FieldValue.arrayRemove(
                              [controlador1.usuario.documentId])
                        });
                      }
                      setState(() {
                        widget.like ? widget.like = false : widget.like = true;
                      });
                    }),
                // controlador1.usuario
                //             .documentId ==
                //         usuario.documentId &&
                //     controlador1.usuario
                //             .documentId ==
                //         comentario.userId
                // ? IconButton(
                //     icon: Icon(
                //         Icons.delete),
                //     onPressed: () async {
                //       await comentario
                //           .reference
                //           .delete()
                //           .catchError(
                //               (onError) {
                //         print(onError);
                //       });
                //       setState(() {});
                //     })
                // : Container(),
              ],
            ),
          ),
        ),
        expandedcomentario
            ? Padding(
                padding: const EdgeInsets.only(left: 17, right: 0),
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                        stream: widget.comentario.reference
                            .collection('comentarios')
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (!snapshots.hasData)
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: secondaryDark,
                              ),
                            );

                          List<DocumentSnapshot> documents =
                              snapshots.data.documents;

                          return documents.isNotEmpty
                              ? ListView.builder(
                                  physics: ScrollPhysics(
                                      parent: NeverScrollableScrollPhysics()),
                                  shrinkWrap: true,
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    ComentarioModel comentario =
                                        ComentarioModel.fromDocumentSnapshot(
                                            documents[index]);
                                    List likes = comentario.likes;
                                    return Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('usuarios')
                                                  .doc(comentario.userId)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      backgroundColor:
                                                          secondaryColor,
                                                    ),
                                                  );
                                                UsuarioModel usuario =
                                                    UsuarioModel
                                                        .fromDocumentSnapshot(
                                                            snapshot.data,
                                                            'nose');
                                                bool like = false;
                                                if (likes.contains(
                                                    usuario.documentId)) {
                                                  like = true;
                                                }
                                                return ListaComentario(
                                                  comentario: comentario,
                                                  index: 2,
                                                  like: like,
                                                  usuario: usuario,
                                                );
                                              }),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Container(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  alignment: Alignment.center,
                                  child: Text('Se el primero en responder'),
                                );
                        }),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: controlador1.loading
                                ? LinearProgressIndicator(
                                    // backgroundColor: secondaryDark,
                                    )
                                : ListTile(
                                    leading: CircleAvatar(
                                      radius: 18,
                                      backgroundImage: NetworkImage(
                                          controlador1.usuario.foto),
                                    ),
                                    title: TextField(
                                      maxLength: 100,
                                      maxLines: 4,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                          labelText: 'Escribe algo...'),
                                      controller: textEditingController,
                                    ),
                                    trailing: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          color: secondaryLight),
                                      child: IconButton(
                                        iconSize: 15,
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          controlador1.loading = true;
                                          controlador1.notify();
                                          respuesta['comentario'] =
                                              textEditingController.text.trim();
                                          respuesta['fecha'] = DateTime.now();
                                          respuesta['userId'] =
                                              controlador1.usuario.documentId;

                                          if (respuesta['comentario'] != '' &&
                                              respuesta['comentario'] != null &&
                                              respuesta['fecha'] != '' &&
                                              respuesta['fecha'] != null &&
                                              respuesta['userId'] != '' &&
                                              respuesta['userId'] != null) {
                                            await widget.comentario.reference
                                                .collection('comentarios')
                                                .add(respuesta);
                                          }
                                          controlador1.loading = false;
                                          textEditingController.clear();
                                          controlador1.notify();
                                        },
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}

// ignore: must_be_immutable
class EliminarPostsContent extends StatefulWidget {
  PostsModel post;
  int index;
  EliminarPostsContent({this.post, this.index});

  @override
  _EliminarPostsContentState createState() => _EliminarPostsContentState();
}

class _EliminarPostsContentState extends State<EliminarPostsContent> {
  bool eliminarPost = false;

  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return Dialog(
      child: Card(
        child: eliminarPost
            ? Container(
                width: 50,
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: secondaryDark,
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      '¿Estás seguro de eliminar la foto?',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'la foto dejará de estas disponible para todos, incluso para ti.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Divider(),
                  ButtonBar(
                    buttonPadding: EdgeInsets.all(10),
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.grey)),
                        elevation: 3,
                        color: Colors.grey[300],
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: secondaryLight)),
                        elevation: 3,
                        onPressed: () async {
                          setState(() {
                            eliminarPost = true;
                          });
                          await widget.post.reference
                              .delete()
                              .catchError((onError) {
                            print(onError);
                          });
                          setState(() {
                            eliminarPost = false;
                          });
                          if (widget.index == 2) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Eliminar'),
                      ),
                    ],
                  )
                ],
              ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

// ignore: must_be_immutable
class DialogLongPressedContent extends StatefulWidget {
  ComentarioModel comentario;
  UsuarioModel usuario;
  int index;
  DialogLongPressedContent({this.comentario, this.usuario, this.index});

  @override
  _DialogLongPressedContentState createState() =>
      _DialogLongPressedContentState();
}

class _DialogLongPressedContentState extends State<DialogLongPressedContent> {
  TextEditingController textEditingController = TextEditingController();
  bool eliminar = false;
  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Card(
          child: eliminar
              ? Container(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: secondaryDark,
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    controlador1.usuario.documentId ==
                                widget.usuario.documentId &&
                            controlador1.usuario.documentId ==
                                widget.comentario.userId
                        ? GestureDetector(
                            onTap: () async {
                              setState(() {
                                eliminar = true;
                              });
                              await widget.comentario.reference
                                  .delete()
                                  .catchError((onError) {
                                print(onError);
                              });
                              setState(() {
                                eliminar = false;
                              });

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text('Eliminar'),
                            ),
                          )
                        : Container(),
                    Divider(),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text('Reportar'),
                      ),
                    )
                  ],
                )),
    );
  }
}
