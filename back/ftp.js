const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const ftp = require('basic-ftp');
const { Readable } = require('stream');
const db = require('./db');

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

async function uploadToFtp(buffer, filename, username) {
    const client = new ftp.Client();
    client.ftp.verbose = true;
  
    try {
      await client.access({
        host: "192.168.5.150", // Substitute with your FTP server address
        user: "root", // Substitute with your FTP user
        password: "root", // Substitute with your FTP password
        secure: false // Adjust to `true` if the FTP server uses FTPS
      });
  
      // Check if there is already a file for the user and remove it
      const existingFiles = await client.list('/profile_images'); // List files in the directory
      for (const file of existingFiles) {
        if (file.name.startsWith(username)) {
          await client.remove(`/profile_images/${file.name}`); // Remove the file
          console.log(`File ${file.name} removed.`);
        }
      }
  
      const readableStream = Readable.from(buffer);
      // Upload the file to the specified directory on the FTP server
      await client.uploadFrom(readableStream, `/profile_images/${filename}`);
    } catch (error) {
      console.error("Error uploading file via FTP:", error);
      throw error;
    } finally {
      client.close(); // Close the connection to the FTP
    }
}

// Route to receive and upload the image via FTP
router.post('/upload', upload.single('image'), async (req, res) => {
    try {
      if (!req.file || !req.body.username) {
        return res.status(400).json({ error: 'Image or username not provided' });
      }
  
      // Generate a unique filename based on the username, current date, and a random number
      const username = req.body.username;
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
      const extension = path.extname(req.file.originalname);
      const newFilename = `${username}_${uniqueSuffix}${extension}`;
  
      // Upload the image to the FTP server using the buffer
      await uploadToFtp(req.file.buffer, newFilename, username);

      await db.query(
        'UPDATE desport.users SET profile_image = $1 WHERE username = $2',
        [newFilename, username]
    );
  
      res.status(200).json({ message: 'Image successfully uploaded to the FTP server', filename: newFilename });
    } catch (error) {
      console.error("Error uploading image:", error);
      res.status(500).json({ error: 'Error uploading image via FTP' });
    }
});

module.exports = router;
