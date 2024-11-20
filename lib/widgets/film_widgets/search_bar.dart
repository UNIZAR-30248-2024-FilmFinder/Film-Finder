import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:film_finder/pages/film_pages/film_screen.dart';
import 'package:film_finder/methods/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';

import '../../methods/movie.dart';
import 'package:http/http.dart' as http;

class SearchingBar extends StatefulWidget {
  final Function(bool) onSearchToggled;

  const SearchingBar({super.key, required this.onSearchToggled});

  @override
  // ignore: library_private_types_in_public_api
  _SearchingBarState createState() => _SearchingBarState();
}

class _SearchingBarState extends State<SearchingBar> {
  final TextEditingController searchText = TextEditingController();

  var val1;
  List<Movie> movies = [];
  bool showList = false;

  Future<void> onTapMovie(Movie movie) async {
    await _fetchMovieDetails(movie.id);
  }

  //FUNCIÓN QUE EXTRAE LA INFO NECESARIA PARA MOSTRAR EN EL BUSCADOR
  Future<void> searchListFunction(String val) async {
    String searchURL =
        'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$val&language=es-ES';

    var searchResponse = await http.get(Uri.parse(searchURL));

    if (searchResponse.statusCode == 200) {
      var tempData = jsonDecode(searchResponse.body);
      var searchJson = tempData['results'];

      // Limpiamos la lista de películas antes de llenarla nuevamente
      movies.clear();

      for (var i in searchJson) {
        if (i['id'] != null &&
            i['poster_path'] != null &&
            i['vote_average'] != null &&
            i['media_type'] == 'movie') {
          // Añadimos solo la información básica a la lista de películas
          movies.add(Movie(
            id: i['id'] ?? 0,
            title: i['title'] ?? 'No title',
            posterPath: i['poster_path'] ?? '',
            releaseDay: i['release_date'] ?? 'Unknown',
            voteAverage: (i['vote_average'] as num).toDouble(),
            mediaType: i['media_type'],
            // La información adicional la dejaremos en valores predeterminados
            director: 'Unknown Director',
            duration: 0,
            genres: [],
            backDropPath: '',
            overview: 'No overview available',
            trailerUrl: '',
          ));

          // Limitamos a 15 películas
          if (movies.length >= 15) break;
        }
      }
    } else {
      print('Error: No se pudo obtener la información');
    }
  }

// FUNCIÓN QUE EXTRAE EL RESTO DE INFORMACIÓN NECESARIA PARA CARGAR LA PÁGINA DE PELÍCULA
  Future<void> _fetchMovieDetails(int movieId) async {
    try {
      // Definimos las URLs para obtener detalles y créditos
      String creditsURL =
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${Constants.apiKey}';
      String detailsURL =
          'https://api.themoviedb.org/3/movie/$movieId?api_key=${Constants.apiKey}&language=es-ES';
      String videosURL =
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=${Constants.apiKey}&language=es-ES';

      // Ejecutamos las solicitudes de forma paralela
      var responses = await Future.wait([
        http.get(Uri.parse(creditsURL)),
        http.get(Uri.parse(detailsURL)),
        http.get(Uri.parse(videosURL)), // Añadido para obtener los videos
      ]);

      var creditsResponse = responses[0];
      var detailsResponse = responses[1];
      var videosResponse = responses[2]; // Respuesta para los videos

      // Procesamos la información de los créditos
      String director = 'Unknown Director';
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

      // Procesamos los detalles de la película
      int runtime = 0;
      List<String> genresList = [];
      String overview = 'No overview available';
      String backDropPath = '';
      String trailerUrl = '';

      if (detailsResponse.statusCode == 200) {
        var detailsData = jsonDecode(detailsResponse.body);
        runtime = detailsData['runtime'] ?? 0;
        overview = detailsData['overview'] ?? overview;
        backDropPath = detailsData['backdrop_path'] ?? backDropPath;

        if (detailsData['genres'] != null) {
          genresList = (detailsData['genres'] as List)
              .map((genre) => genre['name'] as String)
              .toList();
        }
      }

      // Procesamos la respuesta de los videos para obtener el tráiler
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

      // Buscamos la película por ID y actualizamos sus detalles
      for (var movie in movies) {
        if (movie.id == movieId) {
          movie.director = director;
          movie.duration = runtime;
          movie.genres = genresList;
          movie.overview = overview;
          movie.backDropPath = backDropPath;
          movie.trailerUrl = trailerUrl; // Asigna la URL del tráiler
          break;
        }
      }
    } catch (e) {
      print('Error al obtener detalles de la película $movieId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showList != showList;
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                autofocus: false,
                controller: searchText,
                onSubmitted: (value) {
                  movies.clear();

                  setState(
                    () {
                      val1 = value;
                    },
                  );
                  if (searchText.text.isEmpty) {
                    setState(() {
                      widget.onSearchToggled(false);
                    });
                  }
                },
                onChanged: (value) {
                  setState(
                    () {
                      movies.clear();

                      setState(
                        () {
                          val1 = value;
                        },
                      );
                      if (searchText.text.isEmpty) {
                        setState(() {
                          widget.onSearchToggled(false);
                        });
                      } else {
                        setState(() {
                          widget.onSearchToggled(true);
                        });
                      }
                    },
                  );
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        msg: "Búsqueda borrada",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                        textColor: Colors.white,
                        fontSize: 16,
                      );
                      setState(() {
                        searchText.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                        widget.onSearchToggled(false);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color:
                          const Color.fromRGBO(190, 49, 68, 1).withOpacity(0.6),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromRGBO(190, 49, 68, 1),
                  ),
                  hintText: 'Buscar Película',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            if (searchText.text.length > 0)
              FutureBuilder(
                  future: searchListFunction(val1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: 400,
                        child: ListView.builder(
                          itemCount: movies.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            String posterUrl =
                                'https://image.tmdb.org/t/p/original${movies[index].posterPath}';
                            return GestureDetector(
                              onTap: () async {
                                await _fetchMovieDetails(movies[index].id);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilmInfo(
                                      movie: movies[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 5),
                                margin:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(21, 4, 29, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      key: ValueKey(
                                          'movieImage_${movies[index].id}'),
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            posterUrl,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            movies[index].title,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Año de estreno: ${DateTime.parse(movies[index].releaseDay).year}',
                                                softWrap: true,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      movies[index]
                                                          .voteAverage
                                                          .toStringAsFixed(1),
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
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
                    } else {
                      return Container(
                        height: 400,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(190, 49, 68, 1),
                          ),
                        ),
                      );
                    }
                  })
          ],
        ),
      ),
    );
  }
}
