import 'package:film_finder/widgets/movie_slider.dart';
import 'package:film_finder/widgets/trending_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/pages/explore_screen.dart';

void main() {
  testWidgets('ExploreScreen renders correctly', (WidgetTester tester) async {
    // Carga la pantalla ExploreScreen
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));

    // Verifica que los textos principales están presentes
    expect(find.text('Tendencias'), findsOneWidget);
    expect(find.text('Mejor Valoradas'), findsOneWidget);
    expect(find.text('Próximos Estrenos'), findsOneWidget);

    // Verifica que los widgets TrendingSlider y MovieSlider están presentes
    expect(find.byType(TrendingSlider), findsOneWidget);
    expect(find.byType(MovieSlider), findsNWidgets(2)); // Hay 2 MovieSliders
  });

  testWidgets('ExploreScreen scrolls vertically', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));

    // Verifica que hay un `SingleChildScrollView`
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Simula un desplazamiento hacia abajo
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pump();

    // Verifica que el desplazamiento fue exitoso (el contenido se mueve)
    expect(find.text('Tendencias'), findsOneWidget);  // Se asegura de que sigue en la pantalla
  });

  testWidgets('ExploreScreen has correct AppBar and background color', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ExploreScreen()));

    // Verifica que el AppBar tiene el color adecuado
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, const Color.fromRGBO(34, 9, 44, 1));

    // Verifica que el fondo de la pantalla tiene el color adecuado
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, const Color.fromRGBO(34, 9, 44, 1));
  });

}
