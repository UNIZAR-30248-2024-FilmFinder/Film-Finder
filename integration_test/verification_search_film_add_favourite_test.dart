import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/pages/auth_pages/register_screen.dart';
import 'package:film_finder/widgets/filters_widgets/card_filter_widget.dart';
import 'package:film_finder/widgets/profile_widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  testWidgets('Test de integración de busqueda por filtros',
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
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Introduce texto en los campos de email y contraseña
    await tester.enterText(find.byType(TextField).at(0), 'test123@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), 'test123');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'el club de la lucha');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    await tester.tap(find.byType(GestureDetector).at(1));
    await tester.pumpAndSettle();
    final profileButtonFinder = find.byKey(const Key('profile_button'));

    // Verifica que el botón "Perfil" está presente
    expect(profileButtonFinder, findsOneWidget);

    // Simula un toque en el botón "Perfil"
    await tester.tap(profileButtonFinder);
    await tester.pumpAndSettle(); 
    await tester.tap(find.text('Ver lista de favoritos'));
    await tester.pumpAndSettle(); 
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle(); 
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    tester.allElements;
  });
}
