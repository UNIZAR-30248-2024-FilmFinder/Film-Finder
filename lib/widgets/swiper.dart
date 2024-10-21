import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flip_card/flip_card.dart';
import 'package:film_finder/methods/movie.dart';

class Swiper extends StatefulWidget {
  const Swiper({super.key});

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  int currentindex = 0;

  List images = [
    'assets/genres_icons/accion.png', 'assets/genres_icons/animacion.png',
    'assets/genres_icons/aventura.png', 'assets/genres_icons/comedia.png',
    'assets/genres_icons/crimen.png', 'assets/genres_icons/documental.png',
    'assets/genres_icons/drama.png', 'assets/genres_icons/familia.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: MediaQuery.of(context).size.height * 0.5,
          child: CardSwiper(
            cardsCount: images.length,
            cardBuilder: (context, index, x, y) {
              return CardFilter(
                image: images[index],
                text: 'Imagen eliminada',
              );
            },
            allowedSwipeDirection: const AllowedSwipeDirection.only(left: true, right: true),
            numberOfCardsDisplayed: 2,
            isLoop: true,
            backCardOffset: const Offset(0, 0),
            onSwipe: (previous, current, direction) {
              currentindex = current!;
              if (direction == CardSwiperDirection.right) {
                Fluttertoast.showToast(msg: 'Te ha gustado', backgroundColor: Colors.black, fontSize: 28);
                Future.delayed(const Duration(seconds: 1), () {Fluttertoast.cancel();});
              } else if (direction == CardSwiperDirection.left) {
                Fluttertoast.showToast(msg: 'No te ha gustado', backgroundColor: Colors.black, fontSize: 28);
                Future.delayed(const Duration(seconds: 1), () {Fluttertoast.cancel();});
              }
              return true;
            },
          ),
        ),
      ),
    );
  }
}

class CardFilter extends StatelessWidget {
  final String text;
  final String image;

  const CardFilter({
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
          child: Image.asset(
            image,
            fit: BoxFit.contain,
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
        child: const Center(
          child: Text(
            'Imagen eliminada',
            style: TextStyle(
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
