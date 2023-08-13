#!/usr/bin/env node

const cron = require('node-cron');
const axios = require('axios');
const https = require('https');
const fs = require('fs');
require('dotenv').config();

const ovh = require('ovh')({
    appKey: process.env.APP_KEY,
    appSecret: process.env.APP_SECRET,
    consumerKey: process.env.CONSUMER_KEY,
    endpoint: process.env.END_POINT,
});

cron.schedule('0 5 5 * * *', () => {
    let cronType = 'SnapshotCreation';

    ovh.request('DELETE', `/vps/${process.env.SERVICEVPS_NAME}/snapshot`, async function (err, data) {
        console.log(err)
        if(err === 403) return sendWebhook({content: '```This service doesn\'t have the permission necessary, create correctly the credentials ...```'}, cronType);

        sendWebhook({content: '```Removing the previous snapshot from OVH.com ...```'}, cronType);
    });

    setTimeout(() => {
        ovh.request('POST', `/vps/${process.env.SERVICEVPS_NAME}/createSnapshot`, description = `${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}`, async function (err, data) {
            console.log(err)
            if(err) return sendWebhook({content: '```An error occurred while trying to create a Snapshot...```'}, cronType);
    
            sendWebhook({content: '```Creating a new snapshot in OVH.com ...```'}, cronType);
        });
    }, 15000);
});

cron.schedule('0 30 5 * * *', () => {
    let cronType = 'SnapshotDownload';

    ovh.request('GET', `/vps/${process.env.SERVICEVPS_NAME}/snapshot/download`, async function (err, data) {
        if(err) return sendWebhook({content: '```An error occurred while trying to get a link to download the Snapshot...```'}, cronType);

        sendWebhook({content: `\`\`\`Downloading the Snapshot (${(data.size / (1000 * 1000 * 1000)).toFixed(2)} GB) from OVH.com to External Hard Drive...\`\`\`➜ If you want to download it manually, **[click here](${data.url})**.`}, cronType);
        /*let file = fs.createWriteStream(`/media/${process.env.FOLDER_DISK}/${new Date().toLocaleString('pt', {timeZone:>        https.get(data.url, function(response) {
            response.pipe(file);
            file.on('finish', function() {
                file.close();
                sendWebhook({content: '```Download Complete!```'}, cronType);
            });
        });*/
    });
});

cron.schedule('0 0 * * * *', async () => {
    let cronType = 'StatusVPS';

    ovh.request('GET', `/vps/${process.env.SERVICEVPS_NAME}`, async function (err, data) {
        try {
            msg = {embeds: [{
                "title": "📊 VPS Status",
                "color": 19967,
                "description": `➜ **State:** \`${data.state.charAt(0).toUpperCase() + data.state.slice(1)}\` \n➜ **Zone:** \`${data.zone}\` \n➜ **Max Storage:** \`${data.model.disk} GB\` \n➜ **Max Memory:** \`${data.memoryLimit} MB\` \n➜ **Storage Type:** \`${data.offerType.toUpperCase()}\` \n➜ **vCores Available:** \`${data.model.vcore}\` \n\n➜ **Display Name:** \`${data.displayName}\` \n➜ **Service Name:** \`${data.name}\``,
                "fields": [{ "name": "How get the Snapshot Files?", "value": "➜ You can use FTP Protocol or just insert the storage device (NTFS formatted) in a computer." }],
                "thumbnail": { "url": "https://i.imgur.com/7vQ5NDT.png" },
                "footer": { "text": "Maded by github.com/RobertoValente" }
            }]};
            sendWebhook(msg, cronType);
        } catch(err) {
            sendWebhook({content: '```Your VPS Service Name is Wrong!```'}, cronType);
        }
    });
});

function sendWebhook(msg, cronType) {
    axios({ method: 'POST', url: process.env.DISCORD_WEBHOOK, headers: { 'Content-Type': 'application/json' }, data: JSON.stringify(msg) })
    .then(res => {
        console.log(`[${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}] CronJob ${cronType} > Message Sent!`);
    })
    .catch(err => {
        console.log(`[${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}] CronJob ${cronType} > Error: ${err.message}`);
    });
}
