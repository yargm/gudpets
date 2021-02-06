import 'package:gudpets/services/services.dart';

class UsuarioModel {
  String contrasena;
  String correo;
  String descripcion;
  int edad;
  DateTime fnacimiento;
  String foto;
  String fotoStorageRef;
  String nombre;
  String sexo;
  int telefono;
  DocumentReference reference;
  String tipo;
  String documentId;
  // String fotoINE;
  // String fotoINERef;
  // String fotoCompDomi;
  // String fotoCompDomiRef;
  // List<dynamic> galeriaFotos;
  // List<dynamic> galeriaFotosRefs;
  String edo;
  String municipio;
  List<dynamic> amigos;
  List<dynamic> solicitudesAE;
  List<dynamic> bloqueados;
  Timestamp userLastMsg;
  bool userCheck;
  bool userChat;

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
      this.documentId,
      // this.fotoINE,
      this.edo,
      this.municipio});

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

  Map<String, dynamic> toReport(List<String> razones) {
    return {
      'nombre': nombre,
      'foto': foto,
      'razones': razones,
      'correo': correo,
      'uid': uid,
    };
  }

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot data, String user) {
    contrasena = data.data()['tcontrasena'] ?? '';
    correo = data.data()['correo'];
    descripcion = data.data()['descripcion'] ?? '';
    edad = calculateAge(data.data()['fnacimiento'].toDate());
    foto = data.data()['foto'];
    nombre = data.data()['nombre'];
    sexo = data.data()['sexo'];
    telefono = data.data()['telefono'];
    tipo = data.data()['tipo'];
    reference = data.reference;
    documentId = data.id.toString();
    fnacimiento = data.data()['fnacimiento'].toDate();
    fotoStorageRef = data.data()['fotoStorageRef'];
    // fotoCompDomi = data['fotoCompDomi'];
    // fotoCompDomiRef = data['fotoCompDomiRef'];
    // fotoINE = data['fotoINE'];
    // fotoINERef = data['fotoINERef'];
    // galeriaFotos = data['galeriaFotos'] ?? [];
    // galeriaFotosRefs = data['galeriaFotosRefs'] ?? [];
    edo = data.data()['edo'] ?? '';
    municipio = data.data()['municipio'] ?? '';
    amigos = data.data()['amigos'] ?? [];
    amigos = List<String>.from(amigos);
    solicitudesAE = data.data()['solicitudesAE'] ?? [];
    solicitudesAE = List<String>.from(solicitudesAE);
    bloqueados = data.data()['bloqueados'] ?? [];
    bloqueados = List<String>.from(bloqueados);
    userCheck = data.data()[user + 'Check'] ?? true;
    userLastMsg = data.data()[user + 'LastMsg'] ?? null;
    userChat = data.data()[user + 'Chat'] ?? false;
  }
}

class RescateModel {
  String descripcion;
  GeoPoint ubicacion;
  int telefono;
  List<dynamic> favoritos = [];
  String tipoAnimal;
  String titulo;
  String foto;
  String documentId;
  DateTime fecha;
  String userName;
  String userId;
  dynamic albumrefs;
  String reffoto;
  dynamic fotos;

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
      this.userName,
      this.userId,
      this.albumrefs,
      this.reffoto});

  RescateModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'] ?? '';
    favoritos = data['favoritos'] ?? [''];
    ubicacion = data['ubicacion'] ?? [''];
    descripcion = data['descripcion'];
    tipoAnimal = data['tipoAnimal'];
    foto = data['foto'];
    documentId = data.id.toString();
    reference = data.reference;
    fecha = data['fecha'].toDate();
    userName = data['userName'];
    userId = data['userId'];
    fotos = data['fotos'] ?? [''];
    albumrefs = data['albumrefs'] ?? [''];
    reffoto = data['reffoto'];
    telefono = data['telefono'];
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
  String reffoto;

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
      this.userId,
      this.reffoto});

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
    reffoto = data['reffoto'];

    favoritos = data['favoritos'] ?? [''];
    documentId = data.id.toString();
    reference = data.reference;
  }
}

class PerdidoModel {
  String reffoto;
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
  String recompensa;
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
      this.userId,
      this.reffoto});

  PerdidoModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];
    foto = data['foto'];
    descripcion = data['descripcion'];
    fechaExtravio = data['fechaExtravio'].toDate();
    raza = data['raza'];
    recompensa = data['recompensa'] ?? '';
    sexo = data['sexo'];
    senasPart = data['senasPart'];
    tipoAnimal = data['tipoAnimal'];
    ubicacion = data['ubicacion'];
    fecha = data['fecha'].toDate();
    userName = data['userName'];
    telefono = data['telefono'];
    userId = data['userId'];
    reffoto = data['reffoto'];

    favoritos = data['favoritos'] ?? [''];
    documentId = data.id.toString();
    reference = data.reference;
  }
}

