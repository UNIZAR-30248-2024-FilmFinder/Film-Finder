class Movie {
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDay;
  String mediaType;
  double voteAverage;

  //DEFINIR QUE ES QUE Y AÑADIR NUEVO
  Movie({
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDay,
    required this.voteAverage,
    required this.mediaType, //Serie o película
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json["title"],
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDay: json["release_date"],
      voteAverage: json["vote_average"],
      mediaType: json["media_type"],
    );
  }
}
