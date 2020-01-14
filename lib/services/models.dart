import 'package:cloud_firestore/cloud_firestore.dart';

class EmergenciaModel {
  String titulo;
  String tipo_emergencia;
  String ubicacion;
  String descripcion;
  int user_id;
  int emergencia_id;
  String foto;
  String tipo_animal; 

  EmergenciaModel(
      {this.titulo,
      this.tipo_emergencia,
      this.ubicacion,
      this.descripcion,
      this.user_id,
      this.emergencia_id,
      this.foto,
      this.tipo_animal,
      });

  EmergenciaModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];
    tipo_emergencia = data['tipo_emergencia'];
    ubicacion = data['ubicacion'];
    descripcion = data['descripcion'];
    user_id = data['user_id'];
    foto = data['foto'];
    tipo_animal = data['tipo_animal'];
    emergencia_id = data['emergencia_id'];
    
  }
}