class AdopcionModel {
  String estado;
  String municipio;
  String titulo;
  List<dynamic> favoritos = [];
  String descripcion;
  String tipoAnimal;
  String sexo;
  String edad;
  bool esterilizacion;
  bool vacunacion;
  bool desparacitacion;
  bool convivenciaotros;
  String documentId;
  DocumentReference reference;
  DateTime fecha;
  String userId;
  dynamic albumrefs;
  dynamic fotos;
  String status;
  String adoptanteId;

  AdopcionModel(
      {this.titulo,
      this.descripcion,
      this.tipoAnimal,
      this.sexo,
      this.edad,
      this.esterilizacion,
      this.vacunacion,
      this.desparacitacion,
      this.convivenciaotros,
      this.fecha,
      this.documentId,
      this.userId,
      this.albumrefs,
      this.fotos,
      this.status,
      this.adoptanteId,
      this.estado,
      this.municipio});

  AdopcionModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data.data()['titulo'];
    favoritos = data.data()['favoritos'] ?? [''];
    descripcion = data.data()['descripcion'];
    tipoAnimal = data.data()['tipoAnimal'];
    sexo = data.data()['sexo'];
    edad = data.data()['edad'];
    estado = data.data()['estado'];
    municipio = data.data()['municipio'];
    fecha = data.data()['fecha'].toDate();
    fotos = data.data()['fotos'] ?? [''];
    albumrefs = data.data()['albumrefs'] ?? [''];
    esterilizacion = data.data()['esterilizacion'];
    vacunacion = data.data()['vacunacion'];
    desparacitacion = data.data()['desparacitacion'];
    convivenciaotros = data.data()['convivenciaotros'];
    userId = data.data()['userId'];
    documentId = data.id.toString();
    reference = data.reference;
    status = data.data()['status'];
    adoptanteId = data.data()['adoptanteId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'favoritos': favoritos,
      'descripcion': descripcion,
      'tipoAnimal': tipoAnimal,
      'sexo': sexo,
      'estado': estado,
      'municipio': municipio,
      'edad': edad,
      'fecha': fecha,
      'fotos': fotos,
      'albumrefs': albumrefs,
      'esterilizacion': esterilizacion,
      'vacunacion': vacunacion,
      'desparacitacion': desparacitacion,
      'convivenciaotros': convivenciaotros,
      'userId': userId,
      'documentId': documentId,
      'reference': reference,
      'status': status,
      'adoptanteId': adoptanteId,
    };
  }
}

class SolicitudModel {
  String correo;
  String descripcion;
  int edad;
  DateTime fnacimiento;
  String foto;
  String fotoStorageRef;
  String nombre;
  String sexo;
  int telefono;
  DocumentReference reference;
  String tipo;
  String userId;
  // String fotoINE;
  // String fotoINERef;
  // String fotoCompDomi;
  // String fotoCompDomiRef;
  // List<dynamic> fotosHogar;
  // List<dynamic> fotosHogarRefs;
  // List<dynamic> galeriaFotos;
  // List<dynamic> galeriaFotosRefs;
  String userIdPub;
  String tituloPub;

  SolicitudModel(
      {this.correo,
      this.descripcion,
      this.edad,
      this.foto,
      this.nombre,
      this.sexo,
      this.telefono,
      this.tipo,
      this.userIdPub,
      this.tituloPub,
      this.userId});

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

