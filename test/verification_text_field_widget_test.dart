import 'package:film_finder/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TextFieldWidget should display label and allow text input', (WidgetTester tester) async {
    String inputText = '';

    // Crear el widget con un callback para capturar el texto ingresado
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextFieldWidget(
          label: 'Enter Text',
          text: '',
          onChanged: (value) {
            inputText = value; // Actualiza el texto ingresado
          },
        ),
      ),
    ));

    // Verificar que la etiqueta se muestra correctamente
    expect(find.text('Enter Text'), findsOneWidget);

    // Verificar que el campo de texto está vacío al inicio
    expect(find.byType(TextField), findsOneWidget);
    expect((tester.widget<TextField>(find.byType(TextField)).controller!.text), '');

    // Ingresar texto en el campo de texto
    await tester.enterText(find.byType(TextField), 'Hello World');

    // Verificar que el texto ingresado se refleja en el controlador
    expect((tester.widget<TextField>(find.byType(TextField)).controller!.text), 'Hello World');

  });
}
