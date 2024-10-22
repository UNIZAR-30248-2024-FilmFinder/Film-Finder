import 'package:film_finder/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:film_finder/pages/film_screen.dart'; // Importa tu pantalla FilmInfo
import 'package:film_finder/methods/movie.dart'; // Importa la clase Movie

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test de integración de FilmInfo con una película', (WidgetTester tester) async {
    final searchBar = SearchingBar().createState();
    // Ejecutar la búsqueda
    await searchBar.searchListFunction('El club de la lucha');

    // Asumimos que la primera película es la que estamos buscando
    Movie foundMovie = searchBar.movies[0];

    // Ejecuta la app y navega a la pantalla de FilmInfo con la película de prueba
    await tester.pumpWidget(
      MaterialApp(
        home: FilmInfo(movie: foundMovie),
      ),
    );

    await tester.allElements;

    // Verifica que el título de la película se muestra correctamente en la pantalla
    expect(find.text(foundMovie.title), findsAny);

    // Verificar que el género se muestra
    expect(find.text('Géneros: ' + foundMovie.genres.join(', ')), findsOneWidget);

    // Verificar que la duración se muestra
    expect(find.textContaining(foundMovie.duration.toString()), findsAny);

    // Verificar que el director se muestra
    expect(find.textContaining(foundMovie.director), findsOneWidget);

    // Verificar que la fecha de estreno se muestra
    expect(find.textContaining(foundMovie.releaseDay), findsOneWidget);

    // Verificar que la puntuación se muestra
    expect(find.textContaining(foundMovie.voteAverage.toStringAsFixed(1)), findsOneWidget);

    // Verificar que la sinopsis está presente
    expect(find.textContaining(foundMovie.overview), findsOneWidget);

    // Verificar que el botón de "VER TRAILER" se muestra si existe el tráiler
    if (foundMovie.trailerUrl.isNotEmpty) {
      expect(find.text('VER TRAILER'), findsOneWidget);
    } else {
      expect(find.text('VER TRAILER'), findsNothing);
    }
  });
}
