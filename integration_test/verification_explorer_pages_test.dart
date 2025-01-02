import 'package:film_finder/pages/menu_pages/initial_screen.dart';
import 'package:film_finder/widgets/film_widgets/movie_slider.dart';
import 'package:film_finder/widgets/film_widgets/trending_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:film_finder/pages/auth_pages/login_screen.dart'; // Importa tu pantalla de login
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

  testWidgets('Test de integración de la pantalla de Login',
      (WidgetTester tester) async {
    // Inicializa la aplicación en la pantalla de inicio de sesión
    await tester.pumpWidget(const MaterialApp(
      home: AuthPage(),
    ));
    await tester.pumpAndSettle();
    await tester.allElements;
    // Verifica que los elementos de la pantalla de login estén presentes
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    expect(
        find.byType(TextField),
        findsNWidgets(
            2)); // Asume que hay dos campos de texto (email y password)
    //expect(find.text('¿No tienes una cuenta? '), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Introduce texto en los campos de email y contraseña
    await tester.enterText(find.byType(TextField).at(0), 'test123@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'test123');

    // Simula un tap en el botón de "INICIAR SESIÓN"
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    //await tester.pump(); // Asegura que el entorno está limpio
    final exploreButtonFinder = find.byKey(const Key('explore_button'));
    await tester.tap(exploreButtonFinder);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    // Verifica que el botón "Perfil" está presente
    final scrollable = find.byType(TrendingSlider).at(0);
    await tester.drag(scrollable, const Offset(-300, 0));  // Desliza 300 píxeles hacia la izquierda (es decir, hacia la derecha)
    await tester.pumpAndSettle();
    await tester.allElements;
    await tester.pump(const Duration(seconds: 4));
    final scrollable2 = find.byType(SingleChildScrollView).at(0);
    await tester.drag(scrollable2, const Offset(0, -500));  
    await tester.pumpAndSettle();
    await tester.allElements;
    await tester.pump(const Duration(seconds: 2));
    final scrollable3 = find.byType(MovieSlider).at(0);
    await tester.drag(scrollable3, const Offset(-200, 0));   
    await tester.pumpAndSettle();
    await tester.allElements;
    await tester.pump(const Duration(seconds: 2));
    final scrollable5 = find.byType(MovieSlider).at(1);
    await tester.drag(scrollable5, const Offset(-400, 0));  
    await tester.pump(const Duration(seconds: 2));
    // Simula un toque en el botón "Perfil"
    final profileButtonFinder = find.byKey(const Key('profile_button'));
    await tester.tap(profileButtonFinder);
    await tester.pumpAndSettle(); 
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.pump();
  });
  
}
