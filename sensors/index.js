const os = require('node-os-utils');

// init firestore
const admin = require('firebase-admin');
const serviceAccount = require('./serviceaccountkey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

setInterval(async () => {
    var cpu = os.cpu;
    var mem = os.mem;
    var cpuUsage = await cpu.usage();
    var memUsage = await mem.used();
    var todayAsTimestamp = admin.firestore.Timestamp.now();

    console.log(todayAsTimestamp);

    db.collection('messages').add({
        "timeStamp": todayAsTimestamp,
        "cpuUsage": cpuUsage,
        "memUsage": memUsage.usedMemMb,
        "memTotal": memUsage.totalMemMb
    });

}, 5000)