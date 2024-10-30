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
      const int batchSize = 5;
      List<Movie> movies = [];
      for (int i = 0; i < decodedData.length; i += batchSize) {
        final batch = decodedData.skip(i).take(batchSize);
        await Future.wait(batch.map((movieData) async {
          Movie movie = Movie.fromJson(movieData);
          try {
            String creditsURL =
                'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=${Constants.apiKey}';
            String detailsURL =
                'https://api.themoviedb.org/3/movie/${movie.id}?api_key=${Constants.apiKey}&language=es-ES';
            String videosURL =
                'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=${Constants.apiKey}&language=es-ES';
            var responses = await Future.wait([
              http.get(Uri.parse(creditsURL)),
              http.get(Uri.parse(detailsURL)),
              http.get(Uri.parse(videosURL)),
            ]);
            var creditsResponse = responses[0];
            var detailsResponse = responses[1];
            var videosResponse = responses[2];
            if (creditsResponse.statusCode == 200) {
              var creditsData = json.decode(creditsResponse.body);
              var crewList = creditsData['crew'] as List<dynamic>;
              for (var crewMember in crewList) {
                if (crewMember['job'] == 'Director') {
                  movie.director = crewMember['name'];
                  break;
                }
              }
            }
            if (detailsResponse.statusCode == 200) {
              var detailsData = json.decode(detailsResponse.body);
              movie.duration = detailsData['runtime'] ?? 0;
              movie.overview = detailsData['overview'] ?? 'No overview available';
              movie.backDropPath = detailsData['backdrop_path'] ?? '';

              if (detailsData['genres'] != null) {
                movie.genres = (detailsData['genres'] as List)
                    .map((genre) => genre['name'] as String)
                    .toList();
              }
            }
            if (videosResponse.statusCode == 200) {
              var videosData = json.decode(videosResponse.body);
              var videosList = videosData['results'] as List<dynamic>;
              for (var video in videosList) {
                if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
                  movie.trailerUrl = 'https://www.youtube.com/watch?v=${video['key']}';
                  break;
                }
              }
            }
          } catch (e) {
            print('Error al obtener detalles de la película ${movie.id}: $e');
          }
          movies.add(movie);
        }));
      }
      return movies;
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      const int batchSize = 5;
      List<Movie> movies = [];
      for (int i = 0; i < decodedData.length; i += batchSize) {
        final batch = decodedData.skip(i).take(batchSize);
        await Future.wait(batch.map((movieData) async {
          Movie movie = Movie.fromJson(movieData);
          try {
            String creditsURL =
                'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=${Constants.apiKey}';
            String detailsURL =
                'https://api.themoviedb.org/3/movie/${movie.id}?api_key=${Constants.apiKey}&language=es-ES';
            String videosURL =
                'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=${Constants.apiKey}&language=es-ES';
            var responses = await Future.wait([
              http.get(Uri.parse(creditsURL)),
              http.get(Uri.parse(detailsURL)),
              http.get(Uri.parse(videosURL)),
            ]);
            var creditsResponse = responses[0];
            var detailsResponse = responses[1];
            var videosResponse = responses[2];
            if (creditsResponse.statusCode == 200) {
              var creditsData = json.decode(creditsResponse.body);
              var crewList = creditsData['crew'] as List<dynamic>;
              for (var crewMember in crewList) {
                if (crewMember['job'] == 'Director') {
                  movie.director = crewMember['name'];
                  break;
                }
              }
            }
            if (detailsResponse.statusCode == 200) {
              var detailsData = json.decode(detailsResponse.body);
              movie.duration = detailsData['runtime'] ?? 0;
              movie.overview = detailsData['overview'] ?? 'No overview available';
              movie.backDropPath = detailsData['backdrop_path'] ?? '';
              if (detailsData['genres'] != null) {
                movie.genres = (detailsData['genres'] as List)
                    .map((genre) => genre['name'] as String)
                    .toList();
              }
            }
            if (videosResponse.statusCode == 200) {
              var videosData = json.decode(videosResponse.body);
              var videosList = videosData['results'] as List<dynamic>;
              for (var video in videosList) {
                if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
                  movie.trailerUrl = 'https://www.youtube.com/watch?v=${video['key']}';
                  break;
                }
              }
            }
          } catch (e) {
            print('Error al obtener detalles de la película ${movie.id}: $e');
          }
          movies.add(movie);
        }));
      }
      return movies;
    } else {
      throw Exception('Something went wrong.');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upcomingUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      List<Movie> upcomingMovies = decodedData.map((movie) => Movie.fromJson(movie)).toList();
      const batchSize = 5;
      for (var i = 0; i < upcomingMovies.length; i += batchSize) {
        final batch = upcomingMovies.skip(i).take(batchSize).toList();
        await Future.wait(batch.map((movie) async {
          try {
            final creditsURL = 'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=${Constants.apiKey}';
            final detailsURL = 'https://api.themoviedb.org/3/movie/${movie.id}?api_key=${Constants.apiKey}&language=es-ES';
            final videosURL = 'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=${Constants.apiKey}&language=es-ES';
            final responses = await Future.wait([
              http.get(Uri.parse(creditsURL)),
              http.get(Uri.parse(detailsURL)),
              http.get(Uri.parse(videosURL)),
            ]);
            final creditsResponse = responses[0];
            final detailsResponse = responses[1];
            final videosResponse = responses[2];
            if (creditsResponse.statusCode == 200) {
              final creditsData = jsonDecode(creditsResponse.body);
              final crewList = creditsData['crew'] as List<dynamic>;
              final director = crewList.firstWhere(
                (crew) => crew['job'] == 'Director',
                orElse: () => {'name': 'Unknown Director'},
              )['name'];
              movie.director = director;
            }
            if (detailsResponse.statusCode == 200) {
              final detailsData = jsonDecode(detailsResponse.body);
              movie.duration = detailsData['runtime'] ?? 0;
              movie.overview = detailsData['overview'] ?? 'No overview available';
              movie.backDropPath = detailsData['backdrop_path'] ?? '';
              movie.genres = (detailsData['genres'] as List<dynamic>?)
                      ?.map((genre) => genre['name'] as String)
                      .toList() ??
                  [];
            }
            if (videosResponse.statusCode == 200) {
              final videosData = jsonDecode(videosResponse.body);
              final trailer = videosData['results']
                  .firstWhere(
                    (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
                    orElse: () => null,
                  );
              movie.trailerUrl = trailer != null ? 'https://www.youtube.com/watch?v=${trailer['key']}' : '';
            }
          } catch (e) {
            print('Error al obtener detalles de la película ${movie.id}: $e');
          }
        }));
      }

      return upcomingMovies;
    } else {
      throw Exception('Something went wrong.');
    }
  }
}
