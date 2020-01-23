import 'package:flutter/material.dart';
import 'package:adoption_app/services/services.dart';

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
    edad =  calculateAge(data['fnacimiento'].toDate());
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
      this.documentId
      ,this.fecha, this.userName});

  RescateModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'] ?? '';
    favoritos = data['favoritos'] ?? [''];
    ubicacion = data['ubicacion'] ?? [''];
    descripcion = data['descripcion'];
    fotos = data['fotos']  ?? [''];
    tipoAnimal = data['tipoAnimal'];
    foto = data['foto'];
    documentId = data.documentID.toString();
    reference = data.reference;
    fecha = data['fecha'].toDate();
    userName = data['userName'];
  }
}

class EmergenciaModel {
  String titulo;
  String tipoEmergencia;
  String ubicacion;
  String descripcion;
  String foto;
  List<dynamic> favoritos = [];
  String tipoAnimal;
  String documentId;
  String userName;
  DocumentReference reference;

  EmergenciaModel(
      {this.titulo,
      this.tipoEmergencia,
      this.ubicacion,
      this.descripcion,
      this.foto,
      this.tipoAnimal,
      this.documentId,
      this.userName});

  EmergenciaModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];
    favoritos = data['favoritos'] ?? [''];
    tipoEmergencia = data['tipo_emergencia'];
    ubicacion = data['ubicacion'];
    descripcion = data['descripcion'];
    foto = data['foto'];
    tipoAnimal = data['tipo_animal'];
    userName = data['userName'];
    documentId = data.documentID.toString();
    reference = data.reference;
  }
}

class PerdidoModel {
  String titulo;
  String descripcion;
  String tipoAnimal;
  String ubicacion;
  String foto;
  bool recompensa;
  String raza;
  String senasPart;
  String sexo;
  List<dynamic> favoritos = [];
  Timestamp fechaExtravio;
  String documentId;
  DocumentReference reference;

  PerdidoModel({
    this.titulo,
    this.descripcion,
    this.tipoAnimal,
    this.ubicacion,
    this.foto,
    this.recompensa,
    this.raza,
    this.senasPart,
    this.sexo,
    this.fechaExtravio,
    this.documentId,
  });

  PerdidoModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];
    favoritos = data['favoritos'] ?? [''];
    descripcion = data['descripcion'];
    tipoAnimal = data['tipo_animal'];
    ubicacion = data['ubicacion'];
    foto = data['foto'];
    recompensa = data['recompensa'];
    raza = data['raza'];
    senasPart = data['senas_part'];
    sexo = data['sexo'];
    fechaExtravio = data['fecha_extravio'];
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

class AvisoModel{
  String imagen;
  String link;
  AvisoModel({this.imagen, this.link});
  AvisoModel.fromDocumentSnapshot(DocumentSnapshot data){
    imagen =  data['imagen'];
    link = data['link'];
  }
}