import 'package:film_finder/pages/filter_film_screen.dart';
import 'package:film_finder/widgets/swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main(){

  testWidgets('Should have the a Swiper an the right title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FilterFilmScreen(), // Reemplaza con tu widget swiper
      ),
    ));

    expect(find.text('ELIGE PELICULAS'),findsOneWidget);

    expect (find.byType(Swiper),findsOneWidget);

  });



}