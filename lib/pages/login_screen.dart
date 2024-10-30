import 'package:film_finder/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/widgets/text_field_login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUser() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la altura de la barra de estado
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: statusBarHeight + 20),
          const Center(
            child: Text(
              'FilmFinder',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          const Spacer(),
          MyTextField(
            controller: usernameController,
            hintText: 'Nombre de usuario',
            obscureText: false,
          ),
          const SizedBox(height: 10),
          MyTextField(
            controller: passwordController,
            hintText: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: signUser,
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: const Text(
              '¿No tienes una cuenta? Regístrate aquí',
              style: TextStyle(color: Colors.white),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
