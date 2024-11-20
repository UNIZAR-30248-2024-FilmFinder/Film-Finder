import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:film_finder/widgets/filters_widgets/filters_widget.dart';
import 'package:film_finder/widgets/film_widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/menu_pages/initial_screen.dart';

void main() {
  testWidgets('InitialScreen displays title, search bar, and filters',
      (WidgetTester tester) async {
    // Cargar el widget
    await tester.pumpWidget(const MaterialApp(home: InitialScreen()));

    final titleImageFinder =
        find.byType(Image).first; // Buscamos el primer widget de tipo Image
    expect(titleImageFinder, findsOneWidget);

    // Verificar que el tamaño de la imagen del título es correcto
    final titleImageWidget = tester.widget<Image>(titleImageFinder);
    expect(titleImageWidget.width, 325);
    expect(titleImageWidget.height, 75);

    // Verificar que la barra de búsqueda se muestra
    expect(find.byType(SearchingBar), findsOneWidget);
    // Verificar que el widget de filtros se muestra
    expect(find.byType(Filters), findsOneWidget);
  });

  testWidgets('PrincipalScreen bottom navigation bar icons are visible',
      (WidgetTester tester) async {
    // Cargar el widget
    await tester.pumpWidget(const MaterialApp(home: PrincipalScreen()));

    // Verificar que los íconos de la barra de navegación están visibles
    expect(find.byKey(Key('init_button')), findsOneWidget);
    expect(find.byKey(Key('explore_button')), findsOneWidget);
    expect(find.byKey(Key('friends_button')), findsOneWidget);
    expect(find.byKey(Key('profile_button')), findsOneWidget);
  });
}
