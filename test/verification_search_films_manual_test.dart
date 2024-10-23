import 'dart:convert';
import 'package:film_finder/widgets/search_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/methods/movie.dart';

void main() {
  group('Movie Information Verification', () {
    test(
        'Verificar que la búsqueda devuelve los datos correctos comparando con movieOriginal',
        () async {
      final searchBar =
          SearchingBar(onSearchToggled: (bool isActive) {}).createState();

      // Crear una lista de películas originales
      final List<Movie> originalMovies = [
        Movie(
            id: 550,
            title: "El club de la lucha",
            posterPath: "/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg",
            voteAverage: 8.4,
            mediaType: "movie",
            backDropPath: '',
            overview: '',
            releaseDay: '',
            director: '',
            duration: 0,
            genres: [],
            trailerUrl: ''),
        Movie(
            id: 1159565,
            title: "Tiburón blanco: el club de la lucha",
            posterPath: "/4gbp125YYBOTfNAGP7K81vFW792.jpg",
            voteAverage: 8.3,
            mediaType: "movie",
            backDropPath: '',
            overview: '',
            releaseDay: '',
            director: '',
            duration: 0,
            genres: [],
            trailerUrl: ''),
        Movie(
            id: 814776,
            title: "El club de las luchadoras",
            posterPath: "/zAPPIeqB4cjXiS5qPFgeifndunG.jpg",
            voteAverage: 6.7,
            mediaType: "movie",
            backDropPath: '',
            overview: '',
            releaseDay: '',
            director: '',
            duration: 0,
            genres: [],
            trailerUrl: ''),
        // Agregar más películas originales según sea necesario
      ];

      // Ejecutar la búsqueda
      await searchBar.searchListFunction('El club de la lucha');

      // Comprobar que no se devuelven más de 15 resultados
      expect(searchBar.movies.length, lessThanOrEqualTo(15));

      // Iterar sobre las películas encontradas
      for (int i = 0; i < searchBar.movies.length; i++) {
        Movie foundMovie = searchBar.movies[i];
        // Comparar los datos de la película encontrada con los datos originales
        expect(foundMovie.id, originalMovies[i].id);
        expect(foundMovie.title, originalMovies[i].title);
        expect(foundMovie.posterPath, originalMovies[i].posterPath);
        const double tolerance =
            0.1; // Ajusta la tolerancia según sea necesario
        expect((foundMovie.voteAverage - originalMovies[i].voteAverage).abs(),
            lessThanOrEqualTo(tolerance));
        expect(foundMovie.mediaType, originalMovies[i].mediaType);
      }
    });
  });
}
