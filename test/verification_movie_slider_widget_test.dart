import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:film_finder/widgets/film_widgets/movie_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  group('MovieSlider Widget Tests', () {
    late List<Movie> movies;

    setUp(() {
      movies = [
      Movie(
            id: 550,
            title: "El club de la lucha",
            posterPath: "/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg",
            voteAverage: 8.4,
            mediaType: "movie",
            backDropPath: '',
            overview: '',
            releaseDay: '',
            director: '',
            duration: 0,
            genres: [],
            trailerUrl: ''),

      Movie(
            id: 550,
            title: "El club de la lucha",
            posterPath: "/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg",
            voteAverage: 8.4,
            mediaType: "movie",
            backDropPath: '',
            overview: '',
            releaseDay: '',
            director: '',
            duration: 0,
            genres: [],
            trailerUrl: ''
    ),];

    });

    testWidgets('displays movie posters in a horizontal list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieSlider(movies: movies),
        ),
      );

      // Check if the list displays two movie posters
      expect(find.byType(Image), findsNWidgets(2));

      // Verify that images have correct URLs
      for (int i = 0; i < movies.length; i++) {
        final imageFinder = find.image(NetworkImage('${Constants.imagePath}${movies[i].posterPath}'));
        expect(imageFinder, findsOneWidget);
      }
    });

    testWidgets('navigates to FilmInfo when a movie is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MovieSlider(movies: movies),
        ),
      );

      // Tap on the first movie
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(find.byType(FilmInfo), findsOneWidget);

      // Check if the correct movie details are passed
      final filmInfo = tester.widget<FilmInfo>(find.byType(FilmInfo));
      expect(filmInfo.movie.id, movies[0].id);
      expect(filmInfo.movie.title, movies[0].title);
    });

    testWidgets('fetchMovieDetails updates movie details correctly', (WidgetTester tester) async {
      final movieSlider = MovieSlider(movies: movies);
      final movie = movies.first;


      final updatedMovie = await movieSlider.fetchMovieDetails(movie);

      // Validate movie details were updated
      expect(updatedMovie.overview, isNotEmpty);
      expect(updatedMovie.backDropPath, isNotEmpty);
      expect(updatedMovie.duration, greaterThan(0));
    });
  });
}
