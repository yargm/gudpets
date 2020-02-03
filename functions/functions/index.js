const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.nuevaEmergencia = functions.firestore.document('/emergencias/{emergencia}'
).onCreate((snapshot, context) => {
    emergenciaData = snapshot.data();
    listaTokens;

    admin.firestore().collection('usuarios').get().then((snapshot) =>{
        listaUsuarios = snapshot.data();
        for(var usuario of listaUsuarios){
            for(var token of usuario.tokens){
                listaTokens.push(token);
            }
        }
    })

    var payload = {
        "notification": {
            "title": "Nueva Emergencia!!!",
            "body": emergenciaData.titulo,
            "sound": "default"
        },
        "data": {
            "sendername": '',
            "message": '',
        }
    }


    return admin.messaging().sendToDevice(listaTokens, payload).then((response) => {
        console.log('Se enviaron todas las notificaciones');

    }).catch((err) => {
        console.log(err);
    });


})

