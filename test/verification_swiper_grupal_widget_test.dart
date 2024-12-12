import 'package:film_finder/methods/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/widgets/film_widgets/swiper_grupal.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Mock FirebaseFirestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SwiperGrupal Tests', () {
    late MockFirebaseFirestore mockFirebase;

    setUp(() {
      mockFirebase = MockFirebaseFirestore();
    });

    testWidgets('Displays a list of movies and swipes left or right', (tester) async {
      // Test data
      final movieList = [
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
            trailerUrl: ''
        ),
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
      ];

      // Mock data for Firebase
      final roomData = {
        'matrix': [0, 0], // Placeholder for movie matrix
        'members': ['user1', 'user2'],
        'code': 'room123',
      };


      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: SwiperGrupal(
            movies: movieList,
            user: 0,
            roomCode: 'room123',
          ),
        ),
      );

      // Verify that the movies are displayed
      expect(find.text('Movie 1'), findsOneWidget);
      expect(find.text('Movie 2'), findsOneWidget);

      // Simulate a swipe right action
      await tester.tap(find.byIcon(Icons.thumb_up));
      await tester.pump();

      // Verify that the toast message for "Te ha gustado" is shown
      expect(find.text('Te ha gustado'), findsOneWidget);

      // Simulate a swipe left action
      await tester.tap(find.byIcon(Icons.thumb_down));
      await tester.pump();

      // Verify that the toast message for "No te ha gustado" is shown
      expect(find.text('No te ha gustado'), findsOneWidget);
    });
  });
}
