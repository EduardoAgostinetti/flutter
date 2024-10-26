import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> user;

  const Profile({super.key, required this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            // Cabeçalho com a foto, nome e usuário
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage, // Chama a função ao tocar na foto
                  child: CircleAvatar(
                    radius: 30, // Tamanho do círculo da foto
                    backgroundImage: _imageFile != null
                        ? FileImage(
                            _imageFile!) // Se a imagem for selecionada, use-a
                        : NetworkImage(widget.user['profilePicture'] ??
                            ''), // Ou use a imagem padrão
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user['name'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${widget.user['username']}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Informações adicionais do usuário
            Text(
              'Email: ${widget.user['email']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // Adicione mais informações do usuário aqui se necessário
          ],
        ),
      ),
    );
  }
}
