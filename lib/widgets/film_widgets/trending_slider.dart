import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrendingSlider extends StatelessWidget {
  final List<Movie> movies;

  const TrendingSlider({
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
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: movies.length,
        options: CarouselOptions(
          height: 300,
          autoPlay: true,
          viewportFraction: 0.55,
          enlargeCenterPage: true,
          pageSnapping: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 5),
        ),
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return GestureDetector(
            onTap: () async {
              try {
                final movie = movies[itemIndex];
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
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                width: 200,
                child: Image.network(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  '${Constants.imagePath}${movies[itemIndex].posterPath}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
