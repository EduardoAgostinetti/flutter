const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const ftp = require('basic-ftp');

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });


async function uploadToFtp(buffer, filename) {
  const client = new ftp.Client();
  client.ftp.verbose = true;

  try {
    await client.access({
      host: "ftp://192.168.5.150", // Substitua pelo endereço do servidor FTP
      user: "root", // Substitua pelo seu usuário FTP
      password: "root", // Substitua pela senha do FTP
      secure: false // Ajuste para `true` se o servidor FTP usar FTPS
    });

    // Envia o arquivo ao diretório especificado no servidor FTP
    await client.uploadFrom(buffer, `/${filename}`); // Substitua `/remote/path/` pelo diretório desejado
  } catch (error) {
    console.error("Erro ao enviar o arquivo por FTP:", error);
    throw error;
  } finally {
    client.close(); // Encerra a conexão com o FTP
  }
}

// Rota para receber e enviar a imagem por FTP
router.post('/upload', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'Imagem não enviada' });
    }

    // Gera um nome único para o arquivo com base na data e um número aleatório
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const extension = path.extname(req.file.originalname);
    const newFilename = `image_${uniqueSuffix}${extension}`;

    // Envia a imagem para o servidor FTP usando o buffer
    await uploadToFtp(req.file.buffer, newFilename);

    res.status(200).json({ message: 'Imagem enviada com sucesso para o servidor FTP', filename: newFilename });
  } catch (error) {
    res.status(500).json({ error: 'Erro ao enviar a imagem por FTP' });
  }
});

module.exports = router;
