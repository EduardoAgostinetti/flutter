import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'signin.dart';
import 'signup.dart';
import 'loading.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendCode(String email) async {
    createLoading(context);
    final response = await http.post(
      Uri.parse('http://192.168.5.150:3000/mail/sendCode'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      removeLoading(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${responseBody['message']}',
            style: TextStyle(
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
          builder: (context) => ForgotPasswordScreen(email: email),
        ),
      );
    } else {
      removeLoading(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to sign in: ${responseBody['message']}',
            style: TextStyle(
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
      backgroundColor: const Color(0xFF6A1B9A), // Purple background color
      body: Stack(
        children: [
          // Purple top section
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: const Color(0xFF6A1B9A), // Purple background
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Recover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                    const SizedBox(height: 10),
                    const Text(
                      'Recover your account',
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
          // Form section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  MediaQuery.of(context).size.height * 0.7, // Ajuste a altura
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                // Adicione este widget
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Alterado para min
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height: 12), // Space before "Create Account" title
                      const Text(
                        'Recover Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ).tr(),
                      const SizedBox(
                          height: 12), // Space after "Create Account" title

                      // Email TextField
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email'.tr(),
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
                          _sendCode(_emailController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6A1B9A), // Purple button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Recover',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ).tr(),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Already have an account? Sign In'.tr(),
                          style: const TextStyle(
                            color: Colors.purple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Newbie? Create Account'.tr(),
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

class ForgotPasswordScreen extends StatefulWidget {
  final String email; // Parâmetro para receber o email

  const ForgotPasswordScreen({super.key, required this.email});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _recoverPassword(String email) async {
    createLoading(context);
    final response = await http.post(
      Uri.parse('http://192.168.5.150:3000/auth/recoverPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'code': _codeController.text,
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
      }),
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      removeLoading(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${responseBody['message']}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      removeLoading(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to sign in: ${responseBody['message']}',
            style: TextStyle(
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
                      'Recover',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ).tr(),
                    const SizedBox(height: 10),
                    const Text(
                      'Recover your account',
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
                        'Recover Account',
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
                      const SizedBox(height: 12),

                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password'.tr(),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.purple),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password'.tr(),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.purple),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.purple,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          _recoverPassword(widget.email);
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
                          'Recover',
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
