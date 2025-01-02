import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/widgets/profile_widgets/change_password_widget.dart';

void main() {
  testWidgets('Test completo de ChangePasswordDialog', (WidgetTester tester) async {
    // Cargar el widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ChangePasswordDialog()),
    ));

    // Verificar que los textos iniciales están presentes
    expect(find.text('Cambiar Contraseña'), findsOneWidget);
    expect(find.text('Antigua Contraseña'), findsOneWidget);
    expect(find.text('Nueva Contraseña'), findsOneWidget);
    expect(find.text('Confirmar Nueva Contraseña'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Cambiar'), findsOneWidget);

    // Simular interacción con los TextFields
    await tester.enterText(find.byType(TextField).at(0), 'oldPassword123');
    await tester.enterText(find.byType(TextField).at(1), 'newPass123');
    await tester.enterText(find.byType(TextField).at(2), 'newPass123');

    expect(find.text('oldPassword123'), findsOneWidget);
    expect(find.text('newPass123'), findsNWidgets(2));

    // Probar flujo de error: contraseñas no coinciden
    await tester.enterText(find.byType(TextField).at(2), 'differentPass123');
    await tester.tap(find.text('Cambiar'));
    await tester.pump();
    expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);

    // Probar flujo de error: contraseña corta
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.tap(find.text('Cambiar'));
    await tester.pump();
    expect(find.text('La contraseña debe tener al menos seis caracteres'), findsOneWidget);

    // Probar botón Cancelar
    final cancelButton = find.text('Cancelar');
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
    //await tester.pump();
    expect(find.byType(ChangePasswordDialog), findsNothing);
  });
}
