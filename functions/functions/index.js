const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.nuevaEmergencia = functions.firestore.document('/emergencias/{emergencia}'
).onCreate((snapshot, context) => {
    var emergenciaData = snapshot.data();
    var listaTokens = [];

    admin.firestore().collection('usuarios').get().then((snapshot) => {

        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().tokens != undefined) {
                console.log('tokens definido');
                if (usuario.data().tokens != null) {
                    console.log('tokens no nulo');
                    for (var token of usuario.data().tokens) {
                        console.log('adding token');
                        listaTokens.push(token);
                    }
                }
            }

        }
        var payload = {
            "notification": {
                "title": "Nueva Emergencia!!!",
                "body": emergenciaData.titulo,
                "sound": "default"
            },
            "data": {
                "sendername": emergenciaData.titulo,
                "message": 'idk',
            }
        }

        return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
            console.log('Se enviaron todas las notificaciones');

        }).catch((err) => {
            console.log(err);
        });
    })
})

exports.nuevoAviso = functions.firestore.document('/avisos/{aviso}'
).onCreate((snapshot, context) => {
    var avisoData = snapshot.data();
    var listaTokens = [];

    admin.firestore().collection('usuarios').get().then((snapshot) => {

        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().tokens != undefined) {
                console.log('tokens definido');
                if (usuario.data().tokens != null) {
                    console.log('tokens no nulo');
                    for (var token of usuario.data().tokens) {
                        console.log('adding token');
                        listaTokens.push(token);
                    }
                }
            }

        }
        var payload = {
            "notification": {
                "title": "¡Nuevo aviso!",
                "body": 'Hay un nuevo aviso que podría interesarte.',
                "sound": "default"
            },
            "data": {
                "sendername": 'aviso',
                "message": 'idk',
            }
        }

        return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
            console.log('Se enviaron todas las notificaciones');

        }).catch((err) => {
            console.log(err);
        });
    })
})


exports.nuevaSolicitud = functions.firestore.document('adopciones/{adopcion}/solicitudes/{solicitud}'
).onCreate((snapshot, context) => {
    var solicitudData = snapshot.data();
    var listaTokens = [];

    admin.firestore().collection('usuarios').doc(solicitudData.userIdPub).get().then((snapshot) => {
        var usuario = snapshot;
        if (usuario.data().tokens != undefined) {
            console.log('tokens definido');
            if (usuario.data().tokens != null) {
                console.log('tokens no nulo');
                for (var token of usuario.data().tokens) {
                    console.log('adding token');
                    listaTokens.push(token);
                }
            }
        }



        var payload = {
            "notification": {
                "title": "Nueva solicitud de adopción",
                "body": solicitudData.nombre + " quiere adoptar en tu publicación" + solicitudData.tituloPub,
                "sound": "default"
            },
            "data": {
                "sendername": solicitudData.nombre,
                "message": solicitudData.nombre,
            }
        }

        return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
            console.log('Se enviaron todas las notificaciones');

        }).catch((err) => {
            console.log(err);
        });
    })
})



exports.nuevoPerdido = functions.firestore.document('/perdidos/{perdido}'
).onCreate((snapshot, context) => {
    var perdidoData = snapshot.data();
    var listaTokens = [];

    admin.firestore().collection('usuarios').get().then((snapshot) => {
        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().tokens != undefined) {
                console.log('tokens definido');
                if (usuario.data().tokens != null) {
                    console.log('tokens no nulo');
                    for (var token of usuario.data().tokens) {
                        console.log('adding token');
                        listaTokens.push(token);
                    }
                }
            }

        }
        var payload = {
            "notification": {
                "title": "Nueva Emergencia!!!",
                "body": perdidoData.titulo,
                "sound": "default"
            },
            "data": {
                "sendername": perdidoData.titulo,
                "message": 'idk',
            }
        }

        return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
            console.log('Se enviaron todas las notificaciones');

        }).catch((err) => {
            console.log(err);
        });
    })
})


