import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:flutter/services.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:provider/provider.dart';
import 'package:gudpets/shared/shared.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Mensaje extends StatelessWidget {
  //Recibe el modelo del mensaje
  final MensajeModel mensajeModel;
  final String amix;

  Mensaje({this.mensajeModel, this.amix});
//Le da formato a la fecha
  String fechaFormat(DateTime date) {
    String realDate;

    return realDate;
  }

  @override
  Widget build(BuildContext context) {
    Controller controller = Provider.of<Controller>(context);
    // TODO: implement build
    return Container(
      //Acomoda los globitos del chat
      margin: EdgeInsets.only(
          top: 10,
          left: mensajeModel.usuario == controller.usuario.documentId ? 100 : 0,
          right:
              mensajeModel.usuario == controller.usuario.documentId ? 0 : 100),
      decoration: BoxDecoration(
        color: mensajeModel.usuario == controller.usuario.documentId
            ? Colors.grey[300]
            : secondaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
      //Si es un texto
      child: mensajeModel.tipo == '0'
          ? GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: mensajeModel.mensaje));
                Fluttertoast.showToast(
                  msg: 'Mensaje copiado',
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
              child: Column(
                crossAxisAlignment:
                    mensajeModel.usuario == controller.usuario.documentId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: <Widget>[
                  mensajeModel.usuario == controller.usuario.documentId
                      ? Text(
                          'Tú',
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        )
                      : Text(amix),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: Text(mensajeModel.mensaje)),
                      SizedBox(width: 10),
                      Text(
                        controller.fecha(mensajeModel.fecha),
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            )
          //Mensaje de tipo imagen
          : mensajeModel.tipo == '1'
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/imageViewer',
                        arguments: mensajeModel.imagen);
                  },
                  child: Column(
                    crossAxisAlignment:
                        mensajeModel.usuario == controller.usuario.documentId
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: <Widget>[
                      mensajeModel.usuario == controller.usuario.documentId
                          ? Text(
                              'Tú',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black87),
                            )
                          : Text(amix),
                      SizedBox(height: 5),
                      CachedNetworkImage(
                        cacheManager: DefaultCacheManager(),
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                        imageUrl: mensajeModel.imagen,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(height: 5),
                      Text(
                        controller.fecha(mensajeModel.fecha),
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                )
              //Mensaje de tipo gif
              : mensajeModel.tipo == '2'
                  ? Column(
                      crossAxisAlignment:
                          mensajeModel.usuario == controller.usuario.documentId
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: <Widget>[
                        mensajeModel.usuario == controller.usuario.documentId
                            ? Text(
                                'Tú',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black87),
                              )
                            : Text(amix),
                        SizedBox(height: 5),
                        Image.network(mensajeModel.gif,
                            headers: {'accept': 'image/*'}),
                        SizedBox(height: 5),
                        Text(
                          controller.fecha(mensajeModel.fecha),
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    )
                  : Container(),
    );
  }
}