  SolicitudModel.fromDocumentSnapshot(DocumentSnapshot data) {
    correo = data['correo'];
    descripcion = data['descripcion'];
    edad = calculateAge(data['fnacimiento'].toDate());
    foto = data['foto'];
    nombre = data['nombre'];
    sexo = data['sexo'];
    telefono = data['telefono'];
    tipo = data['tipo'];
    reference = data.reference;
    userId = data['userId'];
    fnacimiento = data['fnacimiento'].toDate();
    fotoStorageRef = data['fotoStorageRef'];

    // fotoCompDomi = data['fotoCompDomi'];
    // fotoCompDomiRef = data['fotoCompDomiRef'];
    // fotoINE = data['fotoINE'];
    // fotoINERef = data['fotoINERef'];
    // galeriaFotos = data['galeriaFotos'] ?? [];
    // galeriaFotosRefs = data['galeriaFotosRefs'] ?? [];
    userIdPub = data['userIdPub'];
    tituloPub = data['tituloPub'];
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

class MensajeModel {
  String mensaje;
  String recibe;
  String imagen;
  String gif;
  String usuario;
  Timestamp fecha;
  String tipo;

  MensajeModel.fromDS(DocumentSnapshot ds) {
    fecha = ds.data()['fecha'] ?? Timestamp(0, 0);
    usuario = ds.data()['usuario'] ?? '';
    mensaje = ds.data()['mensaje'] ?? '';
    tipo = ds.data()['tipo'] ?? '';
    imagen = ds.data()['imagen'] ?? '';
    gif = ds.data()['gif'] ?? '';
    recibe = ds.data()['recibe'] ?? '';
  }
}

class ChatModel {
  dynamic usuarios;
  dynamic ids;

  ChatModel({this.usuarios, this.ids});
  ChatModel.fromDocumentSnapshot(DocumentSnapshot data) {
    usuarios = data.data()['usuarios'] ?? '';
    ids = data.data()['ids'] ?? '';
  }
}

class MascotaModel {
  String personalidad;
  int anios;
  int meses;
  String foto;
  String storageRef;
  String nombre;
  String tamano;
  String tipoAnimal;
  bool buscaAmigos;
  String sexo;
  DateTime fnacimiento;
  String documentId;
  DocumentReference reference;
  //String documentId;

  MascotaModel({
    this.anios,
    this.documentId,
    this.meses,
    this.foto,
    this.nombre,
    this.personalidad,
    this.storageRef,
    this.tamano,
    this.tipoAnimal,
    this.sexo,
    this.fnacimiento,
    this.buscaAmigos,
    //this.documentId
  });
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

  int calculateMonths(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (age == 0) {
      int month1 = currentDate.month;
      int month2 = birthDate.month;
      if (month2 > month1) {
        age--;
      } else {
        age = currentDate.month - birthDate.month;

        print('meses ${age}');

        return age;
      }
    }
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

  MascotaModel.fromDocumentSnapshot(DocumentSnapshot data) {
    fnacimiento = data['fnacimiento'].toDate();
    personalidad = data['personalidad'] ?? '';
    anios = calculateAge(data['fnacimiento'].toDate());
    meses = calculateMonths(data['fnacimiento'].toDate());
    foto = data['foto'];
    nombre = data['nombre'];
    sexo = data['sexo'];
    tipoAnimal = data['tipoAnimal'];
    reference = data.reference;
    storageRef = data['storageRef'];
    documentId = data.id.toString();
    // documentId = data.documentID.toString() ?? '';
    tamano = data['tamano'];
    buscaAmigos = data['buscaAmigos'];
  }
  // int calculateAge(DateTime birthDate) {
  //   DateTime currentDate = DateTime.now();
  //   int age = currentDate.year - birthDate.year;
  //   int month1 = currentDate.month;
  //   int month2 = birthDate.month;
  //   if (month2 > month1) {
  //     age--;
  //   } else if (month1 == month2) {
  //     int day1 = currentDate.day;
  //     int day2 = birthDate.day;
  //     if (day2 > day1) {
  //       age--;
  //     }
  //   }
  //   return age;
  // }
}

class PostsModel {
  String storageRef;

  String foto;
  String descripcion;
  bool privacidad;
  DateTime fecha;
  List<dynamic> mascotas = [];
  String userId;
  String usuario;
  String documentId;
  List<dynamic> favoritos = [];
  DocumentReference reference;
  int numlikes;

  PostsModel(
      {this.foto,
      this.descripcion,
      this.fecha,
      this.favoritos,
      this.mascotas,
      this.privacidad,
      this.storageRef,
      this.usuario,
      this.documentId,
      this.numlikes,
      this.userId});

  PostsModel.fromDocumentSnapshot(DocumentSnapshot data) {
    foto = data['foto'];
    descripcion = data['descripcion'];
    numlikes = data['numlikes'];
    fecha = data['fecha'].toDate();
    usuario = data['usuario'];
    privacidad = data['privacidad'] ?? [''];
    userId = data['userId'];
    storageRef = data['storageRef'];
    mascotas = data['mascotas'] ?? [''];
    favoritos = data['favoritos'] ?? [''];
    documentId = data.id.toString();
    reference = data.reference;
  }
}

class ComentarioModel {
  String comentario;
  DateTime fecha;
  String userId;
  String documentId;
  List<dynamic> likes = [];
  DocumentReference reference;
  //int numlikes;

  ComentarioModel(
      {this.comentario, this.fecha, this.likes, this.documentId, this.userId});

  ComentarioModel.fromDocumentSnapshot(DocumentSnapshot data) {
    //numlikes = data['numlikes'];
    fecha = data['fecha'].toDate();
    comentario = data['comentario'];
    userId = data['userId'];

    likes = data['likes'] ?? [''];
    documentId = data.id.toString();
    reference = data.reference;
  }
}
