import 'package:film_finder/widgets/film_widgets/movie_slider.dart';
import 'package:film_finder/widgets/film_widgets/trending_slider.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/methods/api.dart';
import 'package:film_finder/methods/movie.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<List<Movie>>> allMovies;

  @override
  void initState() {
    super.initState();
    allMovies = Future.wait([
      Api().getTrendingMovies(),
      Api().getTopRatedMovies(),
      Api().getUpcomingMovies(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la altura de la barra de estado
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: FutureBuilder<List<List<Movie>>>(
        future: allMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (snapshot.hasData) {
            final trendingMovies = snapshot.data![0];
            final topRatedMovies = snapshot.data![1];
            final upcomingMovies = snapshot.data![2];

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: statusBarHeight + 17),
                    Center(
                      child: Image.asset(
                        'assets/images/titulo.png',
                        width: 325,
                        height: 75,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tendencias',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Divider(
                      color: Color.fromRGBO(190, 49, 68, 1),
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    TrendingSlider(movies: trendingMovies),
                    const SizedBox(height: 30),
                    const Text(
                      'Mejor Valoradas',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Divider(
                      color: Color.fromRGBO(190, 49, 68, 1),
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    MovieSlider(movies: topRatedMovies),
                    const SizedBox(height: 30),
                    const Text(
                      'Próximos Estrenos',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Divider(
                      color: Color.fromRGBO(190, 49, 68, 1),
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    MovieSlider(movies: upcomingMovies),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No se encontraron datos',
                  style: TextStyle(color: Colors.white)),
            );
          }
        },
      ),
    );
  }
}
