import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:film_finder/methods/movie.dart';
import 'dart:math';

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
    // Verificar si hay películas en la lista
    if (widget.movies.isNotEmpty) {
      return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height * 0.5,
          child: CardSwiper(
            cardsCount: min(20, widget.movies.length),
            cardBuilder: (context, index, x, y) {
              String posterUrl = 'https://image.tmdb.org/t/p/original${widget.movies[index].posterPath}';
              return CardFilter(
                image: posterUrl,
                text: widget.movies[index].title,
              );
            },
            allowedSwipeDirection: const AllowedSwipeDirection.only(left: true, right: true),
            numberOfCardsDisplayed: 4,
            isLoop: true,
            backCardOffset: const Offset(0, 0),
            onSwipe: (previous, current, direction) {
              currentindex = current!;
              if (direction == CardSwiperDirection.right) {
                Fluttertoast.showToast(msg: 'Te ha gustado', backgroundColor: Colors.black, fontSize: 28);
                Future.delayed(const Duration(milliseconds: 750), () {Fluttertoast.cancel();});
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
  final String text;
  final String image;

  CardFilter({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 133, 46, 26),
          border: Border.all(
            color: Colors.white,
            width: 1.25,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Image.network(
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
          ),
        ),
      ),
      back: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 133, 46, 26),
          border: Border.all(
            color: Colors.white,
            width: 1.25,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
