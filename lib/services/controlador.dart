import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class Controller with ChangeNotifier {
  int pestana_act = 0;
  String uid = '';
  String name = '';
  String email = '';
  String imageUrl = '';
  String activeToken;
  bool loading = false;
  String sexo;
  String tipo;

  permissonDeniedDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '¡La aplicación no puede acceder a tus fotos y a tu camara por que no le has asignado los permisos, ve a la configuración de tu celular y asignale los permisos!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                onPressed: () async =>
                    await PermissionHandler().openAppSettings(),
                label: Text('Configuración'),
                icon: Icon(Icons.settings),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getImageCamera(BuildContext context) async {
    var permisson = await checkGalerryPermisson(true);
    if (permisson) {
      var image = await ImagePicker.pickImage(
          source: ImageSource.camera, maxHeight: 750, maxWidth: 750).catchError((onError) => permissonDeniedDialog(context));

      return image;
    } else {
      return permissonDeniedDialog(context);
    }
  }

  Future getImage(BuildContext context) async {
    var permisson = await checkGalerryPermisson(false);
    if (permisson) {
      var image = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 750, maxWidth: 750).catchError((onError) => permissonDeniedDialog(context));

      return image;
    } else {
      return permissonDeniedDialog(context);
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Future<bool> checkGalerryPermisson(bool camera) async {
    if (Platform.isIOS) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(
              camera ? PermissionGroup.camera : PermissionGroup.photos);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler().requestPermissions(
                [camera ? PermissionGroup.camera : PermissionGroup.photos]);
        if (permissions[PermissionStatus] != PermissionStatus.granted) {
          return false;
        }
      } else {
        return true;
      }
    } else {
      PermissionHandler permissionHandler = PermissionHandler();
      var idk = await permissionHandler.checkPermissionStatus(
          camera ? PermissionGroup.camera : PermissionGroup.storage);
      print('Permisos stauts!!! ' + idk.toString());
      if (idk == PermissionStatus.neverAskAgain) {
        return false;
      } else {
        return true;
      }
    
    }
    return true;
  }

  UsuarioModel usuario_act = UsuarioModel(
    nombre: 'No name',
    foto: '',
  );

  UsuarioModel get usuario => usuario_act;

  notify() {
    notifyListeners();
  }

  AdopcionModel adopcion;

  storeToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.getToken().then((value) {
      activeToken = value;
      usuario.reference.updateData({
        'tokens': FieldValue.arrayUnion([value])
      });
    });
  }

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await googleSignIn.signOut();
    await usuario.reference.updateData({
      'tokens': FieldValue.arrayRemove([activeToken])
    });
    await prefs.clear();
    uid = '';
    name = '';
    imageUrl = '';
    email = '';
  }

  signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('correo', usuario_act.correo);
    await storeToken();
  }

  Future<bool> signInCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('correo') == null) {
      return false;
    } else {
      await Firestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: prefs.getString('correo'))
          .getDocuments()
          .then((onValue) {
        usuario_act =
            UsuarioModel.fromDocumentSnapshot(onValue.documents.first);
      });
      await storeToken();
      return true;
    }
  }

  agregausuario(UsuarioModel usuario) {
    usuario_act = usuario;
  }

  double latitudfinal;
  double longitudfinal;
}
