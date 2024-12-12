import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:film_finder/methods/movie.dart';
import 'dart:math';
import 'package:film_finder/pages/film_pages/film_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class SwiperGrupal extends StatefulWidget {
  final List<Movie> movies;
  final int user;
  final String roomCode;

  const SwiperGrupal({
    super.key,
    required this.movies,
    required this.user,
    required this.roomCode,
  });

  @override
  State<SwiperGrupal> createState() => _SwiperGrupalState();
}

class _SwiperGrupalState extends State<SwiperGrupal> {
  int currentindex = 0;
  final CardSwiperController _cardSwiperController =
      CardSwiperController(); // Controlador del Swiper

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isNotEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: CardSwiper(
                    controller: _cardSwiperController,
                    cardsCount: min(20, widget.movies.length),
                    cardBuilder: (context, index, x, y) {
                      String posterUrl =
                          'https://image.tmdb.org/t/p/original${widget.movies[index].posterPath}';
                      return CardFilter(
                        image: posterUrl,
                        title: widget.movies[index].title,
                        overview: widget.movies[index].overview,
                        releaseDate: widget.movies[index].releaseDay,
                        voteAverage: widget.movies[index].voteAverage,
                      );
                    },
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                        left: true, right: true),
                    numberOfCardsDisplayed: 4,
                    backCardOffset: const Offset(0, 0),
                    onSwipe: (previous, current, direction) async {
                      currentindex++;

                      // Manejo de dirección del swipe
                      if (direction == CardSwiperDirection.right) {
                        await actualizaVector(
                            widget.roomCode, widget.user, 2, currentindex - 1);
                        Fluttertoast.showToast(
                            msg: 'Te ha gustado',
                            backgroundColor: Colors.black,
                            fontSize: 28);
                        Future.delayed(const Duration(milliseconds: 750), () {
                          Fluttertoast.cancel();
                        });
                        if (currentindex == 20) {
                          currentindex = 0;
                        }
                      } else if (direction == CardSwiperDirection.left) {
                        await actualizaVector(
                            widget.roomCode, widget.user, 1, currentindex - 1);
                        Fluttertoast.showToast(
                            msg: 'No te ha gustado',
                            backgroundColor: Colors.black,
                            fontSize: 28);
                        Future.delayed(const Duration(milliseconds: 750), () {
                          Fluttertoast.cancel();
                        });
                        if (currentindex == 20) {
                          currentindex = 0;
                        }
                      }

                      // Comprobar si todos los usuarios han deslizado hacia la derecha para la película actual
                      final roomSnapshot = await FirebaseFirestore.instance
                          .collection('rooms')
                          .where('code', isEqualTo: widget.roomCode)
                          .get();

                      if (roomSnapshot.docs.isEmpty) {
                        print('No se encontró la sala.');
                      }

                      final roomDoc = roomSnapshot.docs.first;
                      Map<String, dynamic> roomData =
                          roomDoc.data() as Map<String, dynamic>;
                      List<dynamic> matrix = roomData['matrix'] ?? [];
                      List<dynamic> members = roomData['members'] ?? [];

                      int selectedMovieIndex =
                          -1; // Variable para almacenar el índice de la película seleccionada

                      for (int movieIndex = 0; movieIndex < 20; movieIndex++) {
                        bool allLiked = true;

                        for (int i = 0; i < members.length; i++) {
                          int indexToCheck = 20 * i +
                              movieIndex; // Índice en la matriz para la película actual

                          if (matrix[indexToCheck] != 2) {
                            allLiked = false;
                            break; // Si un usuario no ha deslizado hacia la derecha, salimos del bucle
                          }
                        }
                        if (allLiked) {
                          selectedMovieIndex =
                              movieIndex; // Guardamos el índice de la película seleccionada
                          break; // Salimos del bucle una vez que encontramos una película válida
                        }
                      }

                      if (selectedMovieIndex != -1) {
                        // Redirigir a la pantalla de información de la película
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilmInfo(
                              movie: widget.movies[selectedMovieIndex],
                              pop: false,
                              favorite: false,
                            ),
                          ),
                        );
                      }
                      return true;
                    },
                  ),
                ),
              ),
            ),
            // Botones en la parte inferior
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _cardSwiperController.swipe(CardSwiperDirection.left);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 133, 46, 26),
                          width: 3.5,
                        ),
                      ),
                      fixedSize: const Size(100, 50),
                    ),
                    child: const Icon(
                      Icons.thumb_down,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _cardSwiperController.swipe(CardSwiperDirection.right);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 18, 89, 21),
                          width: 3.5,
                        ),
                      ),
                      fixedSize: const Size(100, 50),
                    ),
                    child: const Icon(
                      Icons.thumb_up,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text(
          'No se encontraron películas.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Future<void> actualizaVector(
      String roomcode, int user, int valor, int index) async {
    // Cálculo del índice en 'matrix'
    int matrixIndex = user * 20 + index; // 20 películas por usuario

    // Actualizar Firestore con las películas
    final roomSnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('code', isEqualTo: roomcode)
        .get();

    if (roomSnapshot.docs.isEmpty) {
      throw Exception('No se encontró la sala.');
    }

    final roomDoc = roomSnapshot.docs.first;
    // Verifica el número de miembros
    List<dynamic> vector = roomDoc['matrix'] ?? [];
    vector[matrixIndex] =
        valor; // Actualiza el valor en el índice correspondiente
    print('Número de 0s en matrix: ${vector.length}');

    await roomDoc.reference.update({
      'matrix': vector,
    });
  }
}

class CardFilter extends StatelessWidget {
  final String title;
  final String image;
  final String overview;
  final String releaseDate;
  final double voteAverage;

  const CardFilter({
    super.key,
    required this.title,
    required this.image,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(2.5),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Image.network(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Error al cargar la imagen',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          },
        ),
      ),
      back: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(2.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título en la parte superior
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),

            // Overview de la película
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  overview,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Duración y puntuación en la parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Estreno: $releaseDate',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Puntuación: ${voteAverage.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
