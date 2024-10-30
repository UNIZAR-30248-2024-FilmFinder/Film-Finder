import 'package:film_finder/widgets/movie_slider.dart';
import 'package:film_finder/widgets/trending_slider.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/methods/api.dart';
import 'package:film_finder/methods/movie.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>{
  late Future<List<Movie>> trendingmovies;
  late Future<List<Movie>> topratedmovies;
  late Future<List<Movie>> upcomingmovies;
  bool moviesLoaded = false;

  @override
  void initState(){
    super.initState();
    if (!moviesLoaded) {
      trendingmovies = Api().getTrendingMovies();
      topratedmovies = Api().getTopRatedMovies();
      upcomingmovies = Api().getUpcomingMovies();
      moviesLoaded = true;
    }
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
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tendencias',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: FutureBuilder(
                  future: trendingmovies,
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }else if(snapshot.hasData){
                      return TrendingSlider(snapshot: snapshot);
                    }else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Mejor Valoradas',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: FutureBuilder(
                  future: topratedmovies,
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }else if(snapshot.hasData){
                      return MovieSlider(snapshot: snapshot,);
                    }else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Próximos Estrenos',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: FutureBuilder(
                  future: upcomingmovies,
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }else if(snapshot.hasData){
                      return MovieSlider(snapshot: snapshot);
                    }else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
