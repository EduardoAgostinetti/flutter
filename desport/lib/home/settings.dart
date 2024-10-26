import 'package:desport/auth/signin.dart';
import 'package:desport/settings/language.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    // Remove todas as rotas e retorna à tela de login
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Settings',
            style: TextStyle(
                fontSize: 16), // Ajuste o tamanho da fonte se necessário
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(10), // Adiciona um padding na lista
        child: Column(
          children: [
            _buildGroup('User Data', [
              _buildSettingItem(
                title: 'Account',
                icon: Icons.person, // Ícone para Conta
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
              ),
              _buildSettingItem(
                title: 'Security',
                icon: Icons.lock, // Ícone para Privacidade
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
              ),
              _buildSettingItem(
                title: 'About',
                icon: Icons.info, // Ícone para Notificações
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
              ),
            ]),
            SizedBox(height: 10), // Espaçamento entre grupos
            _buildGroup('Personalization', [
              _buildSettingItem(
                title: 'Themes',
                icon: Icons.color_lens, // Ícone para Temas
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
              ),
              _buildSettingItem(
                title: 'Language',
                icon: Icons.language, // Ícone para Temas
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
              ),
            ]),
            _buildGroup('Exit', [
              _buildSettingItem(
                title: 'Log Out',
                icon: Icons.exit_to_app, // Ícone para Notificações
                onTap: () {
                  _logout();
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(String title, List<Widget> items) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      leading:
          Icon(icon, color: const Color.fromARGB(148, 0, 0, 0)), // Ícone preto
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: onTap,
    );
  }
}
