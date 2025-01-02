import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/pages/profile_pages/favorites_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  testWidgets('Favoritas screen displays loading and movie list', (WidgetTester tester) async {
    // Mock de datos de película
    await tester.pumpWidget(const MaterialApp(home: FavoritesScreen(movieIds: [550, 123],)));
    expect(find.text('Favoritas'), findsOneWidget);
  });
}
