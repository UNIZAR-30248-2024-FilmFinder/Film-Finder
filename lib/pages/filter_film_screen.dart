import 'package:flutter/material.dart';
import 'package:film_finder/widgets/swiper.dart';
import 'package:film_finder/methods/movie.dart';

class FilterFilmScreen extends StatefulWidget {
  final List<Movie> movies;

  const FilterFilmScreen({
    super.key,
    required this.movies,
  });

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
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 35),
              child: Text(
                'ELIGE UNA PELICULA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Swiper(
                movies: widget.movies,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
