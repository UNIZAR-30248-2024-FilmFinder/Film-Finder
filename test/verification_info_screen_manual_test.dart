import 'package:film_finder/widgets/search_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/methods/movie.dart'; // Importamos la clase Movie

void main() {

  group('Movie Information Verification', () {

    test('Verificar que la búsqueda devuelve los datos correctos comparando con movieOriginal', () async {
      final searchBar = SearchingBar().createState();

      // Crear una variable movieOriginal con todos los datos manualmente
      Movie movieOriginal = Movie(
        id: 550,
        title: 'El club de la lucha',
        posterPath: '/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg',
        releaseDay: '1999-10-15',
        voteAverage: 8.439,
        mediaType: 'movie',
        director: 'David Fincher',  // Director conocido para esta película
        duration: 139,              // Duración conocida
        genres: ['Drama'],          // Género conocido
        overview: 'Un joven sin ilusiones lucha contra su insomnio, '
            'consecuencia quizás de su hastío por su gris y rutinaria vida. En un viaje '
            'en avión conoce a Tyler Durden, un carismático vendedor de jabón que sostiene '
            'una filosofía muy particular: el perfeccionismo es cosa de gentes débiles; en cambio, '
            'la autodestrucción es lo único que hace que realmente la vida merezca la pena. Ambos '
            'deciden entonces formar un club secreto de lucha donde descargar sus frustaciones y su '
            'ira que tendrá un éxito arrollador.',  // Descripción conocida
        backDropPath: '/hZkgoQYus5vegHoetLkCJzb17zJ.jpg',  // Backdrop conocido
        trailerUrl: ''// Esto podría actualizarse después
      );

      // Ejecutar la búsqueda
      await searchBar.searchListFunction('El club de la lucha');

      // Comprobar que no se devuelven más de 15 resultados
      expect(searchBar.movies.length, lessThanOrEqualTo(15));

      // Asumimos que la primera película es la que estamos buscando
      Movie foundMovie = searchBar.movies[0];

      // Comparar los datos de la película encontrada con los datos originales
      expect(foundMovie.id, movieOriginal.id);
      expect(foundMovie.title, movieOriginal.title);
      expect(foundMovie.posterPath, movieOriginal.posterPath);
      expect(foundMovie.releaseDay, movieOriginal.releaseDay);
      const double tolerance = 0.1; // Ajusta la tolerancia según sea necesario
      expect((foundMovie.voteAverage - movieOriginal.voteAverage).abs(), lessThanOrEqualTo(tolerance));
      expect(foundMovie.mediaType, movieOriginal.mediaType);

      // Ahora simulamos obtener los detalles adicionales de la película
      await searchBar.onTapMovie(foundMovie);

      // Comparar los detalles actualizados con los datos originales
      expect(foundMovie.director, movieOriginal.director);
      expect(foundMovie.duration, movieOriginal.duration);
      expect(foundMovie.genres, movieOriginal.genres);
      expect(foundMovie.overview, movieOriginal.overview);
      expect(foundMovie.backDropPath, movieOriginal.backDropPath);
    });
  });
}
