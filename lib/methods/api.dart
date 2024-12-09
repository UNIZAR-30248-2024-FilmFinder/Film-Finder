import 'dart:convert';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/methods/constants.dart';

import 'package:http/http.dart' as http;

class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';

  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';

  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=${Constants.apiKey}';

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map<Movie>((movieData) {
        return Movie(
            id: movieData['id'] ?? 0,
            title: movieData['title'] ?? 'Unknown',
            posterPath: movieData['poster_path'] ?? '',
            backDropPath: '',
            overview: '',
            director: 'Unknown',
            trailerUrl: '',
            duration: 0,
            genres: [],
            releaseDay: '',
            voteAverage: 0,
            mediaType: 'movie');
      }).toList();
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      List<Movie> movies = decodedData.map<Movie>((movieData) {
        return Movie(
          id: movieData['id'] ?? 0,
          title: movieData['title'] ?? 'Unknown',
          posterPath: movieData['poster_path'] ?? '',
          backDropPath: '',
          overview: '',
          director: 'Unknown',
          trailerUrl: '',
          duration: 0,
          genres: [],
          releaseDay: '',
          voteAverage: 0,
          mediaType: 'movie',
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upcomingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      List<Movie> movies = decodedData.map<Movie>((movieData) {
        return Movie(
          id: movieData['id'] ?? 0,
          title: movieData['title'] ?? 'Unknown',
          posterPath: movieData['poster_path'] ?? '',
          backDropPath: '',
          overview: '',
          director: 'Unknown',
          trailerUrl: '',
          duration: 0,
          genres: [],
          releaseDay: '',
          voteAverage: 0,
          mediaType: 'movie',
        );
      }).toList();

      return movies;
    } else {
      throw Exception('Something went wrong.');
    }
  }
}
