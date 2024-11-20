import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/menu_pages/initial_screen.dart';
import 'package:film_finder/pages/menu_pages/explore_screen.dart';
import 'package:film_finder/pages/profile_pages/friends_screen.dart';
import 'package:film_finder/pages/profile_pages/profile_screen.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';

void main() {
  testWidgets('Testing navigation between tabs', (WidgetTester tester) async {
    // Ejecuta el widget PrincipalScreen en el entorno de pruebas
    await tester.pumpWidget(const MaterialApp(home: PrincipalScreen()));

    // Verifica que inicialmente se está mostrando la pantalla de inicio
    expect(find.byType(InitialScreen), findsOneWidget);
    expect(find.byType(ExploreScreen), findsNothing);
    expect(find.byType(FriendsScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsNothing);

    // Simula el tap en el segundo ícono de la barra de navegación (Explorar) usando el ícono en vez del texto
    await tester.tap(find.byKey(Key('explore_button')));
    await tester.pumpAndSettle(); // Espera a que la animación termine

    // Verifica que ahora se muestra la pantalla de explorar
    expect(find.byType(InitialScreen), findsNothing);
    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.byType(FriendsScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsNothing);

    // Simula el tap en el tercer ícono de la barra de navegación (Amigos)
    await tester.tap(find.byKey(Key('friends_button')));
    await tester.pumpAndSettle();

    // Verifica que ahora se muestra la pantalla de amigos
    expect(find.byType(InitialScreen), findsNothing);
    expect(find.byType(ExploreScreen), findsNothing);
    expect(find.byType(FriendsScreen), findsOneWidget);
    expect(find.byType(ProfileScreen), findsNothing);

    // Simula el tap en el cuarto ícono de la barra de navegación (Perfil)
    await tester.tap(find.byKey(Key('profile_button')));
    await tester.pumpAndSettle();

    // Verifica que ahora se muestra la pantalla de perfil
    expect(find.byType(InitialScreen), findsNothing);
    expect(find.byType(ExploreScreen), findsNothing);
    expect(find.byType(FriendsScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('PrincipalScreen has correct background colors',
      (WidgetTester tester) async {
    // Cargar el widget
    await tester.pumpWidget(const MaterialApp(home: PrincipalScreen()));

    // Obtener el Scaffold principal y comprobar el color de fondo
    final scaffoldFinder = find
        .byType(Scaffold)
        .first; // Cambiado a first para encontrar solo el primer Scaffold
    expect(scaffoldFinder, findsOneWidget);

    final scaffoldWidget = tester.widget<Scaffold>(scaffoldFinder);
    expect(scaffoldWidget.backgroundColor, const Color.fromRGBO(34, 9, 44, 1));
  });
}
