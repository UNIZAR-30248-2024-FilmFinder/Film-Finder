import 'package:flutter/material.dart';
import 'package:film_finder/widgets/film_widgets/swiper_grupal.dart';
import 'package:film_finder/methods/movie.dart';

class FilterGrupalScreen extends StatefulWidget {
  final List<Movie> movies;
  final int user;
  final String roomCode;

  const FilterGrupalScreen({
    super.key,
    required this.movies,
    required this.user,
    required this.roomCode,
  });

  @override
  State<FilterGrupalScreen> createState() => _FilterGrupalScreenState();
}

class _FilterGrupalScreenState extends State<FilterGrupalScreen> {
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
          'ELIGE PELICULAS GRUPAL',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: SafeArea(
        child: SwiperGrupal(
          movies: widget.movies,
          user: widget.user,
          roomCode: widget.roomCode,
        ),

      ),
    );
  }
}
