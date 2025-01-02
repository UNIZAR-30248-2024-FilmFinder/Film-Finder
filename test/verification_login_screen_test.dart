import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/auth_pages/login_screen.dart';

void main() {
  group('LogIn Widget Tests', () {
    testWidgets('Renderiza los campos de texto y botones correctamente', (WidgetTester tester) async {
      // Cargar el widget LogIn
      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(),
        ),
      );

      // Verificar si el título está presente
      expect(find.text('INICIAR SESIÓN'), findsOneWidget);

      // Verificar la presencia de campos de texto
      expect(find.byType(TextField), findsNWidgets(2));

      // Verificar la presencia del botón de iniciar sesión
      expect(find.text('Iniciar sesión'), findsOneWidget);

      // Verificar la presencia del botón de Google
      expect(find.text('Continuar con Google'), findsOneWidget);
    });

    testWidgets('Muestra un SnackBar si los campos están vacíos', (WidgetTester tester) async {
      // Cargar el widget LogIn
      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(),
        ),
      );

      // Tocar el botón de iniciar sesión sin rellenar los campos
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump(); // Actualiza la UI para mostrar el SnackBar

      // Verificar si se muestra el mensaje de error
      expect(find.text('Por favor, rellena todos los campos'), findsOneWidget);
    });

    testWidgets('Muestra el diálogo de carga al iniciar sesión', (WidgetTester tester) async {
      // Cargar el widget LogIn
      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(),
        ),
      );

      // Rellenar los campos de texto
      await tester.enterText(
          find.byType(TextField).at(0), 'test@example.com'); // Correo electrónico
      await tester.enterText(
          find.byType(TextField).at(1), 'password123'); // Contraseña

      // Tocar el botón de iniciar sesión
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump(); // Actualiza la UI para mostrar el diálogo

      // Verificar si se muestra el diálogo de carga
      expect(find.text('Iniciando sesión...'), findsOneWidget);
    });

    testWidgets('Navega a la pantalla de registro al tocar "Regístrate aquí"', (WidgetTester tester) async {
      // Cargar el widget LogIn
      await tester.pumpWidget(
        MaterialApp(
          home: LogIn(),
        ),
      );

      // Tocar el botón de registro
      await tester.tap(find.text('Regístrate aquí'));
      await tester.pumpAndSettle(); // Espera a que se complete la navegación

    });
  });
}
