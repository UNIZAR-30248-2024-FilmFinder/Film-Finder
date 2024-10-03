import 'package:film_finder/pages/pages/initial_screen.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener la altura de la barra de estado
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InitialScreen()),
              );
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
