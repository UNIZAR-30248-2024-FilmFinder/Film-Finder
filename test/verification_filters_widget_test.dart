import 'package:film_finder/widgets/filters_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Should display title "ELIGE QUE VER"', (WidgetTester tester) async {
    // Configura el widget en el entorno de pruebas
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Filters()), // Cambia aquí para usar el widget Filters
    ));

    // Verifica que el texto esté presente en la pantalla
    expect(find.text('ELIGE QUE VER'), findsOneWidget);
  });


  testWidgets('Should display genre sleection, platform selection and group selection at the last step', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: Filters()), // Usa el widget Filters
    ));

    // Verifica que se muestre la selección de géneros inicialmente
    expect(find.text('Selecciona generos que te gusten'), findsOneWidget); // Cambia esto si es necesario

    // Presiona el botón "Siguiente"
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle(); // Espera a que la animación termine

    // Verifica que se muestre la selección de plataformas
    expect(find.text('Selecciona las plataformas que tengas'), findsOneWidget); // Asegúrate de que este texto se muestre en la selección de plataformas

    // Simula avanzar hasta la selección de modo de búsqueda
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle(); // Espera a que la animación termine

// Verifica que se muestre la selección de plataformas
    expect(find.text('Selecciona como vas a hacer la búsqueda'), findsOneWidget); // Asegúrate de que este texto se muestre en la selección de plataformas
  });

  testWidgets('Should display genre selection cards with correct counts', (WidgetTester tester) async {
    // Define un vector de géneros
    const genres = [
      'ACCION', 'ANIMACION', 'AVENTURA', 'CIENCIA FICCIÓN', 'COMEDIA', 'CRIMEN', 'DOCUMENTAL', 'DRAMA', 'FAMILIA',
      'FANTASIA', 'GUERRA', 'HISTORIA', 'MISTERIO', 'MUSICA', 'PELICULA TV', 'ROMANCE', 'SUSPENSE', 'TERROR', 'WESTERN'
    ];

    // Configura el widget en el entorno de pruebas
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Filters()))); // Usa el widget Filters
  // Verifica que el widget de selección de géneros esté presente
    expect(find.byKey(const Key('genre_selection')), findsOneWidget);

    // Recorre cada género y verifica que aparezca exactamente dos veces
    for (var genre in genres) {
      expect(find.text(genre), findsExactly(2)); // Verifica que cada género esté presente exactamente dos veces
    }
  });

  testWidgets('Should display a scrollbar for genre selection', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Filters(), // Usa el widget Filters
      ),
    ));

    // Verifica que el Scrollbar esté presente en el widget
    expect(find.byType(Scrollbar), findsOneWidget);

    // Asegúrate de que el Scrollbar tenga la visibilidad del pulgar habilitada
    final scrollbarFinder = find.byType(Scrollbar);
    final scrollbarWidget = tester.widget<Scrollbar>(scrollbarFinder);

    expect(scrollbarWidget.thumbVisibility, isTrue); // Verifica que thumbVisibility sea true
  });

  testWidgets('Should display platform selection cards with correct counts', (WidgetTester tester) async {
    // Define un vector de géneros
    const genres = [
      'APPLE TV', 'DISNEY +', 'HBO MAX', 'NETFLIX', 'PRIME VIDEO'
    ];

    // Configura el widget en el entorno de pruebas
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Filters()))); // Usa el widget Filters

    // Presiona el botón "Siguiente"
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle(); // Espera a que la animación termine

    // Verifica que el widget de selección de géneros esté presente
    expect(find.byKey(const Key('platform_selection')), findsOneWidget);

    // Recorre cada género y verifica que aparezca exactamente dos veces
    for (var genre in genres) {
      expect(find.text(genre), findsExactly(2)); // Verifica que cada género esté presente exactamente dos veces
    }
  });

  testWidgets('Should display a scrollbar for platform selection', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Filters(), // Usa el widget Filters
      ),
    ));

    // Presiona el botón "Siguiente"
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle(); // Espera a que la animación termine

    // Verifica que el Scrollbar esté presente en el widget
    expect(find.byType(Scrollbar), findsOneWidget);

    // Asegúrate de que el Scrollbar tenga la visibilidad del pulgar habilitada
    final scrollbarFinder = find.byType(Scrollbar);
    final scrollbarWidget = tester.widget<Scrollbar>(scrollbarFinder);

    expect(scrollbarWidget.thumbVisibility, isTrue); // Verifica que thumbVisibility sea true
  });

  testWidgets('Should display group selection cards with correct counts', (WidgetTester tester) async {
    // Define un vector de géneros
    const genres = [
      'INDIVIDUAL', 'GRUPAL'
    ];

    // Configura el widget en el entorno de pruebas
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Filters()))); // Usa el widget Filters

    // Presiona el botón "Siguiente"
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle(); // Espera a que la animación termine
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle(); // Espera a que la animación termine


    // Verifica que el widget de selección de géneros esté presente
    expect(find.byKey(const Key('group_selection')), findsOneWidget);

    // Recorre cada género y verifica que aparezca exactamente dos veces
    for (var genre in genres) {
      expect(find.text(genre), findsOneWidget); // Verifica que cada género esté presente exactamente dos veces
    }
  });









}