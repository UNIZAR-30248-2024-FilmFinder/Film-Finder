import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/widgets/profile_widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:film_finder/pages/auth_pages/login_screen.dart'; // Importa tu pantalla de login

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Test de integración de la pantalla de edición de información del perfil de usuario',
      (WidgetTester tester) async {
    // Inicializa la aplicación en la pantalla de inicio de sesión
    await tester.pumpWidget(MaterialApp(
      home: LogIn(),
    ));

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Simula un tap en el botón de "INICIAR SESIÓN"
    await tester.tap(find.text('INICIAR SESIÓN'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const MaterialApp(
      home: ProfileScreen(),
    ));

    // Verificar que el texto "Peliculas" está presente
    expect(find.text('Peliculas'), findsOneWidget);
    // Verificar que el texto "Sobre mi:" está presente
    expect(find.text('Sobre mi:'), findsOneWidget);

    await tester.tap(find.byType(ProfileWidget));
    await tester.pumpAndSettle();

    expect(find.text('Cambiar contraseña'), findsOneWidget);
    expect(find.text('Borrar cuenta'), findsOneWidget);

    expect(
        find.byType(TextField),
        findsNWidgets(
            3)); // Asume que hay cuatro campos de texto (user, location y description)
    await tester.enterText(find.byType(TextField).at(0), 'NewNameTest');
    await tester.enterText(find.byType(TextField).at(1), 'NewLocationTest');
    await tester.enterText(find.byType(TextField).at(2), 'NewDescrptionTest');
    expect(find.byType(ElevatedButton), findsAtLeast(3));

    await tester.tap(find.text('CONFIRMAR'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(MaterialApp(
      home: ProfileScreen(),
    ));

    expect(find.textContaining('NewNameTest'), findsOneWidget);
    expect(find.textContaining('NewLocationTest'), findsOneWidget);
    expect(find.textContaining('NewDescrptionTest'), findsOneWidget);
  });
}
