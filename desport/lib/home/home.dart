import 'package:desport/home/settings.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Controla qual tela será exibida
        children: [
          Center(child: const Text('Home Screen')),
          Center(child: const Text('Challenges Screen')),
          Center(child: const Text('Awards Screen')),
          Profile(user: widget.user),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.purple,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.4),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Challanges',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Awards',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 5 * _selectedIndex,
            width: MediaQuery.of(context).size.width / 5,
            child: Container(
              height: 5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
