const express = require('express');
const router = express.Router();
const db = require('./db');
//const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');


router.post('/signup', express.json(), async (req, res) => {
    const { name, username, email, password, confirmPassword } = req.body;

    if (!name || !username || !email || !password || !confirmPassword) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    if (password !== confirmPassword) {
        return res.status(400).json({ message: 'Passwords do not match.' });
    }

    try {
        const existingUser = await db.query(
            'SELECT username, email FROM desport.users WHERE username = $1 OR email = $2',
            [username, email]
        );

        const messages = [];

        if (existingUser.rows.length > 0) {
            if (existingUser.rows[0].username === username) {
                messages.push('Username');
            }
            if (existingUser.rows[0].email === email) {
                messages.push('Email');
            }

            if (messages.length > 0) {
                let formattedMessage;
                if (messages.length === 1) {
                    formattedMessage = messages[0] + " already in use.";
                } else if (messages.length === 2) {
                    formattedMessage = messages.join(' and ') + " already in use.";
                }
                return res.status(400).json({ message: formattedMessage });
            }
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const result = await db.query(
            'INSERT INTO desport.users (name, username, email, password, is_active) VALUES ($1, $2, $3, $4, $5) RETURNING iduser',
            [name, username, email, hashedPassword, false]
        );

        const userId = result.rows[0].iduser;

        res.status(201).json({ message: 'User registered successfully.', userId });

    } catch (error) {

        console.error('Error inserting user:', error);

        res.status(500).json({ message: 'Internal server error.' });
        
    }
});

router.post('/signin', express.json(), async (req, res) => {
    const { username, password } = req.body;

    // Verifica se todos os campos estão preenchidos
    if (!username || !password) {
        return res.status(400).json({ message: 'Username and password are required.' });
    }

    try {
        // Consulta para verificar se o usuário existe
        const userQuery = await db.query(
            'SELECT * FROM desport.users WHERE username = $1',
            [username]
        );

        // Verifica se o usuário foi encontrado
        if (userQuery.rows.length === 0) {
            return res.status(401).json({ message: 'Invalid username or password.' });
        }

        const user = userQuery.rows[0];

        // Verifica se a senha é válida
        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Invalid username or password.' });
        }

        // // Gera um token JWT
        // const token = jwt.sign(
        //     { iduser: user.iduser, username: user.username },'secret_key', { expiresIn: '24h' }
        // );

        res.status(200).json({ message: 'Login successful.', user: user });

    } catch (error) {
        console.error('Error during user authentication:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});

router.post('/verifyCode', express.json(), async (req, res) => {
    const { email, code } = req.body;

    if (!email || !code) {
        return res.status(400).json({ message: 'Code are required.' });
    }

    try {
        // Verificar se o código e o email existem e não expiraram
        const codeResult = await db.query(
            'SELECT email, code, expires FROM desport.codes WHERE email = $1 AND code = $2',
            [email, code]
        );

        if (codeResult.rows.length === 0) {
            return res.status(400).json({ message: 'Invalid code.' });
        }

        const { expires } = codeResult.rows[0];
        const currentTime = new Date();

        // Verificar se o código expirou
        if (new Date(expires) < currentTime) {
            return res.status(400).json({ message: 'The code has expired.' });
        }

        // Atualizar o status do usuário para ativo
        await db.query(
            'UPDATE desport.users SET is_active = true WHERE email = $1',
            [email]
        );

        res.status(200).json({ message: 'User activated successfully.' });

    } catch (error) {
        console.error('Error verifying code:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});

router.post('/recoverPassword', express.json(), async (req, res) => {
    const { email, code, password, confirmPassword } = req.body;

    // Verificar se todos os campos são fornecidos
    if (!email || !code || !password || !confirmPassword) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    // Verificar se as senhas correspondem
    if (password !== confirmPassword) {
        return res.status(400).json({ message: 'Passwords do not match.' });
    }

    try {
        // Verificar se o código é válido e não expirou
        const codeResult = await db.query(
            'SELECT * FROM desport.codes WHERE email = $1 AND code = $2',
            [email, code]
        );

        if (codeResult.rows.length === 0) {
            return res.status(400).json({ message: 'Invalid code or email.' });
        }

        // Verificar se o código expirou
        const { expires } = codeResult.rows[0];
        const now = new Date();
        if (now > expires) {
            return res.status(400).json({ message: 'Code has expired.' });
        }

        // Gerar o hash da nova senha
        const hashedPassword = await bcrypt.hash(password, 10);

        // Atualizar a senha no banco de dados
        await db.query(
            'UPDATE desport.users SET password = $1 WHERE email = $2',
            [hashedPassword, email]
        );

        res.status(200).json({ message: 'Password updated successfully.' });

    } catch (error) {
        console.error('Error recovering password:', error);
        res.status(500).json({ message: 'Internal server error.' });
    }
});


module.exports = router;