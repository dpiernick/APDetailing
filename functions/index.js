//run "firebase deploy" in terminal to deploy file
//logs - https://console.cloud.google.com/logs/query?project=ap-detailing

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNewApptPushNotification = functions.firestore
    .document("Appointments/{appointmentID}")
    .onCreate(async (snap, context) => {
        
        const title = "New Appointment Request";
        const content = snap.data().dateString + " - " + snap.data().timeString
        const message = {
            notification: {
                title: title,
                body: content
            },
            data: { apptID: context.params.appointmentID },
            topic: "admin"
        }
            
        let response = await admin.messaging().send(message);
        console.log("Response: ", response);
    })

exports.sendApptUpdatePushNotification = functions.firestore
    .document("Appointments/{appointmentID}")
    .onUpdate(async (change, context) => {
        
        let userID = change.after.data().userID
        let query = await admin.firestore().collection("Users").doc(userID).get()
        let fcmToken = query.data().fcmToken
        
        const title = "Appointment Updated";
        const statusUpdate = change.before.data().status != change.after.data().status ? change.after.data().status + ": " : ""
        const content = statusUpdate + change.after.data().dateString + " - " + change.after.data().timeString
        const message = {
            notification: {
                title: title,
                body: content
            },
            data: { apptID: context.params.appointmentID },
            token: fcmToken
        }
            
        let response = await admin.messaging().send(message);
        console.log("Response: ", response);
    })
