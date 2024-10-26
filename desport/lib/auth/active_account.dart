import 'dart:convert';
import 'package:desport/home.dart';
import 'package:desport/auth/signin.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../loading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class ActiveAccountScreen extends StatefulWidget {
  final String email; // Parâmetro para receber o email
  final Map<String, dynamic> user;

  const ActiveAccountScreen(
      {super.key, required this.email, required this.user});

  @override
  _ActiveAccountScreenState createState() => _ActiveAccountScreenState();
}

class _ActiveAccountScreenState extends State<ActiveAccountScreen> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _verifyCode(String email, Map<String, dynamic> user) async {
    createLoading(context);
    final response = await http.post(
      Uri.parse('http://192.168.5.150:3000/auth/verifyCode'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'code': _codeController.text,
      }),
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      removeLoading(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${responseBody['message']}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      removeLoading(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to sign in: ${responseBody['message']}',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A), // Cor de fundo roxa
      body: Stack(
        children: [
          // Seção superior roxa
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: const Color(0xFF6A1B9A), // Fundo roxo
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                    const SizedBox(height: 10),
                    const Text(
                      'Active your account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ),
          ),
          // Seção do formulário
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Active Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ).tr(),
                      const SizedBox(height: 12),

                      // Campo de código
                      TextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Permite apenas dígitos numéricos
                        ],
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Code'.tr(),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.purple),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          _verifyCode(widget.email, widget.user);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6A1B9A), // Cor do botão roxo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ).tr(),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Back'.tr(),
                          style: const TextStyle(
                            color: Colors.purple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
