import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalModel {
  String nombre;
  String foto;
  String desc;
  String tipo;
  bool desparacitacion; 
  String edad;
  bool esterilizacion;
  bool vacunacion;
  dynamic album;


  AnimalModel(
      {this.desc,
      this.nombre,
      this.foto,
      this.tipo,
      this.desparacitacion,
      this.edad,
      this.esterilizacion,
      this.vacunacion,
      this.album});

  AnimalModel.fromDocumentSnapshot(DocumentSnapshot data) {
    foto = data['foto'];
    desc = data['desc'];
    nombre = data['nombre'];
    tipo = data['tipo'];
    desparacitacion = data['desparacitacion'];
    edad = data['edad'];
    esterilizacion = data['esterilizacion'];
    vacunacion = data['vacunacion'];
    album = data['album'];
  }
}