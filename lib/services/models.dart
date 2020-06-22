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

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot data) {
    contrasena = data['tcontrasena'];
    correo = data['correo'];
    descripcion = data['descripcion'] ?? '';
    edad = calculateAge(data['fnacimiento'].toDate());
    foto = data['foto'];
    nombre = data['nombre'];
    sexo = data['sexo'];
    telefono = data['telefono'];
    tipo = data['tipo'];
    reference = data.reference;
    documentId = data.documentID.toString();
    fnacimiento = data['fnacimiento'].toDate();
    fotoStorageRef = data['fotoStorageRef'];
    // fotoCompDomi = data['fotoCompDomi'];
    // fotoCompDomiRef = data['fotoCompDomiRef'];
    // fotoINE = data['fotoINE'];
    // fotoINERef = data['fotoINERef'];
    // galeriaFotos = data['galeriaFotos'] ?? [];
    // galeriaFotosRefs = data['galeriaFotosRefs'] ?? [];
    edo = data['edo'] ?? '';
    municipio = data['municipio'] ?? '';
    amigos = data['amigos'] ?? [];
    amigos=List<String>.from(amigos);
    solicitudesAE = data['solicitudesAE'] ?? [];
    solicitudesAE = List<String>.from(solicitudesAE);
    bloqueados = data['bloqueados'] ?? [];
    bloqueados = List<String>.from(bloqueados);
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
    documentId = data.documentID.toString();
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
    documentId = data.documentID.toString();
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
    documentId = data.documentID.toString();
    reference = data.reference;
  }
}

class AdopcionModel {
  String titulo;
  String userName;
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
  DateTime fecha;
  String userId;
  dynamic albumrefs;
  String reffoto;
  dynamic fotos;
  String status;
  String adoptanteNombre;

  int adoptanteTelefono;
  //String adoptanteINE;
  String adoptanteFoto;
  String adoptanteCorreo;
  String adoptanteId;

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
      this.fecha,
      this.documentId,
      this.userName,
      this.userId,
      this.albumrefs,
      this.reffoto,
      this.fotos,
      this.status,
      this.adoptanteNombre,
     // this.adoptanteINE,
      this.adoptanteFoto,
      this.adoptanteTelefono,
      this.adoptanteId,
      this.adoptanteCorreo});

  AdopcionModel.fromDocumentSnapshot(DocumentSnapshot data) {
    titulo = data['titulo'];
    userName = data['userName'];
    favoritos = data['favoritos'] ?? [''];
    descripcion = data['descripcion'];
    tipoAnimal = data['tipoAnimal'];
    foto = data['foto'];
    sexo = data['sexo'];
    edad = data['edad'];
    fecha = data['fecha'].toDate();
    fotos = data['fotos'] ?? [''];
    albumrefs = data['albumrefs'] ?? [''];
    reffoto = data['reffoto'];
    esterilizacion = data['esterilizacion'];
    vacunacion = data['vacunacion'];
    desparacitacion = data['desparacitacion'];
    convivenciaotros = data['convivenciaotros'];
    userId = data['userId'];
    documentId = data.documentID.toString();
    reference = data.reference;
    status = data['status'];
    adoptanteNombre = data['adoptanteNombre'];
    //adoptanteINE = data['adoptanteINE'];
    adoptanteTelefono = data['adoptanteTelefono'];
    adoptanteId = data['adoptanteId'];
    adoptanteFoto = data['adoptanteFoto'];
    adoptanteCorreo = data['adoptanteCorreo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'userName': userName,
      'favoritos': favoritos,
      'descripcion': descripcion,
      'tipoAnimal': tipoAnimal,
      'foto': foto,
      'sexo': sexo,
      'edad': edad,
      'fecha': fecha,
      'fotos': fotos,
      'albumrefs': albumrefs,
      'reffoto': reffoto,
      'esterilizacion': esterilizacion,
      'vacunacion': vacunacion,
      'desparacitacion': desparacitacion,
      'convivenciaotros': convivenciaotros,
      'userId': userId,
      'documentId': documentId,
      'reference': reference,
      'status': status,
      'adoptanteNombre': adoptanteNombre,
      //'adoptanteINE': adoptanteINE,
      'adoptanteTelefono': adoptanteTelefono,
      'adoptanteId': adoptanteId,
      'adoptanteFoto': adoptanteFoto,
      'adoptanteCorreo': adoptanteCorreo,
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
  String imagen;
  String gif;
  String envia;
  Timestamp fecha;
  String tipo;

  MensajeModel.fromDS(DocumentSnapshot ds) {
    fecha = ds['fecha'] ?? Timestamp(0, 0);
    envia = ds['envia'] ?? '';
    mensaje = ds['mensaje'] ?? '';
    tipo = ds['tipo'] ?? '';
    imagen = ds['imagen'] ?? '';
    gif = ds['gif'] ?? '';
  }
}

class ChatModel {
  dynamic usuarios;
  dynamic ids;

  ChatModel({this.usuarios, this.ids});
  ChatModel.fromDocumentSnapshot(DocumentSnapshot data) {
    usuarios = data['usuarios'] ?? '';
    ids = data['ids'] ?? '';
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
  DocumentReference reference;
  //String documentId;
  
 
  

  MascotaModel(
      {
        this.anios,
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
    if(age == 0){
    int month1 = currentDate.month;
    int month2 = birthDate.month;
     if (month2 > month1) {
      age--;
    }else{
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
    personalidad= data['personalidad']?? '';
    anios = calculateAge(data['fnacimiento'].toDate());
    meses = calculateMonths(data['fnacimiento'].toDate());
    foto = data['foto'];
    nombre = data['nombre'];
    sexo = data['sexo'];
    tipoAnimal = data['tipoAnimal'];
    reference = data.reference;    
    storageRef = data['storageRef'];
    
   // documentId = data.documentID.toString() ?? '';
    tamano= data['tamano'];
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

