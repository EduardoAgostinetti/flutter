import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void createLoading(BuildContext context) async {
  // Navega para a tela de carregamento
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoadingScreen()),
  );
}

void removeLoading(BuildContext context) async {
  // Navega para a tela de carregamento
  Navigator.pop(context);
}
