import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:gudpets/services/controlador.dart';
import 'package:gudpets/services/services.dart';
import 'package:gudpets/shared/colores.dart';
import 'package:gudpets/shared/postCard.dart';
import 'package:like_button/like_button.dart';

// ignore: must_be_immutable
class PostView extends StatefulWidget {
  final PostsModel post;
  var index = 2;
  final Controller controlador1;

  PostView({this.post, this.index, this.controlador1});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool fav = false;

  int numlikes;
  bool expanded = false;
  bool contenido = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.post.favoritos
        .contains(widget.controlador1.usuario.documentId)) {
      setState(() {
        fav = true;
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
      widget.post.favoritos.add(widget.controlador1.usuario.documentId);
      //widget.post.reference.update({'numlikes': widget.post.numlikes + 1});
    } else {
      widget.post.reference.update({
        'favoritos':
            FieldValue.arrayRemove([widget.controlador1.usuario.documentId])
      });
      widget.post.favoritos.remove(widget.controlador1.usuario.documentId);
    }

    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Widget build(context) {
    Controller controlador1 = Provider.of<Controller>(context);
    return WillPopScope(
      onWillPop: () async {
        controlador1.pestanaAct = 0;
        //controlador1.notify();

        //controlador1.notify();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
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
                            height: 20,
                            child: const CircularProgressIndicator()),
                      );

                    var documents = snapshot.data;

                    // print(documents['foto']);
                    UsuarioModel usu =
                        UsuarioModel.fromDocumentSnapshot(documents, '');
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(usu.foto),
                        // backgroundColor: Colors.black,
                        radius: 25,
                      ),
                      title: Text(
                        usu.nombre,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        '${widget.post.fecha.day.toString()}/${widget.post.fecha.month.toString()}/${widget.post.fecha.year.toString()}   a las ${widget.post.fecha.hour.toString()}:${widget.post.fecha.minute.toString()}',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: PopupMenuButton(
                        elevation: 8,
                        padding: EdgeInsets.all(0),
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
              widget.post.descripcion == ''
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(
                          top: 0, bottom: 10, left: 10, right: 10),
                      child: Text(
                        widget.post.descripcion,
                        // 'Del nacimiento del teléfono móvil a las apps'
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
              FadeInImage.assetNetwork(
                fadeInCurve: Curves.decelerate,
                placeholder: 'assets/Ripple.gif',
                image: widget.post.foto,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 10,
              ),
              LikeButton(
                isLiked: fav,
                size: 25,
                circleColor:
                    CircleColor(start: Colors.yellow, end: Colors.yellowAccent),
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
              Divider(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Comments1(
                  post: widget.post,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Comments1 extends StatefulWidget {
  PostsModel post;
  Comments1({this.post});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments1> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
            stream: widget.post.reference
                .collection('comentarios')
                .orderBy('fecha')
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
                          parent: NeverScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        ComentarioModel comentario =
                            ComentarioModel.fromDocumentSnapshot(
                                documents[index]);

                        return StreamBuilder(
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

                              if (comentario.likes
                                  .contains(controlador1.usuario.documentId)) {
                                like = true;
                              }
                              return Listacomentario2(
                                comentario: comentario,
                                like: like,
                                usuario: usuario,
                                controlador1: controlador1,
                              );
                            });
                      },
                    )
                  : Container(
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.center,
                      child: Text(
                          'No hay ningun comentario.\nSe el primero en comentar'),
                    );
            }),
        Divider(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: controlador1.loading
                    ? LinearProgressIndicator(
                        // backgroundColor: secondaryDark,
                        )
                    : ListTile(
                        leading: CircleAvatar(
                          radius: 22,
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
                          alignment: Alignment.bottomCenter,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: primaryDark),
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.black,
                              size: 15,
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
    );
  }
}

class Listacomentario2 extends StatefulWidget {
  final ComentarioModel comentario;
  final UsuarioModel usuario;
  final bool like;
  final Controller controlador1;

  const Listacomentario2(
      {Key key, this.controlador1, this.comentario, this.like, this.usuario})
      : super(key: key);

  @override
  _Listacomentario2State createState() => _Listacomentario2State();
}

class _Listacomentario2State extends State<Listacomentario2> {
  bool eliminar = false;
  Future<bool> onLikeButtonTapped1(bool isLiked) async {
    print(!isLiked);

    if (!isLiked) {
      widget.comentario.reference.update({
        'likes': FieldValue.arrayUnion([widget.controlador1.usuario.documentId])
      });
      //numlikes = widget.post.numlikes;
      widget.comentario.likes.add(widget.controlador1.usuario.documentId);
      //widget.post.reference.update({'numlikes': widget.post.numlikes + 1});
    } else {
      widget.comentario.reference.update({
        'likes':
            FieldValue.arrayRemove([widget.controlador1.usuario.documentId])
      });
      widget.comentario.likes.remove(widget.controlador1.usuario.documentId);
    }
    return !isLiked;
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Perfil(usuario: widget.usuario)));
        },
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.usuario.foto),
        ),
      ),
      title: GestureDetector(
        onLongPress: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogLongPressedContent1(
              comentario: widget.comentario,
              usuario: widget.usuario,
            );
          },
        ),
        child: Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 15, bottom: 5, left: 0, right: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: primaryColor,
                border: Border.all(
                  color: primaryLight,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(widget.usuario.nombre,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(
                  widget.comentario.comentario,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            )),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          '${widget.comentario.fecha.day.toString()}/${widget.comentario.fecha.month.toString()}/${widget.comentario.fecha.year.toString()}  a las ${widget.comentario.fecha.hour.toString()}:${widget.comentario.fecha.minute.toString()}',
          style: TextStyle(fontSize: 12),
        ),
      ),
      trailing: Container(
        width: 18,
        height: 18,
        child: LikeButton(
          // countPostion: CountPostion.bottom,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          padding: EdgeInsets.only(top: 10),
          isLiked: widget.like,
          size: 15,
          circleColor:
              CircleColor(start: Colors.yellow, end: Colors.yellowAccent),
          bubblesColor: BubblesColor(
            dotPrimaryColor: Colors.yellow[900],
            dotSecondaryColor: Colors.yellowAccent,
          ),
          likeBuilder: (bool isLiked) {
            return Icon(
              Icons.favorite,
              color: isLiked ? Colors.pink[300] : Colors.grey,
              size: 15,
            );
          },
          // likeCount: widget.comentario.likes.length,
          // countBuilder: (int count, bool isLiked, String text) {
          //   var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
          //   Widget result;
          //   if (count == 0) {
          //     result = Text(
          //       "",
          //       style: TextStyle(color: color),
          //     );
          //   } else
          //     result = Text(
          //       text,
          //       style: TextStyle(color: color),
          //     );
          //   return result;
          // },
          onTap: onLikeButtonTapped1,
        ),
      ),
    );

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   mainAxisSize: MainAxisSize.max,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     CircleAvatar(
    //       radius: 20,
    //       backgroundImage: NetworkImage(widget.usuario.foto),
    //     ),
    //     Column(
    //       mainAxisSize: MainAxisSize.min,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //             alignment: Alignment.centerLeft,
    //             margin: EdgeInsets.only(top: 15, bottom: 5, left: 0, right: 20),
    //             padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    //             decoration: BoxDecoration(
    //                 color: primaryColor,
    //                 border: Border.all(
    //                   color: primaryLight,
    //                 ),
    //                 borderRadius: BorderRadius.circular(10)),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.max,
    //               children: <Widget>[
    //                 Text(widget.usuario.nombre,
    //                     style: TextStyle(
    //                         fontSize: 15, fontWeight: FontWeight.bold)),
    //                 Text(
    //                   widget.comentario.comentario,
    //                   style: TextStyle(color: Colors.black87, fontSize: 16),
    //                 ),
    //               ],
    //             )),
    //         Padding(
    //           padding: const EdgeInsets.only(left: 18),
    //           child: Text(
    //             '${widget.comentario.fecha.month.toString()}/${widget.comentario.fecha.day.toString()}  a las ${widget.comentario.fecha.hour.toString()}:${widget.comentario.fecha.minute.toString()}',
    //             style: TextStyle(fontSize: 12),
    //           ),
    //         ),
    //       ],
    //     ),
    //     LikeButton(
    //       // countPostion: CountPostion.bottom,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       isLiked: widget.like,
    //       size: 18,
    //       circleColor:
    //           CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
    //       bubblesColor: BubblesColor(
    //         dotPrimaryColor: Color(0xff33b5e5),
    //         dotSecondaryColor: Color(0xff0099cc),
    //       ),
    //       likeBuilder: (bool isLiked) {
    //         return Icon(
    //           Icons.favorite,
    //           color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
    //           size: 18,
    //         );
    //       },
    //       // likeCount: widget.comentario.likes.length,
    //       // countBuilder: (int count, bool isLiked, String text) {
    //       //   var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
    //       //   Widget result;
    //       //   if (count == 0) {
    //       //     result = Text(
    //       //       "",
    //       //       style: TextStyle(color: color),
    //       //     );
    //       //   } else
    //       //     result = Text(
    //       //       text,
    //       //       style: TextStyle(color: color),
    //       //     );
    //       //   return result;
    //       // },
    //       onTap: onLikeButtonTapped1,
    //     ),
    //   ],
    // );
  }
}

