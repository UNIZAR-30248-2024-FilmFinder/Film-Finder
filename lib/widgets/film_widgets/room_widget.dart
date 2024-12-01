import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:film_finder/methods/constants.dart';
import 'package:film_finder/methods/room_logic.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:film_finder/widgets/filters_widgets/filters_widget.dart';
import 'package:film_finder/pages/film_pages/filter_grupal.dart';

void showLoadingDialog(BuildContext context, bool isCreatingRoom) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(21, 4, 29, 1),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: const Color.fromRGBO(190, 49, 68, 1),
              width: 2.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(190, 49, 68, 1)),
              ),
              const SizedBox(width: 20),
              Text(
                isCreatingRoom ? "Creando sala..." : "Uniéndose a la sala...",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showExitConfirmation(BuildContext context, bool isAdmin, String code) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(21, 4, 29, 1),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: const Color.fromRGBO(190, 49, 68, 1),
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirmación',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15.0),
              const Divider(
                color: Color.fromRGBO(190, 49, 68, 1),
                thickness: 2.0,
                height: 20.0,
              ),
              const SizedBox(height: 5.0),
              Text(
                isAdmin
                    ? '¿Seguro que quieres salir de la sala? \n Esto borrará la sala.'
                    : '¿Seguro que quieres salir de la sala?',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(190, 49, 68, 1),
                          width: 1.0,
                        ),
                      ),
                      fixedSize: const Size(115, 42),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Cerrar el diálogo de confirmación
                      Navigator.of(context).pop();
                      // Cerrar el popup principal
                      Navigator.of(context).pop();
                      if (isAdmin) {
                        // El usuario es administrador, elimina la sala
                        try {
                          await deleteRoomByCode(code);
                          print('Sala eliminada con éxito');
                        } catch (e) {
                          print('Error al eliminar la sala: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('No se pudo eliminar la sala')),
                          );
                        }
                      } else {
                        // El usuario solo abandona la sala
                        try {
                          await leaveRoom(code);
                          print('El usuario abandonó la sala');
                        } catch (e) {
                          print('Error al salirse de la sala: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'No se pudo salirse de la sala correctamente')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(190, 49, 68, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(190, 49, 68, 1),
                          width: 1.0,
                        ),
                      ),
                      fixedSize: const Size(115, 42),
                    ),
                    child: const Text(
                      'Salir',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class RoomPopup extends StatefulWidget {
  const RoomPopup({super.key, required this.code, required this.isAdmin});

  final String code;
  final bool isAdmin;

  @override
  // ignore: library_private_types_in_public_api
  _RoomPopupState createState() => _RoomPopupState();
}

class _RoomPopupState extends State<RoomPopup> with WidgetsBindingObserver {
  List<Movie> movies = [];
  List<String> filterGenres = [];
  List<String> filterProviders = [];
  List<int> arrayGenres = List.filled(19, 0);
  List<int> arrayProviders = List.filled(5, 0);

  @override
  void initState() {
    super.initState();

    // Configurar el listener usando la función modular
    listenToRoomDeletionByCode(widget.code, () {
      if (mounted) {
        // Cierra todos los diálogos abiertos
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    // Añadir el observer para detectar el ciclo de vida de la app
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Limpiar el observer cuando el widget sea destruido
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) {
      // La aplicación se va a cerrar
      handleAppExit();
    }
  }

  void handleAppExit() {
    // Si el usuario es el administrador, eliminamos la sala
    if (widget.isAdmin) {
      deleteRoomByCode(widget.code);
    } else {
      // Si el usuario no es admin, solo lo eliminamos de la sala
      leaveRoom(widget.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(21, 4, 29, 1),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: const Color.fromRGBO(190, 49, 68, 1),
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sala del Grupo',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15.0),
            const Divider(
              color: Color.fromRGBO(190, 49, 68, 1),
              thickness: 2.0,
              height: 20.0,
            ),
            const SizedBox(height: 5.0),
            Column(
              children: [
                const Text(
                  'Código de la sala',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.code));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(34, 9, 44, 1),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color.fromRGBO(190, 49, 68, 1),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      widget.code,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            const Divider(
              color: Color.fromRGBO(190, 49, 68, 1),
              thickness: 2.0,
              height: 20.0,
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Miembros del grupo',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getRoomMembersStream(widget.code),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Cargando
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final members = snapshot.data ?? [];

                    // Mostrar la lista de miembros
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...members.map((memberData) {
                          return Row(
                            children: [
                              const Icon(Icons.person, color: Colors.blue),
                              const SizedBox(width: 10.0),
                              Text(
                                memberData['name'] ?? 'Usuario desconocido',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 48.0,
                  height: 48.0,
                ),
                widget.isAdmin
                    ? ElevatedButton(
                        onPressed: () async {
                          showLoadingListDialog(context);
                          await fetchTopRatedMovies();
                          if (movies.isEmpty) {
                            print('No se encontraron películas.');
                          } else {
                            print('Se encontraron ${movies.length} películas.');
                          }
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterGrupalScreen(
                                movies: movies,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(190, 49, 68, 1),
                              width: 1.0,
                            ),
                          ),
                          fixedSize: const Size(115, 42),
                        ),
                        child: const Text(
                          'Comenzar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 115,
                        height: 42,
                      ),
                IconButton(
                  onPressed: () {
                    showExitConfirmation(context, widget.isAdmin, widget.code);
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 33,
                  ),
                  color: const Color.fromRGBO(190, 49, 68, 1),
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchTopRatedMovies() async {
    movies = [];
    print('filterGenres: $filterGenres');
    print('arrayGenres: $arrayGenres');
    print('filterProviders: $filterProviders');
    print('arrayProviders: $arrayProviders');

    String url;
    if (filterGenres.isNotEmpty && filterProviders.isNotEmpty) {
      String genreString = filterGenres.join('%2C');
      String providerString = filterProviders.join('%7C');
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&language=es-ES&page=1&region=ES&sort_by=popularity.desc&with_genres=$genreString&with_watch_providers=$providerString';
    } else if (filterGenres.isNotEmpty && filterProviders.isEmpty) {
      String genreString = filterGenres.join('%2C');
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&language=es-ES&page=1&region=ES&sort_by=popularity.desc&with_genres=$genreString';
    } else if (filterGenres.isEmpty && filterProviders.isNotEmpty) {
      String providerString = filterProviders.join('%7C');
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&language=es-ES&page=1&region=ES&sort_by=popularity.desc&with_watch_providers=$providerString';
    } else {
      url =
          'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&language=es-ES&page=1&region=ES&sort_by=popularity.desc';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      const int batchSize = 5;
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
              movie.overview =
                  detailsData['overview'] ?? 'No overview available';
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
                  movie.trailerUrl =
                      'https://www.youtube.com/watch?v=${video['key']}';
                  break;
                }
              }
            }
          } catch (e) {
            print('Error al obtener detalles de la película ${movie.id}: $e');
          }
          movies.add(movie);
        }));
        filterGenres = [];
        filterProviders = [];
        arrayGenres.fillRange(0, arrayGenres.length, 0);
        arrayProviders.fillRange(0, arrayProviders.length, 0);
      }
    } else {
      throw Exception('Something went wrong.');
    }
  }

  void showLoadingListDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(21, 4, 29, 1),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: const Color.fromRGBO(190, 49, 68, 1),
                  width: 2.0,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(190, 49, 68, 1)),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Cargando lista...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
