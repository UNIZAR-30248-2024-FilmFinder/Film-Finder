import 'package:film_finder/pages/principal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:film_finder/methods/movie.dart';
import 'dart:math';
import 'package:film_finder/pages/film_screen.dart';

class Swiper extends StatefulWidget {
  final List<Movie> movies;

  const Swiper({
    super.key,
    required this.movies,
  });

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
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
                    onSwipe: (previous, current, direction) {
                      currentindex++;

                      // Verifica si es el último elemento
                      if (currentindex >= widget.movies.length) {
                        // Mostrar el pop-up indicando que se llegó al final
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Fin de la lista',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Has llegado al final de la lista de películas.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            190, 49, 68, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PrincipalScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Volver al inicio',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }

                      // Manejo de dirección del swipe
                      if (direction == CardSwiperDirection.right) {
                        Fluttertoast.showToast(
                            msg: 'Te ha gustado',
                            backgroundColor: Colors.black,
                            fontSize: 28);
                        Future.delayed(const Duration(milliseconds: 750), () {
                          Fluttertoast.cancel();
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilmInfo(
                              movie: widget.movies[previous],
                            ),
                          ),
                        );
                      } else if (direction == CardSwiperDirection.left) {
                        Fluttertoast.showToast(
                            msg: 'No te ha gustado',
                            backgroundColor: Colors.black,
                            fontSize: 28);
                        Future.delayed(const Duration(milliseconds: 750), () {
                          Fluttertoast.cancel();
                        });
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
                      Fluttertoast.showToast(
                          msg: 'No te ha gustado',
                          backgroundColor: Colors.black,
                          fontSize: 28);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 133, 46, 26),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(
                          color: Colors.red,
                          width: 1.0,
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
                      Fluttertoast.showToast(
                        msg: 'Te ha gustado',
                        backgroundColor: Colors.black,
                        fontSize: 28,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 18, 89, 21),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(
                          color: Colors.green,
                          width: 1.0,
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
