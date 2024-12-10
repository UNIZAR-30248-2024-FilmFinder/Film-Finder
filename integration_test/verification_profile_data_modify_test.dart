import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/widgets/profile_widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:film_finder/pages/auth_pages/login_screen.dart'; // Importa tu pantalla de login
import 'package:firebase_core/firebase_core.dart';
import 'package:film_finder/pages/auth_pages/auth_page.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';



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

  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      const MyApp(),
    );
  });*/
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Test de integración de la pantalla de edición de información del perfil de usuario',
      (WidgetTester tester) async {
    // Inicializa la aplicación en la pantalla de inicio de sesión
    await tester.pumpWidget(const MaterialApp(
      home: AuthPage(),
    ));
    await tester.pumpAndSettle();
    await tester.allElements;
    await tester.enterText(find.byType(TextField).at(0), 'test123@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'test123');

    // Simula un tap en el botón de "INICIAR SESIÓN"
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    await tester.allElements;

    /*await tester.pumpWidget(const MaterialApp(
      home: ProfileScreen(),
    ));*/

    await tester.pumpAndSettle();
    final profileButtonFinder = find.byKey(const Key('profile_button'));

    // Verifica que el botón "Perfil" está presente
    expect(profileButtonFinder, findsOneWidget);

    // Simula un toque en el botón "Perfil"
    await tester.tap(profileButtonFinder);
    await tester.pumpAndSettle(); 
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

    expect(find.textContaining('NewNameTest'), findsOneWidget);
    expect(find.textContaining('NewLocationTest'), findsOneWidget);
    expect(find.textContaining('NewDescrptionTest'), findsOneWidget);
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.pump();
  });
}
