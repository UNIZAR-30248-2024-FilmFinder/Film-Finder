import 'package:flutter/material.dart';
import 'package:film_finder/widgets/swiper.dart';

class FilterFilmScreen extends StatefulWidget {
  const FilterFilmScreen({super.key});

  @override
  State<FilterFilmScreen> createState() => _FilterFilmScreenState();
}

class _FilterFilmScreenState extends State<FilterFilmScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'EXPLORAR',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor:  const Color.fromRGBO(34, 9, 44, 1),
      body: const SafeArea(
        child: Swiper(),
      ),
    );
  }
}