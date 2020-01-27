import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';

import 'package:location/location.dart';

class UserLocation {
  final double latitud;
  final double longitud;

  UserLocation({this.latitud, this.longitud});
}

class UsuarioModel {
  String contrasena;
  String correo;
  String descripcion;
  int edad;
  DateTime fnacimiento;
  String foto;
  String nombre;
  String sexo;
  int telefono;
  DocumentReference reference;
  String tipo;
  String documentId;

  UsuarioModel(
      {this.contrasena,
      this.correo,
      this.descripcion,
      this.edad,
      this.foto,
      this.nombre,
      this.sexo,
      this.telefono,
      this.tipo,
      this.documentId});

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot data) {
    contrasena = data['tcontrasena'];
    correo = data['correo'];
    descripcion = data['descripcion'];
    edad = calculateAge(data['fnacimiento'].toDate());
    foto = data['foto'];
    nombre = data['nombre'];
    sexo = data['sexo'];
    telefono = data['telefono'];
    tipo = data['tipo'];
    reference = data.reference;
    documentId = data.documentID.toString();
    fnacimiento = data['fnacimiento'].toDate();
  }
}

class RescateModel {
  String descripcion;
  String ubicacion;
  int telefono;
  List<dynamic> favoritos = [];
  dynamic fotos;
  String tipoAnimal;
  String titulo;
  String foto;
  String documentId;
  DateTime fecha;
  String userName;
  DocumentReference reference;
  RescateModel(
      {this.fotos,
      this.ubicacion,
      this.descripcion,
      this.telefono,
      this.tipoAnimal,
      this.titulo,
      this.foto,
      this.documentId,
      this.fecha,
      this.userName});

  RescateModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'] ?? '';
    favoritos = data['favoritos'] ?? [''];
    ubicacion = data['ubicacion'] ?? [''];
    descripcion = data['descripcion'];
    fotos = data['fotos'] ?? [''];
    tipoAnimal = data['tipoAnimal'];
    foto = data['foto'];
    documentId = data.documentID.toString();
    reference = data.reference;
    fecha = data['fecha'].toDate();
    userName = data['userName'];
  }
}

class EmergenciaModel {
  String foto;
  String titulo;
  String descripcion;
  String tipoAnimal;
  String tipoEmergencia;
  GeoPoint ubicacion;
  DateTime fecha;

  String userName;
  String userId;
  String documentId;
  List<dynamic> favoritos = [];
  DocumentReference reference;

  EmergenciaModel(
      {this.foto,
      this.titulo,
      this.descripcion,
      this.tipoAnimal,
      this.tipoEmergencia,
      this.ubicacion,
      this.fecha,
      this.userName,
      this.documentId,
      this.userId});

  EmergenciaModel.fromDocumentSnapshot(DocumentSnapshot data) {
    foto = data['foto'];
    titulo = data['titulo'];
    descripcion = data['descripcion'];
    tipoAnimal = data['tipoAnimal'];
    tipoEmergencia = data['tipoEmergencia'];
    userName = data['userName'];
    ubicacion = data['ubicacion'];
    fecha = data['fecha'].toDate();
    userId = data['userId'];

    favoritos = data['favoritos'] ?? [''];
    documentId = data.documentID.toString();
    reference = data.reference;
  }
}

class PerdidoModel {
  String titulo;
  String foto;
  String descripcion;
  String tipoAnimal;
  String raza;
  String sexo;
  String senasPart;
  DateTime fechaExtravio;
  DateTime fecha;
  GeoPoint ubicacion;
  bool recompensa;
  int telefono;
  String userId;
  String userName;
  String documentId;
  List<dynamic> favoritos = [];
  DocumentReference reference;

  PerdidoModel(
      {this.titulo,
      this.foto,
      this.descripcion,
      this.tipoAnimal,
      this.ubicacion,
      this.recompensa,
      this.raza,
      this.sexo,
      this.senasPart,
      this.fechaExtravio,
      this.fecha,
      this.userName,
      this.documentId,
      this.telefono,
      this.userId});

  PerdidoModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];
    foto = data['foto'];
    descripcion = data['descripcion'];
    fechaExtravio = data['fechaExtravio'].toDate();
    raza = data['raza'];
    recompensa = data['recompensa'];
    sexo = data['sexo'];
    senasPart = data['senasPart'];
    tipoAnimal = data['tipoAnimal'];
    ubicacion = data['ubicacion'];
    fecha = data['fecha'].toDate();
    userName = data['userName'];
    telefono = data['telefono'];
    userId = data['userId'];

    favoritos = data['favoritos'] ?? [''];
    documentId = data.documentID.toString();
    reference = data.reference;
  }
}

class AdopcionModel {
  String titulo;
  List<dynamic> favoritos = [];
  String descripcion;
  String tipoAnimal;
  String foto;
  String sexo;
  String edad;
  bool esterilizacion;
  bool vacunacion;
  bool desparacitacion;
  bool convivenciaotros;
  String documentId;
  DocumentReference reference;

  AdopcionModel(
      {this.titulo,
      this.descripcion,
      this.tipoAnimal,
      this.foto,
      this.sexo,
      this.edad,
      this.esterilizacion,
      this.vacunacion,
      this.desparacitacion,
      this.convivenciaotros,
      this.documentId});

  AdopcionModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];

    favoritos = data['favoritos'] ?? [''];
    descripcion = data['descripcion'];
    tipoAnimal = data['tipo_animal'];
    foto = data['foto'];
    sexo = data['sexo'];
    edad = data['edad'];
    esterilizacion = data['esterilizacion'];
    vacunacion = data['vacunacion'];
    desparacitacion = data['desparacitacion'];
    convivenciaotros = data['convivenciaotros'];
    documentId = data.documentID.toString();
    reference = data.reference;
  }
}

class AvisoModel {
  String imagen;
  String link;
  AvisoModel({this.imagen, this.link});
  AvisoModel.fromDocumentSnapshot(DocumentSnapshot data) {
    imagen = data['imagen'];
    link = data['link'];
  }
}
