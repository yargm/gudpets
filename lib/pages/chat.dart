import 'package:gudpets/services/models.dart';
import 'package:gudpets/shared/colores.dart';
import 'package:gudpets/pages/pages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudpets/services/services.dart';
import 'package:provider/provider.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'pages.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Chat extends StatefulWidget {
  final dynamic usuarios;
  final String nombre;
  final String foto;
  final UsuarioModel usuario;

  Chat({this.usuarios, this.nombre, this.foto, this.usuario});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> documents = [];
  String roomID;
  String tipo = '0';
  var imagen;
  Future myFuture;

  GiphyGif _gif;
  @override
  void initState() {
    super.initState();
    //pasar el arreglo de los ids
    myFuture = getChat(widget.usuarios);
    //Creo que ya tengo el documento
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          //Si tocas la foto de tu amix en el appbar pasa esto
          GestureDetector(
            onTap: () {
              //Define como usuario seleccionado a tu amix
              controller.selectedUser = widget.usuario;
              Navigator.of(context).push(MaterialPageRoute(
                  //Puedes ver el perfil de tu amix otra vez
                  builder: (context) => Perfil(
                        usuario: widget.usuario,
                      )));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: CircleAvatar(
                maxRadius: 18,
                backgroundImage: NetworkImage(widget.foto),
              ),
            ),
          ),
        ],
        title: Row(
          children: <Widget>[
            //Nombre de tu amix
            Container(
              width: MediaQuery.of(context).size.width * 0.51,
              child: Text(
                widget.nombre,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 30),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: FutureBuilder<String>(
                  future: myFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    //Guarda el nombre del documento de la conversación en esta variable
                    roomID = snapshot.data;
                    return StreamBuilder(
                      //Finalmente obtienes los pinches mensajes y los ordenas por fecha de arriba pabajo
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(roomID)
                          .collection('mensajes')
                          .orderBy('fecha', descending: true)
                          .limit(500)
                          .snapshots(),
                      builder: (context, snap) {
                        if (!snap.hasData) return Container();
                        //Obtengo la lista de documentos, cada documento es un mensaje diferente
                        documents = snap.data.documents;
                        return Container(
                          margin: EdgeInsets.only(bottom: 95),
                          //La lista va a recorrer todos los mensajes y a cada uno los apegará al modelomensaje
                          child: ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                return Mensaje(
                                  amix: widget.nombre,
                                  mensajeModel:
                                      //Para poder apegarlo al modelo debes pasarle el documento que está en el index
                                      MensajeModel.fromDS(documents[index]),
                                );
                              }),
                        );
                      },
                    );
                  }),
            ),
            FittedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //Opción para enviar fotos del telefono
                    IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () async {
                          imagen = await controller.getImage(context);
                          setState(() {
                            if (imagen != null && _gif != null) {
                              _gif = null;
                            }
                            //Guardar el tipo de mensaje como tipo 1
                            imagen = imagen;
                            tipo = '1';
                          });
                        }),
                    //Opción para enviar gif
                    IconButton(
                        icon: Icon(Icons.gif),
                        onPressed: () async {
                          final gif = await GiphyPicker.pickGif(
                              showPreviewPage: false,
                              context: context,
                              apiKey: 'lNQ4l3vP5F2yWjHcJiVHaKyK4HEm16Q8');

                          if (gif != null) {
                            if (imagen != null) {
                              imagen = null;
                            }
                            tipo = '2';
                            setState(() => _gif = gif);
                          }
                        }),

                    Container(
                      width: 300,
                      child: //Si quieres enviar una imagen. Te muestra la imagen y te permite cancelar con una tachita que aparece en la miniatura
                          imagen != null
                              ? Stack(
                                  alignment: Alignment.topLeft,
                                  children: <Widget>[
                                    Image(
                                      fit: BoxFit.cover,
                                      image: FileImage(imagen),
                                      height: 300,
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          imagen = null;
                                          setState(() {});
                                        }),
                                  ],
                                )
                              : //Si quieres enviar un gif. Lo mismo que con la imagen pero con el código para gif
                              _gif != null
                                  ? Stack(
                                      alignment: Alignment.topLeft,
                                      children: <Widget>[
                                        GiphyImage.original(
                                          gif: _gif,
                                          height: 300,
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              _gif = null;
                                              setState(() {});
                                            }),
                                      ],
                                    )
                                  : //Si es un texto, es manejado por el controlador de texto
                                  TextField(
                                      keyboardType: TextInputType.text,
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                          hintText: 'Mensaje',
                                          labelText: 'Mensaje',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide())),
                                      style: TextStyle(fontSize: 15),
                                      minLines: 1,
                                      maxLines: 5,
                                    ),
                    ),
                    //Icono de enviar
                    IconButton(
                        icon: CircleAvatar(
                          child: Icon(
                            Icons.send,
                            color: secondaryDark,
                            size: 18,
                          ),
                          backgroundColor: secondaryLight,
                        ),
                        onPressed: () async {
                          //Verificamos el tipo para saber cómo guardarlo en firebase
                          switch (tipo) {
                            case '0':
                              Fluttertoast.showToast(msg: 'tipo texto');
                              //Si el texto está vacío no hace nada
                              if (textEditingController.text.isEmpty ||
                                  textEditingController.text.trim() == '')
                                return;
                              //Si tiene contenido
                              //Función para actualizar las variables mágicas
                              Fluttertoast.showToast(
                                  msg: 'actualizo variables');
                              await updateLastMsg(
                                  controller, widget.usuario.documentId);
                              //Consulta para guardar el mensaje en su respectiva sala de chat
                              Fluttertoast.showToast(msg: 'haré la inserción');
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(roomID)
                                  .collection('mensajes')
                                  .add({
                                'recibe': widget.usuario.documentId,
                                'mensaje': textEditingController.text,
                                'usuario': controller.usuario.documentId,
                                'fecha': DateTime.now(),
                                'tipo': tipo,
                              });
                              textEditingController.clear();
                              //Limpia el controlador de texto y actualiza la vista
                              setState(() {});
                              break;
                            //En caso de que sea imagen
                            case '1':
                              Fluttertoast.showToast(msg: 'tipo foto');
                              //Guarda la imagen en una variable independiente
                              var newImagen = imagen;
                              controller.loading = true;
                              controller.notify();

                              //Limpia la variable original que se usa para capturar la imagen
                              setState(() {
                                imagen = null;
                              });
                              //Comienza subida a firestore
                              final String fileName =
                                  controller.usuario.correo +
                                      '/chat/' +
                                      DateTime.now().toString();

                              Reference storageRef = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(fileName);

                              final UploadTask uploadTask =
                                  storageRef.putFile(
                                newImagen,
                              );

                              final TaskSnapshot downloadUrl =
                                  (await uploadTask.whenComplete(() => null));

                              if (controller.usuario.fotoStorageRef != null) {
                                await FirebaseStorage.instance
                                    .ref()
                                    .child((controller.usuario.fotoStorageRef))
                                    .delete()
                                    .catchError((onError) {
                                  print(onError);
                                });
                              }

                              final String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              //Termina subida a firestore
                              //Función de variables mágicas
                              await updateLastMsg(
                                  controller, widget.usuario.documentId);

                              //Subir el contenido a su respectivo chat
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(roomID)
                                  .collection('mensajes')
                                  .add({
                                'recibe': widget.usuario.documentId,
                                'imagen': url,
                                'usuario': controller.usuario.documentId,
                                'fecha': DateTime.now(),
                                'tipo': tipo,
                              });
                              // await Firestore.instance
                              //     .collection('chats')
                              //     .document(roomID)
                              //     .updateData({'ultimoMsj': DateTime.now()});

                              //Devolver tipo a texto
                              tipo = '0';

                              controller.loading = false;

                              controller.notify();
                              break;
                            //En caso de que sea un gif
                            case '2':
                              controller.loading = true;
                              controller.notify();
                              GiphyGif newGif = _gif;
                              _gif = null;
                              //Esta función actualiza variables de ambos usuarios
                              await updateLastMsg(
                                  controller, widget.usuario.documentId);
                              //Consulta para guardar el mensaje en la colección chats subcolección mensajes con el id específico
                              await FirebaseFirestore.instance
                                  .collection('chats')
                                  .doc(roomID)
                                  .collection('mensajes')
                                  .add({
                                'recibe': widget.usuario.documentId,
                                'gif': newGif.images.original.url,
                                'usuario': controller.usuario.documentId,
                                'fecha': DateTime.now(),
                                'tipo': tipo,
                              });
                              // await Firestore.instance
                              //     .collection('chats')
                              //     .document(roomID)
                              //     .updateData({'ultimoMsj': DateTime.now()});

                              //Devuelve el tipo a texto
                              tipo = '0';

                              controller.loading = false;

                              controller.notify();
                              break;
                          }
                          //Esta madre no la entendí
                          if (documents != null || documents.isNotEmpty) {
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300),
                            );
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  updateLastMsg(Controller controller, String user) async {
    //Recibí el controlador y el usuario de mi amix
    //Si esta vatriable está nula o vacía significa que es la primera vez que mandas un mensaje desde que abriste el chat
    if (documents == null || documents.isEmpty) {
      //Al momento de enviar el mensaje se generan las variables del diablo
      //En mi usuario se guardan las siguientes variables
      await controller.usuario.reference.update({
        //variable amix+check visto
        user + 'Check': false,
        //Variable hora ultimo mensaje
        user + 'LastMsg': DateTime.now(),
        //Variable chat con mi amix
        user + 'Chat': true
      });
      //En el documento de mi amix
      await widget.usuario.reference.update({
        //Variable chat conmigo
        controller.usuario.documentId + 'Chat': true,
        //Variable ultimo mensaje
        controller.usuario.documentId + 'LastMsg': DateTime.now(),
      });
      return;
    }
    //Si ya envié otros mensajes mientras tenía la ventana abierta
    await controller.usuario.reference.update({
      //Actualizo la hora del último mensaje
      user + 'LastMsg': DateTime.now(),
    });
    //Aquí no entiendo qué pedo
    await controller.usuario.reference
        .update({user + 'Check': false, user + 'LastMsg': DateTime.now()});
  }

  Future<String> getChat(dynamic usuarios) async {
    //busca en la colección chats el documento que se llame id1-id2
    var query = await FirebaseFirestore.instance
        .collection('chats')
        .doc('${usuarios[0]}-${usuarios[1]}')
        .get();
    //Si ese documento no existe busca al revés id2-id1
    if (!query.exists) {
      query = await FirebaseFirestore.instance
          .collection('chats')
          .doc('${usuarios[1]}-${usuarios[0]}')
          .get();
      //Si el chat no existe crea el chat nuevo guardándole su array de ids y el último mensaje con la fecha actual
      if (!query.exists) {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc('${usuarios[0]}-${usuarios[1]}')
            .set({'usuarios': usuarios, 'ultimoMsj': DateTime.now()});
        return '${usuarios[0]}-${usuarios[1]}';
      }

      return '${usuarios[1]}-${usuarios[0]}';
    }

    return '${usuarios[0]}-${usuarios[1]}';

    //En cualquiera de los tres casos retorna el documento
  }
}
