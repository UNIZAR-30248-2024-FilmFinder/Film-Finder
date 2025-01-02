import 'package:film_finder/widgets/profile_widgets/text_field_login_widget.dart';
import 'package:film_finder/pages/auth_pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


// Mock para FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock para User
class MockUser extends Mock implements User {
  @override
  String get uid => 'testUserId';
}

@GenerateMocks([FirebaseAuth, FirebaseFirestore])
void main() {
  testWidgets('Pantalla de registro muestra campos correctamente y responde a eventos', (WidgetTester tester) async {
    // Mock de FirebaseAuth y Firestore
    final mockFirebaseAuth = MockFirebaseAuth();

    // Inicia la pantalla de registro
    await tester.pumpWidget(
      MaterialApp(
        home: Register(),
      ),
    );

    // Verifica que los campos de entrada existan
    expect(find.byType(MyTextField), findsNWidgets(4));
    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Repetir contraseña'), findsOneWidget);

    // Verifica que el botón "Registrarse" exista
    expect(find.text('Registrarse'), findsOneWidget);

    // Ingresa datos en los campos de texto
    await tester.enterText(find.widgetWithText(MyTextField, 'Nombre de usuario'), 'TestUser');
    await tester.enterText(find.widgetWithText(MyTextField, 'Correo electrónico'), 'test@example.com');
    await tester.enterText(find.widgetWithText(MyTextField, 'Contraseña'), 'password123');
    await tester.enterText(find.widgetWithText(MyTextField, 'Repetir contraseña'), 'password123');

    // Toca el botón "Registrarse"
    await tester.tap(find.text('Registrarse'));

    // Verifica que se muestra el diálogo de carga
    await tester.pump(); // Espera que el diálogo se actualice
    expect(find.text('Creando la cuenta...'), findsOneWidget);

    // Mock del registro exitoso (esto debe integrarse con Firebase si es un test de integración)
    verifyNever(mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'password123',
    ));
  });
}
