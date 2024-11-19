import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/widgets/text_field_login_widget.dart';

void main() {
  testWidgets('MyTextField widget test', (WidgetTester tester) async {
    // Crea un controlador de texto
    final controller = TextEditingController();

    // Construye el widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextField(
            controller: controller,
            hintText: 'Enter text',
            obscureText: false,
          ),
        ),
      ),
    );

    // Asegúrate de que el widget esté completamente renderizado
    await tester.pump();

    // Verifica que el widget MyTextField esté presente
    expect(find.byType(MyTextField), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Verifica el hintText
    expect(find.text('Enter text'), findsOneWidget);

    // Verifica si el TextField no tiene el obscureText activado
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.obscureText, false);

    // Cambia el estado del obscureText
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyTextField(
            controller: controller,
            hintText: 'Enter text',
            obscureText: true,
          ),
        ),
      ),
    );
    await tester.pump(); // Asegúrate de que el widget se haya reconstruido

    // Verifica que el obscureText esté activado
    final textFieldWithObscure = tester.widget<TextField>(find.byType(TextField));
    expect(textFieldWithObscure.obscureText, true);
  });
}
