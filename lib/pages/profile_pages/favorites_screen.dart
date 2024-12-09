import 'dart:convert';
import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.movieIds});

  final List<int> movieIds;

  Future<List<Map<String, dynamic>>> fetchAllMoviesInfo() async {
    return Future.wait(movieIds.map((movieId) async {
      return await fetchBasicMovieInfo(movieId);
    }));
  }

  Future<Map<String, dynamic>> fetchBasicMovieInfo(int movieId) async {
    String detailsURL =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=${Constants.apiKey}&language=es-ES';

    try {
      var response = await http.get(Uri.parse(detailsURL));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        String title = data['title'] ?? 'Título desconocido';
        String releaseDate = data['release_date'] ?? 'Fecha no disponible';
        String posterPath = data['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/original${data['poster_path']}'
            : '';

        return {
          'title': title,
          'releaseDate': releaseDate,
          'posterPath': posterPath,
          'movieId': movieId,
        };
      } else {
        print('Error: No se pudo obtener la información de la película.');
        return {
          'title': 'Error',
          'releaseDate': 'Error',
          'posterPath': '',
          'movieId': movieId,
        };
      }
    } catch (e) {
      print('Error al obtener información de la película $movieId: $e');
      return {
        'title': 'Error',
        'releaseDate': 'Error',
        'posterPath': '',
        'movieId': movieId,
      };
    }
  }

  Future<Movie?> fetchMovieData(int movieId) async {
    try {
      // URLs para obtener datos
      String detailsURL =
          'https://api.themoviedb.org/3/movie/$movieId?api_key=${Constants.apiKey}&language=es-ES';
      String creditsURL =
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${Constants.apiKey}';
      String videosURL =
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${Constants.apiKey}&language=es-ES';

      var responses = await Future.wait([
        http.get(Uri.parse(detailsURL)),
        http.get(Uri.parse(creditsURL)),
        http.get(Uri.parse(videosURL)),
      ]);

      var detailsResponse = responses[0];
      var creditsResponse = responses[1];
      var videosResponse = responses[2];

      String title = 'No title';
      String backDropPath = '';
      String overview = 'No overview available';
      String posterPath = '';
      String releaseDay = 'Unknown';
      double voteAverage = 0.0;
      String director = 'Unknown Director';
      int duration = 0;
      List<String> genres = [];
      String trailerUrl = '';

      if (detailsResponse.statusCode == 200) {
        var detailsData = jsonDecode(detailsResponse.body);
        title = detailsData['title'] ?? title;
        backDropPath = detailsData['backdrop_path'] ?? backDropPath;
        overview = detailsData['overview'] ?? overview;
        posterPath = detailsData['poster_path'] ?? posterPath;
        releaseDay = detailsData['release_date'] ?? releaseDay;
        voteAverage = (detailsData['vote_average'] as num?)?.toDouble() ?? 0.0;
        duration = detailsData['runtime'] ?? 0;

        if (detailsData['genres'] != null) {
          genres = (detailsData['genres'] as List)
              .map((genre) => genre['name'] as String)
              .toList();
        }
      }

      if (creditsResponse.statusCode == 200) {
        var creditsData = jsonDecode(creditsResponse.body);
        var crewList = creditsData['crew'] as List<dynamic>;
        for (var crewMember in crewList) {
          if (crewMember['job'] == 'Director') {
            director = crewMember['name'];
            break;
          }
        }
      }

      if (videosResponse.statusCode == 200) {
        var videosData = jsonDecode(videosResponse.body);
        var videosList = videosData['results'] as List<dynamic>;
        for (var video in videosList) {
          if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
            trailerUrl = 'https://www.youtube.com/watch?v=${video['key']}';
            break;
          }
        }
      }

      return Movie(
        id: movieId,
        title: title,
        backDropPath: backDropPath,
        overview: overview,
        posterPath: posterPath,
        releaseDay: releaseDay,
        voteAverage: voteAverage,
        mediaType: 'movie',
        director: director,
        duration: duration,
        genres: genres,
        trailerUrl: trailerUrl,
      );
    } catch (e) {
      print('Error al cargar datos de la película $movieId: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
        title: const Text(
          "Favoritas",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrincipalScreen(initialIndex: 3),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllMoviesInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar las películas: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay películas favoritas.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var moviesInfo = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: moviesInfo.length,
              itemBuilder: (context, index) {
                var info = moviesInfo[index];

                String title = info['title'] ?? 'Título desconocido';
                String releaseDate = info['releaseDate'] ?? '';
                String posterPath = info['posterPath'] ?? '';
                int movieId = info['movieId'] ?? '';

                return GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    Movie? movie = await fetchMovieData(movieId);

                    Navigator.pop(context);

                    if (movie != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmInfo(
                            movie: movie,
                            pop: true,
                            favorite: true,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'No se pudo cargar la información de la película.'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    height: 125,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(21, 4, 29, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        // Imagen de poster
                        Container(
                          width: MediaQuery.of(context).size.width * 0.22,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(posterPath),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '${DateTime.parse(releaseDate).year}',
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              190, 49, 68, 1)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Color.fromRGBO(190, 49, 68, 1),
                                      size: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 25),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
