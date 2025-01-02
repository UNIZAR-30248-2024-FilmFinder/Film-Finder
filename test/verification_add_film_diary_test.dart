import 'package:film_finder/pages/film_pages/add_film_diary_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/pages/profile_pages/favorites_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  testWidgets('Favoritas screen displays loading and movie list', (WidgetTester tester) async {
    // Mock de datos de película
    await tester.pumpWidget(const MaterialApp(home: DiaryFilm(
            title: "El club de la lucha",
            posterPath: "/sgTAWJFaB2kBvdQxRGabYFiQqEK.jpg",
            releaseDay: '', movieId: 550, isEditing: false, 
            editDate: '', editRating: 8.4, editReview: '', 
            documentId: '',)));
    expect(find.text('Añadir película al diario'), findsOneWidget);
  });
}
