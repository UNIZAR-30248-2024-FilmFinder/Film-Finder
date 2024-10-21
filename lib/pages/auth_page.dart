import 'package:film_finder/pages/login_screen.dart';
import 'package:film_finder/pages/principal_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return PrincipalScreen();
          } else {
            return LogIn();
          }
        },
      ),
    );
  }
}