import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguagePage extends StatefulWidget {
  @override
  LanguagePageState createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> {
  final List<String> languages = [
    'Árabe',
    'Búlgaro',
    'Catalão',
    'Chinês Simplificado',
    'Chinês Tradicional',
    'Coreano',
    'Dinamarquês',
    'Eslovaco',
    'Esloveno',
    'Estoniano',
    'Finlandês',
    'Francês',
    'Grego',
    'Alemão',
    'Húngaro',
    'Islandês',
    'Inglês',
    'Italiano',
    'Japonês',
    'Letão',
    'Lituano',
    'Malaio',
    'Norueguês',
    'Polonês',
    'Português',
    'Romeno',
    'Russo',
    'Espanhol',
    'Sueco',
    'Turco',
    'Ucraniano',
    'Tcheco',
  ];
  // Lista de idiomas
  String? selectedLanguage; // Variável para armazenar a linguagem selecionada

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage(); // Carrega a linguagem selecionada ao iniciar
  }

  // Função para carregar a linguagem salva
  void _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage =
          prefs.getString('selectedLanguage'); // Busca a linguagem salva
    });
  }

  // Função para salvar a linguagem selecionada
  void _saveSelectedLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLanguage', language); // Salva a linguagem
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]).tr(),
            trailing: selectedLanguage == languages[index]
                ? Icon(Icons.check,
                    color: Colors.purple) // Marca o idioma selecionado
                : null,
            onTap: () {
              setState(() {
                selectedLanguage =
                    languages[index]; // Atualiza a linguagem selecionada
                _saveSelectedLanguage(selectedLanguage!); // Salva a seleção
              });
            },
          );
        },
      ),
    );
  }
}
