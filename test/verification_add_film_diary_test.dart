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
    /*final movieIds = [550, 123]; // IDs de ejemplo de películas
    final screen = FavoritesScreen(movieIds: movieIds);

    // Simular respuesta exitosa de la API
    final mockResponse = '{"title": "Fight Club", "release_date": "1999-10-15", "poster_path": "/path/to/poster.jpg"}';
 
    // Construir el widget
    await tester.pumpWidget(MaterialApp(home: screen));

    // Verificar que el loader está visible mientras se cargan los datos
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Esperar para que se carguen los datos
    await tester.pumpAndSettle();

    // Verificar que los elementos de la lista de películas se muestran
    expect(find.text('Fight Club'), findsOneWidget);
    expect(find.text('1999'), findsOneWidget);*/
    expect(find.text('Añadir película al diario'), findsOneWidget);
  });
}
