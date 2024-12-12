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
            const Divider(
              color: Color.fromRGBO(190, 49, 68, 1),
              thickness: 1,
              endIndent: 50,
              indent: 50,
            ),
            Expanded(
              child: SwiperGrupal(
                movies: widget.movies,
                user: widget.user,
                roomCode: widget.roomCode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
