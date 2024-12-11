import 'dart:convert';
import 'package:film_finder/methods/api.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


@GenerateMocks([http.Client])
void main() {
  group('Api', () {
    late MockClient mockClient;
    late Api api;

    setUp(() {
      api = Api();
    });

    test('getTrendingMovies returns a list of movies on success', () async {
      // Datos simulados
      const mockResponseData = '''
        {
          "results": [
            {
              "id": 1,
              "title": "Mock Movie",
              "poster_path": "/mockposter.jpg"
            }
          ]
        }
      ''';

      final movies = await api.getTrendingMovies();

      // Verificaciones
      expect(movies, isA<List<Movie>>());
      expect(movies.length, 1);
      expect(movies.first.title, 'Mock Movie');
      expect(movies.first.posterPath, '/mockposter.jpg');
    });

    test('getTopRatedMovies throws an exception on error', () async {
      expect(() async => await api.getTopRatedMovies(), throwsException);
    });
  });
}
