import 'package:flutter/material.dart';
import 'package:film_finder/pages/film_screen.dart';
import 'package:film_finder/widgets/search_bar.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener la altura de la barra de estado
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: statusBarHeight + 20),
            Center(
              child: Stack(
                children: [
                  Text(
                    'Film Finder',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.white,
                    ),
                  ),
                  const Text(
                    'Film Finder',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(190, 49, 68, 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const SearchingBar(),
            const SizedBox(height: 250),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const FilmInfo(film: "Interstellar")),
                );
              },
              child: const Text(
                'Estructura Películas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
