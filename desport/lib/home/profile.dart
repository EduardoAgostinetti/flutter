import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  final Map<String, dynamic> user;

  const Profile({super.key, required this.user});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.user['profile_image'] != null) {
      _profileImagePath =
          "http://192.168.5.150/profile_images/${widget.user['profile_image']}";
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _uploadImage(image.path);
    }
  }

  Future<void> _uploadImage(String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.5.150:3000/ftp/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imagePath,
    ));
    request.fields['username'] = widget.user['username'];

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> jsonResponse = json.decode(responseBody);

    if (response.statusCode == 200) {
      String newImageName = jsonResponse['filename'];
      setState(() {
        _profileImagePath = "http://192.168.5.150/profile_images/$newImageName";
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to upload image: ${jsonResponse['error'] ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: _profileImagePath != null
                        ? NetworkImage(_profileImagePath!)
                        : null, // Quando não houver imagem de perfil, backgroundImage deve ser null
                    child: _profileImagePath ==
                            null // Exibe o ícone apenas se a imagem de perfil não estiver disponível
                        ? Icon(
                            Icons.add_a_photo,
                            size: 30.0, // ajuste o tamanho conforme necessário
                            color: Colors
                                .purple, // ajuste a cor conforme necessário
                          )
                        : null, // Se houver uma imagem, não exiba o ícone
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user['name'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${widget.user['username']}',
                      style: const TextStyle(
                          fontSize: 13, color: Color.fromARGB(150, 0, 0, 0)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
