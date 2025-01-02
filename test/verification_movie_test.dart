import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/methods/movie.dart'; // Asegúrate de usar la ruta correcta a tu archivo movie.dart

void main() {
  group('Movie class', () {
    test('Should create a Movie instance from JSON', () {
      // Arrange
      final Map<String, dynamic> movieJson = {
        "id": 123,
        "title": "Example Movie",
        "backdrop_path": "/example_backdrop.jpg",
        "overview": "This is an example movie overview.",
        "poster_path": "/example_poster.jpg",
        "release_date": "2024-12-01",
        "vote_average": 8.5,
        "media_type": "Movie",
        "job": "John Doe",
        "runtime": 120,
        "genres": [
          {"name": "Action"},
          {"name": "Drama"}
        ],
      };

      // Act
      final movie = Movie.fromJson(movieJson);

      // Assert
      expect(movie.id, 123);
      expect(movie.title, "Example Movie");
      expect(movie.backDropPath, "/example_backdrop.jpg");
      expect(movie.overview, "This is an example movie overview.");
      expect(movie.posterPath, "/example_poster.jpg");
      expect(movie.releaseDay, "2024-12-01");
      expect(movie.voteAverage, 8.5);
      expect(movie.mediaType, "Movie");
      expect(movie.director, "John Doe");
      expect(movie.duration, 120);
      expect(movie.genres, ["Action", "Drama"]);
    });

    test('Should create a Movie instance from Firebase JSON', () {
      // Arrange
      final Map<String, dynamic> firebaseJson = {
        "id": 456,
        "title": "Firebase Movie",
        "backDropPath": "/firebase_backdrop.jpg",
        "overview": "This is a Firebase movie overview.",
        "posterPath": "/firebase_poster.jpg",
        "releaseDay": "2025-01-01",
        "vote_average": 9.0,
        "mediaType": "Series",
        "director": "Jane Smith",
        "duration": 150,
        "genres": ["Comedy", "Thriller"],
        "trailerUrl": "https://example.com/trailer"
      };

      // Act
      final movie = Movie.fromFirebase(firebaseJson);

      // Assert
      expect(movie.id, 456);
      expect(movie.title, "Firebase Movie");
      expect(movie.backDropPath, "/firebase_backdrop.jpg");
      expect(movie.overview, "This is a Firebase movie overview.");
      expect(movie.posterPath, "/firebase_poster.jpg");
      expect(movie.releaseDay, "2025-01-01");
      expect(movie.voteAverage, 9.0);
      expect(movie.mediaType, "Series");
      expect(movie.director, "Jane Smith");
      expect(movie.duration, 150);
      expect(movie.genres, ["Comedy", "Thriller"]);
      expect(movie.trailerUrl, "https://example.com/trailer");
    });

    test('Should convert a Movie instance to JSON', () {
      // Arrange
      final movie = Movie(
        id: 789,
        title: "To JSON Movie",
        backDropPath: "/to_json_backdrop.jpg",
        overview: "This movie is converted to JSON.",
        posterPath: "/to_json_poster.jpg",
        releaseDay: "2026-06-01",
        voteAverage: 7.5,
        mediaType: "Movie",
        director: "Director JSON",
        duration: 90,
        genres: ["Horror", "Sci-Fi"],
        trailerUrl: "https://example.com/json_trailer",
      );

      // Act
      final movieJson = movie.toJson();

      // Assert
      expect(movieJson['id'], 789);
      expect(movieJson['title'], "To JSON Movie");
      expect(movieJson['backDropPath'], "/to_json_backdrop.jpg");
      expect(movieJson['overview'], "This movie is converted to JSON.");
      expect(movieJson['poster_path'], "/to_json_poster.jpg");
      expect(movieJson['release_date'], "2026-06-01");
      expect(movieJson['vote_average'], 7.5);
      expect(movieJson['director'], "Director JSON");
      expect(movieJson['duration'], 90);
      expect(movieJson['genres'], ["Horror", "Sci-Fi"]);
      expect(movieJson['trailerUrl'], "https://example.com/json_trailer");
    });
  });

  group('MovieDiaryEntry class', () {
    test('Should create a MovieDiaryEntry instance and verify properties', () {
      // Arrange
      final diaryEntry = MovieDiaryEntry(
        documentId: "doc123",
        movieId: 101,
        viewingDate: "2024-12-10",
        personalRating: 4.5,
        review: "Great movie!",
      );

      // Assert
      expect(diaryEntry.documentId, "doc123");
      expect(diaryEntry.movieId, 101);
      expect(diaryEntry.viewingDate, "2024-12-10");
      expect(diaryEntry.personalRating, 4.5);
      expect(diaryEntry.review, "Great movie!");
    });
  });
}