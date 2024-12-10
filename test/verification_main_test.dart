import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:film_finder/main.dart';
import 'package:film_finder/pages/auth_pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Film Finder Tests', () {

    testWidgets('App redirects to AuthPage on startup', (WidgetTester tester) async {
      // Renderizar la app principal.
      await tester.pumpWidget(const MyApp());

      // Esperar a que los widgets se actualicen.
      await tester.pumpAndSettle();

      // Verificar que `AuthPage` se muestra.
      expect(find.byType(AuthPage), findsOneWidget);
    });

    testWidgets('Firestore integration: adding and retrieving data',
        (WidgetTester tester) async {
      // Simular una instancia de Firestore.
      final firestore = FakeFirebaseFirestore();

      // Agregar datos simulados a Firestore.
      await firestore.collection('users').add({
        'name': 'User1',
        'email': 'user1@example.com',
      });

      // Verificar que los datos están en Firestore.
      final snapshot =
          await firestore.collection('users').where('name', isEqualTo: 'John Doe').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs.first['email'], 'user1@example.com');
    });
  });
}
