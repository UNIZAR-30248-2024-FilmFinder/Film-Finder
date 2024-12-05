class Movie {
  int id;
  String title; // Título de la película
  String backDropPath; // Ruta del banner
  String overview; // Resumen
  String posterPath; // Ruta del póster
  String releaseDay; // Fecha de lanzamiento
  String mediaType; // Tipo: Serie o Película
  double voteAverage; // Promedio de votos
  String director; //Director de la película
  int duration; //Duración de la película
  List<String> genres; //Géneros de la película
  String trailerUrl; // Enlace del tráiler

  Movie({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDay,
    required this.voteAverage,
    required this.mediaType,
    required this.director,
    required this.duration,
    required this.genres,
    required this.trailerUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> detailsJson) {
    List<String> genresList = [];
    if (detailsJson['genres'] != null) {
      genresList = (detailsJson['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList();
    }

    return Movie(
      id: detailsJson["id"] ?? 0,
      title: detailsJson["title"] ?? 'Unknown Title',
      backDropPath: detailsJson["backdrop_path"] ?? '',
      overview: detailsJson["overview"] ?? 'No overview available',
      posterPath: detailsJson["poster_path"] ?? '',
      releaseDay: detailsJson["release_date"] ?? 'Unknown Release Date',
      voteAverage: detailsJson["vote_average"].toDouble() ?? 0,
      mediaType: detailsJson["media_type"] ?? 'Unknown Media Type',
      director: detailsJson["job"] ?? 'Unknown Director',
      duration: detailsJson["runtime"] ?? 0,
      genres: genresList,
      trailerUrl: '',
    );
  }
}

class MovieDiaryEntry {
  Movie movie;
  String viewingDate;
  int personalRating;
  String review;

  MovieDiaryEntry({
    required this.movie,
    required this.viewingDate,
    required this.personalRating,
    required this.review,
  });
}
