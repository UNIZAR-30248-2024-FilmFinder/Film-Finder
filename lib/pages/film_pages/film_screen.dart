import 'package:film_finder/pages/film_pages/add_film_diary_screen.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/methods/movie.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class FilmInfo extends StatefulWidget {
  final Movie movie;

  final bool pop;

  const FilmInfo({super.key, required this.movie, required this.pop});

  @override
  // ignore: library_private_types_in_public_api
  _FilmInfoState createState() => _FilmInfoState();
}

class _FilmInfoState extends State<FilmInfo> {
  late bool isFavourite = false;

  void _launchURL() async {
    final Uri url = Uri.parse(widget.movie.trailerUrl);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar.large(
                leading: IconButton(
                  onPressed: () {
                    if (widget.pop == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrincipalScreen(),
                        ),
                      );
                    } else if (widget.pop == true) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                expandedHeight: 275,
                pinned: true,
                floating: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      title: top < 100
                          ? Stack(
                              children: [
                                Text(
                                  widget.movie.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  widget.movie.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : null,
                      background: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original${widget.movie.backDropPath}',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      SizedBox(
                        child: Row(
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/original${widget.movie.posterPath}',
                              filterQuality: FilterQuality.high,
                              height: 165,
                              width: 165,
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Text(
                                        widget.movie.title,
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 3
                                            ..color = Colors.black,
                                        ),
                                      ),
                                      Text(
                                        widget.movie.title,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Géneros: ',
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.movie.genres.join(', '),
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Duración: ',
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${widget.movie.duration} min',
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Text(
                                        'Director: ',
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.movie.director,
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: widget.movie.trailerUrl.isNotEmpty &&
                                            widget.movie.trailerUrl != ''
                                        ? _launchURL
                                        : null,
                                    child: Visibility(
                                      visible:
                                          widget.movie.trailerUrl.isNotEmpty &&
                                              widget.movie.trailerUrl != '',
                                      child: const Text(
                                        'VER TRAILER',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Fecha de estreno: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.movie.releaseDay,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Puntuación: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.movie.voteAverage.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        widget.movie.overview,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiaryFilm(
                                  movieId: widget.movie.id,
                                  posterPath: widget.movie.posterPath,
                                  title: widget.movie.title,
                                  releaseDay: widget.movie.releaseDay,
                                  isEditing: false,
                                  editDate: "",
                                  editRating: 0,
                                  editReview: "",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 25),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: const BorderSide(
                                color: Color.fromRGBO(190, 49, 68, 1),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Añadir película al diario",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: const BorderSide(
                    color: Color.fromRGBO(190, 49, 68, 1),
                    width: 1.0,
                  ),
                ),
                fixedSize: const Size(60, 60),
              ),
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: isFavourite
                    ? const Color.fromRGBO(190, 49, 68, 1)
                    : const Color.fromRGBO(190, 49, 68, 1),
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