// ignore: must_be_immutable
class ListaComentario1 extends StatefulWidget {
  ComentarioModel comentario;
  UsuarioModel usuario;
  bool like;
  int index;
  final Controller controlador1;
  ListaComentario1(
      {this.controlador1,
      this.comentario,
      this.like,
      this.index,
      this.usuario});

  @override
  _ListaComentarioState createState() => _ListaComentarioState();
}

class _ListaComentarioState extends State<ListaComentario1> {
  TextEditingController textEditingController = TextEditingController();
  bool expandedcomentario = false;
  bool eliminar = false;
  Map<String, dynamic> respuesta = {
    'comentario': '',
    'fecha': '',
    'likes': [],
    'userId': '',
  };

  Future<bool> onLikeButtonTapped1(bool isLiked) async {
    print(!isLiked);

    if (!isLiked) {
      widget.comentario.reference.update({
        'likes': FieldValue.arrayUnion([widget.controlador1.usuario.documentId])
      });
      //numlikes = widget.post.numlikes;
      widget.comentario.likes.add(widget.controlador1.usuario.documentId);
      //widget.post.reference.update({'numlikes': widget.post.numlikes + 1});
    } else {
      widget.comentario.reference.update({
        'likes':
            FieldValue.arrayRemove([widget.controlador1.usuario.documentId])
      });
      widget.comentario.likes.remove(widget.controlador1.usuario.documentId);
    }

    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  Widget build(BuildContext context) {
    Controller controlador1 = Provider.of<Controller>(context);

    return Column(
      children: <Widget>[
        GestureDetector(
          onLongPress: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogLongPressedContent1(
                comentario: widget.comentario,
                usuario: widget.usuario,
              );
            },
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: widget.index == 2 ? 17 : 25,
              backgroundImage: NetworkImage(widget.usuario.foto),
            ),
            title: Flexible(
              child: Container(
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text(
                      widget.comentario.comentario,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    )
                  ],
                ),
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
            trailing:
                // LikeButton(
                //   isLiked: widget.like,
                //   size: 10,
                //   circleColor:
                //       CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                //   bubblesColor: BubblesColor(
                //     dotPrimaryColor: Color(0xff33b5e5),
                //     dotSecondaryColor: Color(0xff0099cc),
                //   ),
                //   likeBuilder: (bool isLiked) {
                //     return Icon(
                //       Icons.favorite,
                //       color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                //       size: 10,
                //     );
                //   },
                //   // likeCount: widget.comentario.likes.length,
                //   // countBuilder: (int count, bool isLiked, String text) {
                //   //   var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                //   //   Widget result;
                //   //   if (count == 0) {
                //   //     result = Text(
                //   //       "",
                //   //       style: TextStyle(color: color),
                //   //     );
                //   //   } else
                //   //     result = Text(
                //   //       text,
                //   //       style: TextStyle(color: color),
                //   //     );
                //   //   return result;
                //   // },
                //   onTap: onLikeButtonTapped1,
                // ),

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
                      controlador1.notify();
                    }),
          ),
        ),
        // expandedcomentario
        //     ? Padding(
        //         padding: const EdgeInsets.only(left: 17, right: 0),
        //         child: Column(
        //           children: <Widget>[
        //             StreamBuilder(
        //                 stream: widget.comentario.reference
        //                     .collection('comentarios')
        //                     .snapshots(),
        //                 builder: (context, snapshots) {
        //                   if (!snapshots.hasData)
        //                     return Center(
        //                       child: CircularProgressIndicator(
        //                         backgroundColor: secondaryDark,
        //                       ),
        //                     );

        //                   List<DocumentSnapshot> documents =
        //                       snapshots.data.documents;

        //                   return documents.isNotEmpty
        //                       ? ListView.builder(
        //                           physics: ScrollPhysics(
        //                               parent: NeverScrollableScrollPhysics()),
        //                           shrinkWrap: true,
        //                           itemCount: documents.length,
        //                           itemBuilder: (context, index) {
        //                             ComentarioModel comentario =
        //                                 ComentarioModel.fromDocumentSnapshot(
        //                                     documents[index]);
        //                             List likes = comentario.likes;
        //                             return Row(
        //                               children: <Widget>[
        //                                 Flexible(
        //                                   child: StreamBuilder(
        //                                       stream: FirebaseFirestore.instance
        //                                           .collection('usuarios')
        //                                           .doc(comentario.userId)
        //                                           .snapshots(),
        //                                       builder: (context, snapshot) {
        //                                         if (!snapshot.hasData)
        //                                           return Center(
        //                                             child:
        //                                                 CircularProgressIndicator(
        //                                               backgroundColor:
        //                                                   secondaryColor,
        //                                             ),
        //                                           );
        //                                         UsuarioModel usuario =
        //                                             UsuarioModel
        //                                                 .fromDocumentSnapshot(
        //                                                     snapshot.data,
        //                                                     'nose');
        //                                         bool like = false;
        //                                         if (likes.contains(
        //                                             usuario.documentId)) {
        //                                           like = true;
        //                                         }
        //                                         return ListaComentario(
        //                                           comentario: comentario,
        //                                           index: 2,
        //                                           like: like,
        //                                           usuario: usuario,
        //                                         );
        //                                       }),
        //                                 ),
        //                               ],
        //                             );
        //                           },
        //                         )
        //                       : Container(
        //                           padding: EdgeInsets.only(left: 15, top: 10),
        //                           alignment: Alignment.center,
        //                           child: Text('Se el primero en responder'),
        //                         );
        //                 }),
        //             Container(
        //               padding: EdgeInsets.all(10),
        //               alignment: Alignment.bottomCenter,
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: <Widget>[
        //                   Expanded(
        //                     child: controlador1.loading
        //                         ? LinearProgressIndicator(
        //                             // backgroundColor: secondaryDark,
        //                             )
        //                         : ListTile(
        //                             leading: CircleAvatar(
        //                               radius: 18,
        //                               backgroundImage: NetworkImage(
        //                                   controlador1.usuario.foto),
        //                             ),
        //                             title: TextField(
        //                               maxLength: 100,
        //                               maxLines: 4,
        //                               minLines: 1,
        //                               decoration: InputDecoration(
        //                                   labelText: 'Escribe algo...'),
        //                               controller: textEditingController,
        //                             ),
        //                             trailing: Container(
        //                               width: 30,
        //                               height: 30,
        //                               decoration: BoxDecoration(
        //                                   borderRadius:
        //                                       BorderRadius.circular(180),
        //                                   color: secondaryLight),
        //                               child: IconButton(
        //                                 iconSize: 15,
        //                                 icon: Icon(
        //                                   Icons.send,
        //                                   color: Colors.white,
        //                                 ),
        //                                 onPressed: () async {
        //                                   controlador1.loading = true;
        //                                   controlador1.notify();
        //                                   respuesta['comentario'] =
        //                                       textEditingController.text.trim();
        //                                   respuesta['fecha'] = DateTime.now();
        //                                   respuesta['userId'] =
        //                                       controlador1.usuario.documentId;

        //                                   if (respuesta['comentario'] != '' &&
        //                                       respuesta['comentario'] != null &&
        //                                       respuesta['fecha'] != '' &&
        //                                       respuesta['fecha'] != null &&
        //                                       respuesta['userId'] != '' &&
        //                                       respuesta['userId'] != null) {
        //                                     await widget.comentario.reference
        //                                         .collection('comentarios')
        //                                         .add(respuesta);
        //                                   }
        //                                   controlador1.loading = false;
        //                                   textEditingController.clear();
        //                                   controlador1.notify();
        //                                 },
        //                               ),
        //                             ),
        //                           ),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           ],
        //         ),
        //       )
        //     : Container(),
      ],
    );
  }
}

// ignore: must_be_immutable
class DialogLongPressedContent1 extends StatefulWidget {
  ComentarioModel comentario;
  UsuarioModel usuario;

  DialogLongPressedContent1({this.comentario, this.usuario});

  @override
  _DialogLongPressedContentState createState() =>
      _DialogLongPressedContentState();
}

class _DialogLongPressedContentState extends State<DialogLongPressedContent1> {
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
