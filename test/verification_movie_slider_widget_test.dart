import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/widgets/film_widgets/movie_slider.dart';
import 'package:mockito/mockito.dart';
import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:film_finder/methods/movie.dart';

// Mock de la clase de datos de películas
class MockMovie extends Movie {
  MockMovie({
    int id = 1,
    String title = "Mock Title",
    String backDropPath = "/mockBackdropPath.jpg",
    String overview = "This is a mock overview.",
    String posterPath = "/mockPosterPath.jpg",
    String releaseDay = "2024-01-01",
    double voteAverage = 8.0,
    String mediaType = "Movie",
    String director = "Mock Director",
    int duration = 120,
    List<String> genres = const ["Mock Genre"],
    String trailerUrl = "https://mocktrailer.com",
  }) : super(
          id: id,
          title: title,
          backDropPath: backDropPath,
          overview: overview,
          posterPath: posterPath,
          releaseDay: releaseDay,
          voteAverage: voteAverage,
          mediaType: mediaType,
          director: director,
          duration: duration,
          genres: genres,
          trailerUrl: trailerUrl,
        );
}

// Mock para simular el snapshot
class MockSnapshot extends Mock implements AsyncSnapshot<List<MockMovie>> {}

void main() {
  testWidgets('Renderiza MovieSlider y navega a FilmInfo',
      (WidgetTester tester) async {
    // Crear datos mock
    final mockMovies = [
      MockMovie(posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg'),
      MockMovie(posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg'),
      MockMovie(posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg'),
    ];

    // Configurar los mock de las películas, por ejemplo, el posterPath
    when(mockMovies[0].posterPath)
        .thenReturn('/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg');
    when(mockMovies[1].posterPath)
        .thenReturn('/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg');
    when(mockMovies[2].posterPath)
        .thenReturn('/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg');

    // Construir el widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieSlider(movies: mockMovies),
        ),
      ),
    );

    // Verificar que se renderiza el slider con las imágenes
    expect(find.byType(Image), findsNWidgets(mockMovies.length));

    // Simular interacción: tocar el primer elemento
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle(); // Esperar la navegación

    // Verificar que se navega a FilmInfo
    expect(find.byType(FilmInfo), findsOneWidget);
  });

  testWidgets('Valida que las imágenes se renderizan correctamente',
      (WidgetTester tester) async {
    // Crear datos mock
    final mockMovies = [
      MockMovie(posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg'),
      MockMovie(posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg'),
      MockMovie(posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg'),
    ];

    // Configurar los mock de las películas, por ejemplo, el posterPath
    when(mockMovies[0].posterPath)
        .thenReturn('/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg');
    when(mockMovies[1].posterPath)
        .thenReturn('/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg');
    when(mockMovies[2].posterPath)
        .thenReturn('/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg');

    // Construir el widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieSlider(
            movies: mockMovies,
          ),
        ),
      ),
    );

    // Validar que cada imagen tiene la URL correcta
    for (var i = 0; i < mockMovies.length; i++) {
      final imageFinder = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is NetworkImage &&
          (widget.image as NetworkImage).url ==
              '${Constants.imagePath}${mockMovies[i].posterPath}');
      expect(imageFinder, findsOneWidget);
    }
  });
}
