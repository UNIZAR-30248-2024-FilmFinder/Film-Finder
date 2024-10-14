import 'package:film_finder/widgets/movie_slider.dart';
import 'package:film_finder/widgets/trending_slider.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
        elevation: 0,
        centerTitle: true,
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
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tendencias', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: Colors.white
                ),
              ),
              SizedBox(height: 20),
              TrendingSlider(),
              SizedBox(height: 30),
              Text('Mejor Valoradas', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: Colors.white),
              ),
              SizedBox(height: 20),
              MovieSlider(),
              SizedBox(height: 30),
              Text('Próximos Estrenos', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: Colors.white),
              ),
              SizedBox(height: 20),
              MovieSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

