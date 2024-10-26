import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
