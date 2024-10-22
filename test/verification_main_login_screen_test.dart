import 'package:film_finder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/login_screen.dart';
import 'package:film_finder/pages/principal_screen.dart';

void main() {

  testWidgets('Test de inicio de la aplicación MyApp', (WidgetTester tester) async {
    // Cargar la aplicación
    await tester.pumpWidget(const MyApp());

    // Verificar que la aplicación se está ejecutando y el título es correcto
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verificar que se muestra el widget de redirección
    expect(find.byType(RedirectPage), findsOneWidget);

    // Permitir que se complete el retraso de la redirección
    await tester.pumpAndSettle();

    // Verificar que la pantalla de inicio de sesión se muestra después de la redirección
    expect(find.byType(LogIn), findsOneWidget);
  });

  testWidgets('Test básico de la pantalla de LogIn', (WidgetTester tester) async {
    // Cargar la pantalla de LogIn
    await tester.pumpWidget(
      const MaterialApp(
        home: LogIn(),
      ),
    );

    // Verificar que el texto "FilmFinder" está presente
    expect(find.text('FilmFinder'), findsOneWidget);

    // Verificar que el color del texto "FilmFinder" es el esperado (deepPurple)
    final textFinder = find.text('FilmFinder');
    final Text textWidget = tester.widget(textFinder);
    expect((textWidget.style?.color), equals(Colors.deepPurple));

    // Verificar que el botón "Iniciar sesión" está presente
    expect(find.text('Iniciar sesión'), findsOneWidget);

    // Verificar que el botón tiene el estilo correcto (tamaño de fuente y peso)
    final buttonFinder = find.text('Iniciar sesión');

    // Verificar que al pulsar el botón, navega a la pantalla principal
    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    // Verificar que se ha navegado a la pantalla PrincipalScreen
    expect(find.byType(PrincipalScreen), findsOneWidget);
  });
}
