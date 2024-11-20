import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/widgets/profile_widgets/delete_account_widget.dart'; // Asegúrate de que la ruta sea correcta.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

// Crear un mock de FirebaseAuth para simular las acciones sin necesidad de acceso real a Firebase
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  testWidgets('Test de eliminación de cuenta', (WidgetTester tester) async {
    // Cargar el widget con el botón para mostrar el diálogo de confirmación
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showDeleteAccountDialog(context),
                child: const Text('Eliminar Cuenta'),
              );
            },
          ),
        ),
      ),
    );

    // Verificar que el botón está presente
    expect(find.text('Eliminar Cuenta'), findsOneWidget);

    // Tocar el botón para abrir el diálogo
    await tester.tap(find.text('Eliminar Cuenta'));
    await tester.pump(); // Espera a que el diálogo se muestre

    // Verificar que el diálogo se muestra correctamente
    expect(find.text('Confirmar Borrado'), findsOneWidget);
    expect(find.textContaining('¿Está seguro de que desea borrar su cuenta?'),
        findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Borrar Cuenta'), findsOneWidget);

    // Tocar el botón de cancelar y verificar que el diálogo se cierra
    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    expect(find.text('Confirmar Borrado'), findsNothing);
  });
}
