import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:film_finder/pages/login_screen.dart'; // Importa tu pantalla de login
import 'package:film_finder/main.dart'; // Importa la app principal si es necesario

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test de integración de la pantalla de Login', (WidgetTester tester) async {
    // Inicializa la aplicación en la pantalla de inicio de sesión
    await tester.pumpWidget(MaterialApp(
      home: LogIn(),
    ));

    // Verifica que los elementos de la pantalla de login estén presentes
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Asume que hay dos campos de texto (email y password)
    expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Introduce texto en los campos de email y contraseña
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Simula un tap en el botón de "INICIAR SESIÓN"
    await tester.tap(find.text('INICIAR SESIÓN'));
    await tester.pumpAndSettle();

    expect(find.textContaining('ELIGE QUE VER'), findsOneWidget);
  });
}
