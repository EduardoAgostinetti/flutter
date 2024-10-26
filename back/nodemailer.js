const express = require('express');
const nodemailer = require('nodemailer');
const router = express.Router();
const db = require('./db');
const crypto = require('crypto');

router.post('/sendCode', express.json(), async (req, res) => {
    const { email } = req.body;

    if (!email) {
        return res.status(400).json({ message: 'Email is required.' });
    }

    try {
        // Check if the email already exists in the codes table
        const existingCode = await db.query(
            'SELECT email FROM desport.codes WHERE email = $1',
            [email]
        );

        // Generate a random 6-digit code
        const code = crypto.randomInt(10000000, 99999999).toString();

        const created = new Date();
        const expires = new Date(created.getTime() + 25 * 60 * 1000);

        if (existingCode.rows.length > 0) {
            // Update the existing code
            await db.query(
                'UPDATE desport.codes SET code = $1, created = $2, expires = $3 WHERE email = $4',
                [code, created, expires, email]
            );
        } else {
            // Insert the new code
            await db.query(
                'INSERT INTO desport.codes (email, code, created, expires) VALUES ($1, $2, $3, $4)',
                [email, code, created, expires]
            );
        }

        // Configure the email transport
        const transporter = nodemailer.createTransport({
            service: 'gmail', // Replace with your email service
            auth: {
                user: 'duducom195@gmail.com', // Replace with your email
                pass: 'cycp uipy uhyn kwun'   // Replace with your email password
            }
        });

        // Configure the email to be sent
        const mailOptions = {
            from: 'Desport',
            to: email,
            subject: 'Your verification code',
            text: `Your verification code is: ${code}`
        };

        // Send the email
        await transporter.sendMail(mailOptions);

        res.status(200).json({ message: 'Code sent to your email.' });

    } catch (error) {
        console.error('Error sending the code:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});


module.exports = router;