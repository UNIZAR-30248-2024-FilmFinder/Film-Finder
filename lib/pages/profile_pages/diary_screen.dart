import 'dart:convert';
import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/film_pages/add_film_diary_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Diary extends StatelessWidget {
  const Diary({super.key, required this.movies});

  final List<MovieDiaryEntry> movies;

  Future<List<Map<String, dynamic>>> fetchAllMoviesInfo() async {
    return Future.wait(movies.map((movie) async {
      var basicInfo = await fetchBasicMovieInfo(movie.movieId);
      return {
        'movie': movie,
        'info': basicInfo,
      };
    }));
  }

  Future<Map<String, String>> fetchBasicMovieInfo(int movieId) async {
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
        };
      } else {
        print('Error: No se pudo obtener la información de la película.');
        return {
          'title': 'Error',
          'releaseDate': 'Error',
          'posterPath': '',
        };
      }
    } catch (e) {
      print('Error al obtener información de la película $movieId: $e');
      return {
        'title': 'Error',
        'releaseDate': 'Error',
        'posterPath': '',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
        title: const Text(
          "Diario",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                "No hay películas en el diario.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var moviesInfo = snapshot.data!;
          Map<String, List<Map<String, dynamic>>> groupedMovies = {};

          for (var entry in moviesInfo) {
            var movie = entry['movie'] as MovieDiaryEntry;
            var info = entry['info'] as Map<String, String>;

            String monthKey =
                DateFormat('yyyy-MM').format(DateTime.parse(movie.viewingDate));
            if (!groupedMovies.containsKey(monthKey)) {
              groupedMovies[monthKey] = [];
            }
            groupedMovies[monthKey]!.add({'movie': movie, 'info': info});
          }

          List<String> sortedKeys = groupedMovies.keys.toList()
            ..sort(
              (a, b) =>
                  DateTime.parse('$b-01').compareTo(DateTime.parse('$a-01')),
            );

          for (var key in groupedMovies.keys) {
            groupedMovies[key]!.sort((a, b) {
              var movieA = a['movie'] as MovieDiaryEntry;
              var movieB = b['movie'] as MovieDiaryEntry;
              return DateTime.parse(movieB.viewingDate)
                  .compareTo(DateTime.parse(movieA.viewingDate));
            });
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              itemCount: groupedMovies.length,
              itemBuilder: (context, index) {
                final monthKey = sortedKeys[index];
                final monthMovies = groupedMovies[monthKey]!;

                final monthLabel = DateFormat('MMMM yyyy', 'es')
                    .format(DateTime.parse('$monthKey-01'));

                return Column(
                  children: [
                    const Divider(
                      color: Color.fromRGBO(190, 49, 68, 1),
                      thickness: 1,
                      endIndent: 75,
                      indent: 75,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      color: const Color.fromRGBO(34, 9, 44, 1),
                      child: Text(
                        monthLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(190, 49, 68, 1),
                      thickness: 1,
                      endIndent: 75,
                      indent: 75,
                    ),
                    ...monthMovies.map(
                      (entry) {
                        var movie = entry['movie'] as MovieDiaryEntry;
                        var info = entry['info'] as Map<String, String>;

                        String title = info['title'] ?? 'Título desconocido';
                        String releaseDate = info['releaseDate'] ?? '';
                        String posterPath = info['posterPath'] ?? '';

                        return Row(
                          children: [
                            // Contenedor con el día
                            Container(
                              width: 75,
                              height: 125,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(21, 4, 29, 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                              ),
                              child: Text(
                                DateTime.parse(movie.viewingDate)
                                    .day
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DiaryFilm(
                                        movieId: movie.movieId,
                                        posterPath: posterPath,
                                        title: title,
                                        releaseDay: releaseDate,
                                        isEditing: true,
                                        editDate: movie.viewingDate,
                                        editRating: movie.personalRating,
                                        editReview: movie.review,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5),
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  height: 125,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(21, 4, 29, 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    children: [
                                      // Imagen de poster
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          image: DecorationImage(
                                            image: NetworkImage(posterPath),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 2,
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color
                                                            .fromRGBO(
                                                            190, 49, 68, 1)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        movie.personalRating
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 15,
                                                      ),
                                                    ],
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
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
