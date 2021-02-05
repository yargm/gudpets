import 'package:flutter/material.dart';
import 'package:gudpets/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as locations;
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io' show Platform;

class Controller with ChangeNotifier {
  List<String> mascotas = [];
  List<Asset> images = List<Asset>();
  UsuarioModel selectedUser;

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
  var location = locations.Location();
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
                onPressed: () async =>await PermissionHandler().openAppSettings(),
                label: Text('Configuración'),
                icon: Icon(Icons.settings),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future multiImage(BuildContext context) async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    var permisson = await checkGalerryPermisson(false);
    if (permisson) {
      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 4,
          enableCamera: true,
          selectedAssets: images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#FF795548",
            actionBarTitle: "GudPets",
            allViewTitle: "Todas las fotos",
            useDetailsView: true,
            selectCircleStrokeColor: "#FFFFFF",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
        print(error);
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      //if (!mounted) return;

      images = resultList;
      return images;
    } else {
      return permissonDeniedDialog(context);
    }
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
      await usuario.reference.update({'edo': edo});
      Fluttertoast.showToast(msg: 'actualicé estado');
    }
    //actualizar solo municipio
    else if (usuario.edo == edo && usuario.municipio != municipio) {
      await usuario.reference.update({'municipio': municipio});
      Fluttertoast.showToast(msg: 'actualicé municipio');
    } else {
      await usuario.reference.update({'edo': edo});
      await usuario.reference.update({'municipio': municipio});
      Fluttertoast.showToast(msg: 'actualicé ambos');
    }
  }

    Future<bool> checkPermission() async {
    final permissionStorageGroup =
        Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
    Map<PermissionGroup, PermissionStatus> res =
        await PermissionHandler().requestPermissions([
      permissionStorageGroup,
    ]);
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }

  Future<GeoPoint> getLocation(BuildContext context) async {
    try {
      var userLocation = location.getLocation();
      double latitude;
      userLocation.then((value) => latitude.toDouble());
      double longitude;
      userLocation.then((value) => longitude.toDouble());
      _currentLocation = GeoPoint(latitude, longitude);
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
      usuario.reference.update({
        'tokens': FieldValue.arrayUnion([value])
      });
    });
  }

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await googleSignIn.signOut();
    await usuario.reference.update({
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

  fecha(Timestamp fecha) {
    String mes;
    switch (fecha.toDate().month) {
      case 1:
        mes = 'ene';
        break;
      case 2:
        mes = 'feb';
        break;
      case 3:
        mes = 'mar';
        break;
      case 4:
        mes = 'abr';
        break;
      case 5:
        mes = 'may';
        break;
      case 6:
        mes = 'jun';
        break;
      case 7:
        mes = 'jul';
        break;
      case 8:
        mes = 'ago';
        break;
      case 9:
        mes = 'sep';
        break;
      case 10:
        mes = 'oct';
        break;
      case 11:
        mes = 'nov';
        break;
      case 12:
        mes = 'dic';
        break;
    }
    return fecha.toDate().day.toString() +
        ' ' +
        mes +
        ' ' +
        fecha.toDate().hour.toString() +
        ':' +
        fecha.toDate().minute.toString();
  }

  Future<bool> signInCheck(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('correo') == null) {
      return false;
    } else {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .where('correo', isEqualTo: prefs.getString('correo'))
          .get()
          .then((onValue) {
        usuarioActual =
            UsuarioModel.fromDocumentSnapshot(onValue.docs.first, 'meh');

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
