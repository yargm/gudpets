import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

class Controller with ChangeNotifier {
  int pestanaAct = 0;
  String uid = '';
  String name = '';
  String email = '';
  String imageUrl = '';
  String activeToken;
  bool loading = false;
  String sexo;
  String tipo;
  GeoPoint _currentLocation;
  var location = Location();
  double latitud;
  double longitud;
  String edo;
  String municipio;

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
                '¡La aplicación necesita que le asignes los permisos necesarios para utilizar esta función, ve a la configuración de tu celular y asignale los permisos!',
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
              source: ImageSource.camera, maxHeight: 750, maxWidth: 750)
          .catchError((onError) => permissonDeniedDialog(context));

      return image;
    } else {
      return permissonDeniedDialog(context);
    }
  }

  Future getImage(BuildContext context) async {
    var permisson = await checkGalerryPermisson(false);
    if (permisson) {
      var image = await ImagePicker.pickImage(
              source: ImageSource.gallery, maxHeight: 750, maxWidth: 750)
          .catchError((onError) => permissonDeniedDialog(context));

      return image;
    } else {
      return permissonDeniedDialog(context);
    }
  }

  Future getAddress(BuildContext context, bool useraddress) async {
    final coordinates = useraddress
        ? new Coordinates(latitud, longitud)
        : new Coordinates(latitudfinal, longitudfinal);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var direccion = addresses.first;
    edo = '${direccion.adminArea}';
    municipio = '${direccion.locality}';
  }

  Future setAddress() async {
    Fluttertoast.showToast(
        msg: 'recibo ' +
            edo +
            ' , ' +
            municipio +
            ' y tengo ' +
            usuario.edo +
            ' , ' +
            usuario.municipio);
    //no actualizar nada
    if (usuario.edo == edo && usuario.municipio == municipio) {
      Fluttertoast.showToast(msg: 'no hice nada');
    }
    //actualizar solo estado
    else if (usuario.edo != edo && usuario.municipio == municipio) {
      await usuario.reference.updateData({'edo': edo});
      Fluttertoast.showToast(msg: 'actualicé estado');
    }
    //actualizar solo municipio
    else if (usuario.edo == edo && usuario.municipio != municipio) {
      await usuario.reference.updateData({'municipio': municipio});
      Fluttertoast.showToast(msg: 'actualicé municipio');
    } else {
      await usuario.reference.updateData({'edo': edo});
      await usuario.reference.updateData({'municipio': municipio});
      Fluttertoast.showToast(msg: 'actualicé ambos');
    }
  }

  Future<GeoPoint> getLocation(BuildContext context) async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation =
          GeoPoint(userLocation.latitude, userLocation.longitude);
      latitud = _currentLocation.latitude;
      longitud = _currentLocation.longitude;
      Fluttertoast.showToast(msg: 'tengo la ubicación');
    } catch (e) {
      print(e.toString());
    }
    return _currentLocation;
  }

  Future<bool> checkLocationPermisson() async {
    if (Platform.isIOS) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.locationWhenInUse);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.locationWhenInUse]);
        if (permissions[PermissionStatus] != PermissionStatus.granted) {
          return false;
        }
      } else {
        return true;
      }
    } else {
      PermissionHandler permissionHandler = PermissionHandler();
      var idk = await permissionHandler
          .checkPermissionStatus(PermissionGroup.locationWhenInUse);
      print('Permisos stauts!!! ' + idk.toString());
      if (idk == PermissionStatus.neverAskAgain) {
        return false;
      } else {
        return true;
      }
    }
    return true;
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

  UsuarioModel usuarioActual = UsuarioModel(
    nombre: 'No name',
    foto: '',
  );

  UsuarioModel get usuario => usuarioActual;

  notify() {
    notifyListeners();
  }

  AdopcionModel adopcion;
  MascotaModel mascota;

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
    prefs.setString('correo', usuarioActual.correo);
    await storeToken();
    await setAddress();
  }

  Future<bool> signInCheck(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('correo') == null) {
      return false;
    } else {
      await Firestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: prefs.getString('correo'))
          .getDocuments()
          .then((onValue) {
        usuarioActual =
            UsuarioModel.fromDocumentSnapshot(onValue.documents.first);

        setAddress();
      });
      await storeToken();
      return true;
    }
  }

  agregausuario(UsuarioModel usuario) {
    usuarioActual = usuario;
  }

  double latitudfinal;
  double longitudfinal;
}
