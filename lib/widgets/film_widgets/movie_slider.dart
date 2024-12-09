import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/methods/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieSlider extends StatelessWidget {
  final List<Movie> movies;

  const MovieSlider({
    super.key,
    required this.movies,
  });

  Future<Movie> fetchMovieDetails(Movie movie) async {
    final detailsURL =
        'https://api.themoviedb.org/3/movie/${movie.id}?api_key=${Constants.apiKey}&language=es-ES';
    final creditsURL =
        'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=${Constants.apiKey}';
    final videosURL =
        'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=${Constants.apiKey}&language=es-ES';

    try {
      final responses = await Future.wait([
        http.get(Uri.parse(detailsURL)),
        http.get(Uri.parse(creditsURL)),
        http.get(Uri.parse(videosURL)),
      ]);

      if (responses[0].statusCode == 200) {
        final detailsData = json.decode(responses[0].body);
        movie.overview = detailsData['overview'] ?? 'No overview available';
        movie.backDropPath = detailsData['backdrop_path'] ?? '';
        movie.duration = detailsData['runtime'] ?? 0;
        movie.releaseDay = detailsData['release_date'] ?? 'Unknown';
        movie.voteAverage = detailsData['vote_average']?.toDouble() ?? 0.0;
        if (detailsData['genres'] != null) {
          movie.genres = (detailsData['genres'] as List)
              .map((genre) => genre['name'] as String)
              .toList();
        }
      }

      if (responses[1].statusCode == 200) {
        final creditsData = json.decode(responses[1].body);
        final crewList = creditsData['crew'] as List<dynamic>;
        for (var crewMember in crewList) {
          if (crewMember['job'] == 'Director') {
            movie.director = crewMember['name'];
            break;
          }
        }
      }

      if (responses[2].statusCode == 200) {
        final videosData = json.decode(responses[2].body);
        final videosList = videosData['results'] as List<dynamic>;
        for (var video in videosList) {
          if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
            movie.trailerUrl =
                'https://www.youtube.com/watch?v=${video['key']}';
            break;
          }
        }
      }
    } catch (e) {
      print('Error al obtener detalles de la película: $e');
    }

    return movie;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  final movie = movies[index];
                  final updatedMovie = await fetchMovieDetails(movie);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmInfo(
                        movie: updatedMovie,
                        pop: true,
                        favorite: false,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error al cargar detalles de la película: $e');
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  width: 140,
                  child: Image.network(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fill,
                    '${Constants.imagePath}${movies[index].posterPath}',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
