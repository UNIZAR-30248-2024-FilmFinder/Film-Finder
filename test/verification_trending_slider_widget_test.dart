import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:film_finder/widgets/film_widgets/trending_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


@GenerateMocks([http.Client])
void main() {


  group('TrendingSlider Widget Tests', () {
    testWidgets('TrendingSlider renders movies correctly', (WidgetTester tester) async {
      // Arrange
      final movies = [
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
            trailerUrl: ''),
      ];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TrendingSlider(movies: movies),
        ),
      ));

      // Assert
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.text('Test Movie 1'), findsNothing); // Title is not shown
      expect(find.byType(Image), findsNWidgets(2));
    });

    testWidgets('TrendingSlider navigates to FilmInfo on tap', (WidgetTester tester) async {
      // Arrange
      final movie = Movie(
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
            trailerUrl: '');

      var mockClient;
      when(mockClient.get(Uri.parse(
              'https://api.themoviedb.org/3/movie/1?api_key=${Constants.apiKey}&language=es-ES')))
          .thenAnswer((_) async => http.Response(
              json.encode({
                'overview': 'Test Overview',
                'backdrop_path': '/backdrop.jpg',
                'runtime': 120,
                'release_date': '2024-01-01',
                'vote_average': 8.5,
                'genres': [
                  {'name': 'Action'},
                  {'name': 'Adventure'}
                ],
              }),
              200));

      when(mockClient.get(Uri.parse(
              'https://api.themoviedb.org/3/movie/1/credits?api_key=${Constants.apiKey}')))
          .thenAnswer((_) async => http.Response(
              json.encode({
                'crew': [
                  {'job': 'Director', 'name': 'Test Director'}
                ]
              }),
              200));

      when(mockClient.get(Uri.parse(
              'https://api.themoviedb.org/3/movie/1/videos?api_key=${Constants.apiKey}&language=es-ES')))
          .thenAnswer((_) async => http.Response(
              json.encode({
                'results': [
                  {
                    'site': 'YouTube',
                    'type': 'Trailer',
                    'key': 'testkey'
                  }
                ]
              }),
              200));

      final movies = [movie];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TrendingSlider(movies: movies),
        ),
      ));

      // Act
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FilmInfo), findsOneWidget);
      expect(find.text('Test Movie'), findsOneWidget);
    });
  });
}
