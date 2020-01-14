import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  String contrasena;
  String correo;
  String descripcion;
  int edad;
  String foto;
  String nombre;
  String sexo;
  int telefono;
  String tipo;
  int user_id;
  String document_id;

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
      this.user_id,
      this.document_id});

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot data) {
    contrasena = data['tcontrasena'];
    correo = data['correo'];
    descripcion = data['descripcion'];
    edad = data['edad'];
    foto = data['foto'];
    nombre = data['nombre'];
    sexo = data['sexo'];
    telefono = data['telefono'];
    tipo = data['tipo'];
    user_id = data['user_id'];
    document_id = data.documentID.toString();
  }
}

class EmergenciaModel {
  String titulo;
  String tipo_emergencia;
  String ubicacion;
  String descripcion;
  int user_id;
  int emergencia_id;
  String foto;
  String tipo_animal;
  String document_id;

  EmergenciaModel(
      {this.titulo,
      this.tipo_emergencia,
      this.ubicacion,
      this.descripcion,
      this.user_id,
      this.emergencia_id,
      this.foto,
      this.tipo_animal,
      this.document_id});

  EmergenciaModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'] ?? '';
    tipo_emergencia = data['tipo_emergencia'];
    ubicacion = data['ubicacion'];
    descripcion = data['descripcion'];
    user_id = data['user_id'];
    foto = data['foto'];
    tipo_animal = data['tipo_animal'];
    emergencia_id = data['emergencia_id'];
    document_id = data.documentID.toString();
  }
}



class RescateModel {
  String descripcion;
  String ubicacion;
  int telefono;
  int user_id;
  int rescate_id;
 dynamic fotos;
  String tipo_animal; 
  String titulo;
  String foto;

  RescateModel(
      {this.fotos,
      this.rescate_id,
      this.ubicacion,
      this.descripcion,
      this.user_id,
      this.telefono,
      this.tipo_animal,
      this.titulo,
      this.foto
      });

 RescateModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'] ?? '';
    ubicacion = data['ubicacion'];
    descripcion = data['descripcion'];
    user_id = data['user_id'];
    fotos = data['fotos'];
    tipo_animal = data['tipo_animal'];
    rescate_id = data['rescate_id'];
    foto = data['foto'];
    
  }
}
