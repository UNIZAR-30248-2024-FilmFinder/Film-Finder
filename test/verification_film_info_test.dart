import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart'; // Ajusta la ruta según tu proyecto
import 'package:film_finder/methods/movie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:film_finder/pages/auth_pages/auth_page.dart';
import 'package:intl/date_symbol_data_local.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RedirectPage(),
    );
  }
}

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    });

    return const Scaffold();
  }
}

void main() {
  testWidgets('FilmInfo - Visualización y funcionalidad', (WidgetTester tester) async {
    // Datos de prueba para la película.
    final testMovie = Movie(
     id: 550,
            title: "El club de la lucha",
            posterPath: "/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg",
            voteAverage: 8.4,
            mediaType: "movie",
            backDropPath: '',
            overview: '',
            releaseDay: '',
            director: 'Christopher Nolan',
            duration: 148,
            genres: ['Sci-Fi, Thriller'],
            trailerUrl: ''
    );

    // Renderizar la pantalla `FilmInfo`.
    await tester.pumpWidget(
      MaterialApp(
        home: FilmInfo(
          movie: testMovie,
          pop: true,
          favorite: false,
        ),
      ),
    );

    // 1. Verificar que los elementos principales se muestran correctamente.
    expect(find.text('El club de la lucha'), findsNWidgets(2)); // Verifica el título (en 2 lugares diferentes).
    expect(find.text('Sci-Fi, Thriller'), findsOneWidget); // Géneros.
    expect(find.text('148 min'), findsOneWidget); // Duración.
    expect(find.text('Christopher Nolan'), findsOneWidget); // Director.

    // 2. Simular interacción con el botón de retroceso.
    final backButton = find.byIcon(Icons.arrow_back_rounded);
    expect(backButton, findsOneWidget); // Verificar que el botón existe.
    await tester.tap(backButton); // Simular un tap.
    await tester.pumpAndSettle(); // Esperar a que la animación de navegación termine.

    // Nota: Verifica que se navegue correctamente (esto depende de la implementación del `Navigator`).

    // 3. Simular la interacción con el botón para abrir el tráiler.
    final trailerButton = find.byKey(Key('trailerButton')); // Asegúrate de agregar un Key al botón que abre el tráiler.
    expect(trailerButton, findsOneWidget); // Verificar que el botón exista.
    await tester.tap(trailerButton); // Simular un tap.
    await tester.pump(); // No hay navegación, pero el test debería ejecutarse sin errores.
    // Nota: Para probar el lanzamiento del URL, considera usar mocks si necesitas asegurar que se abra correctamente.
  });
}
