import 'package:flutter/material.dart';
import 'package:film_finder/widgets/search_bar.dart';
import 'package:film_finder/widgets/filters_widget.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    // Obtener la altura de la barra de estado
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: statusBarHeight + 25),
            Center(
              child: Image.asset(
                'assets/images/titulo.png',
                width: 325,
                height: 75,
              ),
            ),
            const SizedBox(height: 5),
            SearchingBar(
              onSearchToggled: (bool isActive) {
                setState(() {
                  isSearchActive = isActive;
                });
              },
            ),
            const SizedBox(height: 25),
            if (!isSearchActive) const Filters(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
