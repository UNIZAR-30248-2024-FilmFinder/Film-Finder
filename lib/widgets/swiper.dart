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
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isNotEmpty) {
      return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          height: MediaQuery.of(context).size.height * 0.68,
          child: CardSwiper(
            cardsCount: min(20, widget.movies.length),
            cardBuilder: (context, index, x, y) {
              String posterUrl = 'https://image.tmdb.org/t/p/original${widget.movies[index].posterPath}';
              return CardFilter(
                image: posterUrl,
                title: widget.movies[index].title,
                overview: widget.movies[index].overview,
                releaseDate: widget.movies[index].releaseDay,
                voteAverage: widget.movies[index].voteAverage,
              );
            },
            allowedSwipeDirection: const AllowedSwipeDirection.only(left: true, right: true),
            numberOfCardsDisplayed: 4,
            backCardOffset: const Offset(0, 0),
            onSwipe: (previous, current, direction) {
              currentindex = current!;
              if (direction == CardSwiperDirection.right) {
                Fluttertoast.showToast(msg: 'Te ha gustado', backgroundColor: Colors.black, fontSize: 28);
                Future.delayed(const Duration(milliseconds: 750), () {Fluttertoast.cancel();});
                Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => FilmInfo(
                  movie: widget.movies[previous],
                  ),
                ),
              );
              } else if (direction == CardSwiperDirection.left) {
                Fluttertoast.showToast(msg: 'No te ha gustado', backgroundColor: Colors.black, fontSize: 28);
                Future.delayed(const Duration(milliseconds: 750), () {Fluttertoast.cancel();});
              }
              return true;
            },
          ),
        ),
      ),
    );
    }
    else{
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

  CardFilter({
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
        child: Center(
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
      ),
      back: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          border: Border.all(
            color: Colors.white,
            width: 1.25,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta la altura del back a su contenido
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
