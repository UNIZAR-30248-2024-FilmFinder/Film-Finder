import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/pages/auth_pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test de integración de la pantalla de Registro',
      (WidgetTester tester) async {
    // Inicializa la aplicación en la pantalla de inicio de sesión
    await tester.pumpWidget(MaterialApp(
      home: Register(),
    ));

    // Verifica que los elementos de la pantalla de login estén presentes
    expect(find.text('CREAR UNA CUENTA'), findsOneWidget);
    expect(
        find.byType(TextField),
        findsNWidgets(
            4)); // Asume que hay cuatro campos de texto (user, email y dos password)
    expect(find.textContaining('¿Ya tienes cuenta?'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Introduce texto en los campos correspodnientes
    await tester.enterText(find.byType(TextField).at(0), 'test12345');
    await tester.enterText(
        find.byType(TextField).at(1), 'test12345@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.enterText(find.byType(TextField).at(3), 'password123');

    // Simula un tap en el botón de "Registrarse"
    await tester.tap(find.text('Registrase'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const MaterialApp(
      home: ProfileScreen(),
    ));

    expect(find.textContaining('test12345'), findsOneWidget);
    //expect(find.text('Bienvenido'), findsOneWidget);
  });
}
