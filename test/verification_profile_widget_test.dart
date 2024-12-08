import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:film_finder/widgets/profile_widgets/profile_widget.dart';

void main() {
  group('ProfileWidget Tests', () {
    testWidgets('Carga con imagen predeterminada cuando imagePath está vacío', (WidgetTester tester) async {
      // Cargar el widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileWidget(
            imagePath: '',
            onClicked: () {},
          ),
        ),
      ));

      // Verificar que se usa la imagen predeterminada
      final defaultImageFinder = find.byType(AssetImage);
      expect(defaultImageFinder, findsNothing);
    });

    testWidgets('Carga con imagen de red válida', (WidgetTester tester) async {
      
      // Cargar el widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileWidget(
            imagePath: 'networkImageUrl',
            onClicked: () {},
          ),
        ),
      ));


      final networkImageFinder = find.byType(NetworkImage);
      expect(networkImageFinder, findsNothing);
    });

    testWidgets('Carga con imagen local válida', (WidgetTester tester) async {
      const localImagePath = '/path/to/local/image.jpg';

      // Simular que el archivo existe
      File(localImagePath).createSync(recursive: true);

      // Cargar el widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileWidget(
            imagePath: localImagePath,
            onClicked: () {},
          ),
        ),
      ));

      // Verificar que se usa una imagen local
      final fileImageFinder = find.byType(FileImage);
      expect(fileImageFinder, findsNothing);

      // Limpieza: eliminar el archivo simulado
      File(localImagePath).deleteSync();
    });

    testWidgets('Simular interacción con onClicked', (WidgetTester tester) async {
      bool clicked = false;

      // Cargar el widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileWidget(
            imagePath: '',
            onClicked: () {
              clicked = true;
            },
          ),
        ),
      ));

      // Encontrar el botón y simular un clic
      final buttonFinder = find.byType(InkWell);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      // Verificar que se haya ejecutado el callback
      expect(clicked, isTrue);
    });

    testWidgets('Muestra el icono correcto según el valor de isEdit', (WidgetTester tester) async {
      // Cargar el widget con isEdit = true
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileWidget(
            imagePath: '',
            onClicked: () {},
            isEdit: true,
          ),
        ),
      ));

      // Verificar que se muestra el icono de agregar foto
      final addPhotoIconFinder = find.byIcon(Icons.add_a_photo);
      expect(addPhotoIconFinder, findsOneWidget);

      // Cargar el widget con isEdit = false
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProfileWidget(
            imagePath: '',
            onClicked: () {},
            isEdit: false,
          ),
        ),
      ));

      // Verificar que se muestra el icono de editar
      final editIconFinder = find.byIcon(Icons.edit);
      expect(editIconFinder, findsOneWidget);
    });
  });
}
