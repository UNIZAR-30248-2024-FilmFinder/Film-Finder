import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:film_finder/widgets/film_widgets/swiper.dart';
import 'package:film_finder/methods/movie.dart';

void main() {
  group('Swiper Widget Tests', () {
    final movies = List<Movie>.generate(
      5,
      (index) => Movie(
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
    );

    testWidgets('Renders Swiper with movies', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Swiper(movies: movies),
        ),
      );

      expect(find.byType(CardSwiper), findsOneWidget);
      expect(find.text('Movie 0'), findsOneWidget); // Verifica la primera película
    });

    testWidgets('Displays "No se encontraron películas" when list is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Swiper(movies: []),
        ),
      );

      expect(find.text('No se encontraron películas.'), findsOneWidget);
    });

    testWidgets('Navigates to FilmInfo when swiping right',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Swiper(movies: movies),
        ),
      );

      // Swipe the first card to the right
      final cardSwiper = find.byType(CardSwiper);
      await tester.drag(cardSwiper, const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text('Te ha gustado'), findsOneWidget); // Verifica el toast
      // Aquí agregarías validación para la navegación, si es aplicable
    });

    testWidgets('Shows end dialog when all movies are swiped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Swiper(movies: movies),
        ),
      );

      final cardSwiper = find.byType(CardSwiper);

      // Simula swipes hasta el final de la lista
      for (int i = 0; i < movies.length; i++) {
        await tester.drag(cardSwiper, const Offset(-300, 0)); // Swipe left
        await tester.pumpAndSettle();
      }

      expect(find.text('¡Ya no quedan más películas!'), findsOneWidget);
    });
  });
}
