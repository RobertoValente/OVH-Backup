#!/usr/bin/env node

const cron = require('node-cron');
const axios = require('axios');
require('dotenv').config();

const ovh = require('ovh')({
    appKey: process.env.APP_KEY,
    appSecret: process.env.APP_SECRET,
    consumerKey: process.env.CONSUMER_KEY,
    endpoint: process.env.END_POINT,
});

cron.schedule('0 15 5 * * *', () => {
    let msg = `> CronJob de Hora do Backup!`;
    let cronType = 'SpecificHour';

    sendWhatsappMessage(msg, cronType);
}, {scheduled: true, timezone: 'Europe/Lisbon'});

cron.schedule('0 0 * * * *', () => {
    let msg = `> CronJob de Hora em Hora!`;
    let cronType = 'EveryHour';

    sendWhatsappMessage(msg, cronType);
}, {scheduled: true, timezone: 'Europe/Lisbon'});

function sendWhatsappMessage(msg, cronType) {
    axios.post(`http://api.callmebot.com/whatsapp.php?source=web&phone=${process.env.PHONE}&apikey=${process.env.KEY}&text=${encodeURI(msg)}`)
    .then(res => {
        console.log(`[${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}] CronJob ${cronType} > Mensagem Enviada!`);
    })
    .catch(err => {
        console.log(`[${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}] CronJob ${cronType} > Erro: ${err.message}`);
    });
}
