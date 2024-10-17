import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flip_card/flip_card.dart';

class CardFilter extends StatelessWidget {
  final String text;
  final String image;

  const CardFilter({
    super.key,
    required this.text,
    required this.image,
  });

  Widget frontCard(BuildContext context) {
    return Container(
      width: 160,
      height: 240,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 133, 46, 26),
        border: Border.all(
          color: Colors.white,
          width: 1.25,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(image),
            width: 90,
            height: 90,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget backCard(BuildContext context) {
    return Container(
      width: 160,
      height: 240,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 18, 89, 21),
        border: Border.all(
          color: Colors.white,
          width: 1.25,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(image),
            width: 90,
            height: 90,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      front: frontCard(context),
      back: backCard(context),
    );
  }
}
