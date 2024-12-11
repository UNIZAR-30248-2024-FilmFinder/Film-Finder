import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/pages/auth_pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:film_finder/pages/auth_pages/auth_page.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RedirectPage(),
    );
  }
}

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    });

    return const Scaffold();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  initializeDateFormatting('es', null);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top]);
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test de integración de la pantalla de Registro',
      (WidgetTester tester) async {
    // Inicializa la aplicación en la pantalla de inicio de sesión
    await tester.pumpWidget(const MaterialApp(
      home: AuthPage(),
    ));
    await tester.pumpAndSettle();
    await tester.allElements;
    final registerTextButtonFinder = find.byWidgetPredicate(
    (widget) =>
      widget is TextButton &&
      widget.child is RichText &&
      (widget.child as RichText).text.toPlainText().contains('Regístrate aquí'),
    );
    expect(registerTextButtonFinder, findsOneWidget);
    await tester.tap(registerTextButtonFinder);
    await tester.pumpAndSettle();
    await tester.allElements;
    // Verifica que los elementos de la pantalla de login estén presentes
    expect(find.text('CREAR UNA CUENTA'), findsOneWidget);
    expect(
        find.byType(TextField),
        findsNWidgets(
            4)); // Asume que hay cuatro campos de texto (user, email y dos password)
    final CuentaTextButtonFinder = find.byWidgetPredicate(
    (widget) =>
      widget is TextButton &&
      widget.child is RichText &&
      (widget.child as RichText).text.toPlainText().contains('¿Ya tienes cuenta? '),
    );
    expect(CuentaTextButtonFinder, findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Introduce texto en los campos correspodnientes
    await tester.enterText(find.byType(TextField).at(0), 'testR');
    await tester.enterText(
        find.byType(TextField).at(1), 'testR@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'test123');
    await tester.enterText(find.byType(TextField).at(3), 'test123');

    // Simula un tap en el botón de "Registrarse"
    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();



        final profileButtonFinder = find.byKey(const Key('profile_button'));

    // Verifica que el botón "Perfil" está presente
    expect(profileButtonFinder, findsOneWidget);

    // Simula un toque en el botón "Perfil"
    await tester.tap(profileButtonFinder);
    await tester.pumpAndSettle(); 
    expect(find.textContaining('testR'), findsAtLeast(1));
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.pump();
  });
}
