import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/profile_screen.dart';

void main() {
  testWidgets('Test básico de la pantalla de ProfileScreen', (WidgetTester tester) async {
    // Cargar la pantalla de ProfileScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    // Verificar que el nombre del usuario está presente
    expect(find.text('Jorge'), findsOneWidget);

    // Verificar que la ubicación del usuario está presente
    expect(find.text('España, Zaragoza'), findsOneWidget);

    // Verificar que el email del usuario está presente
    expect(find.text('845647@unizar.es'), findsOneWidget);

    // Verificar que el color de fondo es el esperado
    final Scaffold scaffold = tester.widget(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color.fromRGBO(34, 9, 44, 1));

    // Verificar que el texto "Peliculas" está presente
    expect(find.text('Peliculas'), findsOneWidget);

    // Verificar que el texto "Sobre mi:" está presente
    expect(find.text('Sobre mi:'), findsOneWidget);


  });
}
