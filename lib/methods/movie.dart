class Movie {
  String title; //titulo de la pelicula
  String backDropPath; //Banner de la pelicula
  String overview;
  String posterPath;
  String releaseDay;
  String mediaType; //Serie o película
  double voteAverage;

  //DEFINIR QUE ES QUE Y AÑADIR NUEVO
  Movie({
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.releaseDay,
    required this.voteAverage,
    required this.mediaType,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      backDropPath: json["backdrop_path"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDay: json["release_date"],
      voteAverage: json["vote_average"],
      mediaType: json["media_type"],
    );
  }
}
