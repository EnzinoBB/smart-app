import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
// import 'package:frontend/profile_page.dart'; // Creeremo questo file dopo
import 'package:provider/provider.dart';

enum MenuAction { profile, logout }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) {
              switch (value) {
                case MenuAction.profile:
                  // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ProfilePage()));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Pagina profilo da implementare')));
                  break;
                case MenuAction.logout:
                  authService.logout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
              const PopupMenuItem<MenuAction>(
                value: MenuAction.profile,
                child: Text('Profilo'),
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
      body: const Center(
        child: Text('Login effettuato con successo!',
            style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