exports.emergenciaEliminada = functions.firestore.document('/emergencias/{emergencia}'
).onDelete((snapshot, context) => {
    var emergenciaData = snapshot.data();
    var emergenciaID = snapshot.id;

    admin.firestore().collection('usuarios').get().then((snapshot) => {
        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().emergencias != undefined) {
                if (usuario.data().emergencias != null) {
                    for (var adopcion of usuario.data().emergencias) {
                        var documentID = adopcion['documentId'];
                        console.log(adopcion['documentId']);
                        if (documentID == emergenciaID) {
                            usuario.ref.update({ emergencias: admin.firestore.FieldValue.arrayRemove(adopcion) }
                            ).then(() => {
                                console.log('deleted from ' + usuario.data().correo)
                            });
                        }
                    }
                }
            }
        }
        console.log('deleted all the registers')
    })
})

exports.rescateEliminada = functions.firestore.document('/rescates/{rescate}'
).onDelete((snapshot, context) => {
    var emergenciaData = snapshot.data();
    var rescateID = snapshot.id;

    admin.firestore().collection('usuarios').get().then((snapshot) => {
        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().rescates != undefined) {
                if (usuario.data().rescates != null) {
                    for (var rescate of usuario.data().rescates) {
                        var documentID = rescate['documentId'];
                        console.log(rescate['documentId']);
                        if (documentID == rescateID) {
                            usuario.ref.update({ rescates: admin.firestore.FieldValue.arrayRemove(rescate) }
                            ).then(() => {
                                console.log('deleted from ' + usuario.data().correo)
                            });
                        }
                    }
                }
            }
        }
        console.log('deleted all the registers')
    })
})

exports.adopcionEliminada = functions.firestore.document('/adopciones/{adopcion}'
).onDelete((snapshot, context) => {
    var adopcionData = snapshot.data();
    var adopcionID = snapshot.id;


    admin.firestore().collection('adopciones').doc(adopcionID).collection('solicitudes').get().then((snapshot) => {
        for (var solicitud of snapshot.docs) {
            var data = solicitud.id;
            admin.firestore().collection('adopciones').doc(adopcionID).collection('solicitudes').doc(data).delete().then(() => {
                console.log('documento in subcollection eliminado');
            })
        }
    })


    admin.firestore().collection('usuarios').get().then((snapshot) => {
        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().adopciones != undefined) {
                if (usuario.data().adopciones != null) {
                    for (var adopcion of usuario.data().adopciones) {
                        var documentID = adopcion['documentId'];
                        console.log(adopcion['documentId']);
                        if (documentID == adopcionID) {
                            usuario.ref.update({ adopciones: admin.firestore.FieldValue.arrayRemove(adopcion) }
                            ).then(() => {
                                console.log('deleted from ' + usuario.data().correo)
                            });
                        }
                    }
                }
            }
        }
        console.log('deleted all the registers')
    })
})


exports.perdidoEliminado = functions.firestore.document('/perdidos/{perdido}'
).onDelete((snapshot, context) => {

    var perdidoID = snapshot.id;

    admin.firestore().collection('usuarios').get().then((snapshot) => {
        var listaUsuarios = snapshot.docs;
        for (var usuario of listaUsuarios) {
            if (usuario.data().perdidos != undefined) {
                if (usuario.data().perdidos != null) {
                    for (var perdido of usuario.data().perdidos) {
                        var documentID = perdido['documentId'];
                        console.log(perdido['documentId']);
                        if (documentID == perdidoID) {
                            usuario.ref.update({ perdidos: admin.firestore.FieldValue.arrayRemove(perdido) }
                            ).then(() => {
                                console.log('deleted from ' + usuario.data().correo)
                            });

                        }
                    }
                }
            }

        }
        console.log('deleted all the registers')
    })

})

