import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/profile_pages/diary_screen.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importación para inicialización de datos locales
import 'package:intl/intl.dart';

void main() async {

  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);

  testWidgets('Diary widget renders correctly with movie data',
      (WidgetTester tester) async {

    final mockMovies = [
      MovieDiaryEntry(
        movieId: 1,
        viewingDate: '2024-12-01',
        personalRating: 4.5,
        review: '',
        documentId: '',
      ),
      MovieDiaryEntry(
        movieId: 2,
        viewingDate: '2024-11-15',
        personalRating: 3.0,
        review: '',
        documentId: '',
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Diary(movies: mockMovies),
    ));

    expect(find.text('Diario'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text(DateFormat.yMMMM('es_ES').format(DateTime(2024, 12))),
        findsOneWidget);
    expect(find.text(DateFormat.yMMMM('es_ES').format(DateTime(2024, 11))),
        findsOneWidget);

    expect(find.text('Título desconocido'), findsNWidgets(2));
    expect(find.text('Fecha no disponible'), findsNWidgets(2));


    expect(find.byType(Row), findsNWidgets(2)); // Cada película ocupa un Row

  
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

  });
}
