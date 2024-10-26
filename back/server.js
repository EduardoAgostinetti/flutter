const express = require('express');
const app = express()
const auth = require('./auth');
const mail = require('./nodemailer');
const db = require('./db')

app.use('/auth', auth);
app.use('/mail', mail);

app.listen(3000, () => {
console.log("Server run on localhost:3000");
});