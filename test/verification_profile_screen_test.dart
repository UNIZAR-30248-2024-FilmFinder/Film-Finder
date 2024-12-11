import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:film_finder/pages/auth_pages/auth_page.dart';
import 'package:flutter/services.dart';


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
  //WidgetsFlutterBinding.ensureInitialized();



  //TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test básico de la pantalla de ProfileScreen',
      (WidgetTester tester) async {
          Firebase.initializeApp();
          initializeDateFormatting('es', null);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top]);
        SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      const MyApp(),
    );
  });

    // Cargar la pantalla de ProfileScreen
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthPage(),
      ),
    );

    // Verificar que el nombre del usuario está presente
    //expect(find.text('Jorge'), findsOneWidget);

    // Verificar que la ubicación del usuario está presente
    //expect(find.text('España, Zaragoza'), findsOneWidget);

    // Verificar que el email del usuario está presente
    //expect(find.text('845647@unizar.es'), findsOneWidget);

    // Verificar que el color de fondo es el esperado
    final Scaffold scaffold = tester.widget(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color.fromRGBO(34, 9, 44, 1));

    // Verificar que el texto "Peliculas" está presente
    expect(find.text('Peliculas'), findsOneWidget);

    // Verificar que el texto "Sobre mi:" está presente
    expect(find.text('Sobre mi:'), findsOneWidget);
  });
}
