const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNewApptPushNotification = functions.firestore
    .document("Appointments/{appointmentID}")
    .onCreate(async (snap, context) => {
        
        const title = "New Appointment Request";
        const content = snap.data().date + " - " + snap.data().timeOfDay
        const message = {
            notification: {
                title: title,
                body: content,
            },
            topic: "admin"
        }
            
        let response = await admin.messaging().send(message);
        console.log("Response: ", response);
    })
