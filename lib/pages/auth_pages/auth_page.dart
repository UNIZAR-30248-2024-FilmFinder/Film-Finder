import 'package:film_finder/pages/auth_pages/login_screen.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LogIn(); // o tu pantalla de registro
          } else {
            return const PrincipalScreen(); // Pantalla principal
          }
        }
        return const CircularProgressIndicator(); // Cargando...
      },
    );
  }
}
