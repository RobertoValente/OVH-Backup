const cron = require('node-cron');
const axios = require('axios');
require('dotenv').config();

const ovh = require('ovh')({
    appKey: process.env.APP_KEY,
    appSecret: process.env.APP_SECRET,
    consumerKey: process.env.CONSUMER_KEY,
    endpoint: process.env.END_POINT,
});

cron.schedule('* * * * *', () => {
    let msg = `😎 Funcionou!`;
    let cronType = 'Teste';

    ovh.request('POST', `/vps/${process.env.SERVICE_NAME}/createSnapshot`, function (err, me) {
        console.log(err || me); //criar com o dia de hoje
    });

    ovh.request('GET', `/vps/${process.env.SERVICE_NAME}/snapshot`, function (err, me) {
        console.log(err || me);
    });

    ovh.request('GET', `/vps/${process.env.SERVICE_NAME}/snapshot/download`, function (err, me) {
        console.log(err || me);
    });

    /* 30Min in 30Min:
    ovh.request('GET', `/vps/${process.env.SERVICE_NAME}/status`, function (err, me) {
        console.log(err || me);
    });

    ovh.request('GET', `/vps/${process.env.SERVICE_NAME}/statistics`, function (err, me) {
        console.log(err || me);
    });
    */

    sendWhatsappMessage(msg, cronType);
}, {scheduled: true, timezone: 'Europe/Lisbon'});

cron.schedule('30 52 09 * * * *', () => {
    let msg = `😎 Funcionou!`;
    let cronType = 'SpecificHour';

    sendWhatsappMessage(msg, cronType);
}, {scheduled: true, timezone: 'Europe/Lisbon'});

cron.schedule('30 * * * *', () => {
    let msg = `😎 Funcionou!`;
    let cronType = 'Every30Min';

    sendWhatsappMessage(msg, cronType);
}, {scheduled: true, timezone: 'Europe/Lisbon'});

// [ ] > Criar um CronJob de Teste/Exemplo
// [ ] > Criar outro CronJob Comentado para ser outro Exemplo
// [ ] > Dar instruções de como criar e editar horário de outro, 

function sendWhatsappMessage(msg, cronType) {
    axios.post(`http://api.callmebot.com/whatsapp.php?source=web&phone=${process.env.PHONE}&apikey=${process.env.KEY}&text=${encodeURI(msg)}`)
    .then(res => {
        console.log(`[${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}] CronJob ${cronType} > Mensagem Enviada!`);
    })
    .catch(err => {
        console.log(`[${new Date().toLocaleString('pt', {timeZone: 'Europe/Lisbon'})}] CronJob ${cronType} > Erro: ${err.message}`);
    });
}
