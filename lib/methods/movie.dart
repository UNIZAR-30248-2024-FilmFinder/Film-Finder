class Movie {
  String title; // Título de la película
  String backDropPath; // Ruta del banner
  String overview; // Resumen
  String posterPath; // Ruta del póster
  String releaseDay; // Fecha de lanzamiento
  String mediaType; // Tipo: Serie o Película
  double voteAverage; // Promedio de votos

  Movie({
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDay,
    required this.voteAverage,
    required this.mediaType,
  });

  factory Movie.fromJson(Map<String, dynamic> detailsJson) {
    return Movie(
      title: detailsJson["title"] ?? 'Unknown Title',
      backDropPath: detailsJson["backdrop_path"] ?? '',
      overview: detailsJson["overview"] ?? 'No overview available',
      posterPath: detailsJson["poster_path"] ?? '',
      releaseDay: detailsJson["release_date"] ?? 'Unknown Release Date',
      voteAverage: detailsJson["vote_average"] ?? 0,
      mediaType: detailsJson["media_type"] ?? 'Unknown Media Type',
    );
  }
}
