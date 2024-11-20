import 'package:film_finder/pages/film_pages/filter_film_screen.dart';
import 'package:film_finder/widgets/film_widgets/swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Should have the a Swiper an the right title',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FilterFilmScreen(
          movies: [],
        ), // Reemplaza con tu widget swiper
      ),
    ));

    expect(find.text('ELIGE UNA PELICULA'), findsOneWidget);

    expect(find.byType(Swiper), findsOneWidget);
  });
}
