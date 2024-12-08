import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/widgets/profile_widgets/change_password_widget.dart';

void main() {
  testWidgets('Test básico de la pantalla de ProfileScreen',
      (WidgetTester tester) async {
    // Cargar la pantalla de ProfileScreen
    await tester.pumpWidget(MaterialApp(
      home:
          Scaffold(body: ChangePasswordDialog()), // Cambia aquí para usar el widget Filters
    ));


    // Verificar que el nombre del usuario está presente
    expect(find.text('Cambiar Contraseña'), findsOneWidget);

    // Verificar que la ubicación del usuario está presente
    expect(find.text('Antigua Contraseña'), findsOneWidget);

    // Verificar que el email del usuario está presente
    expect(find.text('Nueva Contraseña'), findsOneWidget);
 
    // Verificar que el texto "Peliculas" está presente
    expect(find.text('Confirmar Nueva Contraseña'), findsOneWidget);

    // Verificar que el texto "Sobre mi:" está presente
    expect(find.text('Cancelar'), findsOneWidget);
  });
}
