import 'package:flutter/material.dart';
import 'package:film_finder/widgets/card_filter_widget.dart';
import 'package:film_finder/pages/filter_film_screen.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int pasoDeFiltro = 0;

  final ScrollController _genreScrollController = ScrollController();
  final ScrollController _platformScrollController = ScrollController();

  @override
  void dispose() {
    _genreScrollController.dispose();
    _platformScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(21, 4, 29, 1),
          border: Border.all(
            color: const Color.fromRGBO(190, 49, 68, 1),
            width: 1.75,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ELIGE QUE VER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (pasoDeFiltro == 0)
              Column(
                children: [
                  SingleChildScrollView(
                    controller: _genreScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/accion.png',
                            text: 'ACCION',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/animacion.png',
                            text: 'ANIMACION',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/aventura.png',
                            text: 'AVENTURA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/cienciaFiccion.png',
                            text: 'CIENCIA FICCIÓN',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/comedia.png',
                            text: 'COMEDIA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/crimen.png',
                            text: 'CRIMEN',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/documental.png',
                            text: 'DOCUMENTAL',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/drama.png',
                            text: 'DRAMA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/familia.png',
                            text: 'FAMILIA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/fantasia.png',
                            text: 'FANTASIA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/guerra.png',
                            text: 'GUERRA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/historia.png',
                            text: 'HISTORIA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/misterio.png',
                            text: 'MISTERIO',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/musica.png',
                            text: 'MUSICA',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/peliculaTV.png',
                            text: 'PELICULA TV',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/romance.png',
                            text: 'ROMANCE',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/suspense.png',
                            text: 'SUSPENSE',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/terror.png',
                            text: 'TERROR',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA EL GENERO INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/genres_icons/western.png',
                            text: 'WESTERN',
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pasoDeFiltro++;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(190, 49, 68, 1),
                          width: 1.0,
                        ),
                      ),
                      fixedSize: const Size(130, 42),
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            if (pasoDeFiltro == 1)
              Column(
                children: [
                  SingleChildScrollView(
                    controller: _platformScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/platform_icons/apple-tv.png',
                            text: 'APPLE TV',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/platform_icons/disneyPlus.png',
                            text: 'DISNEY +',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/platform_icons/hbo.png',
                            text: 'HBO MAX',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/platform_icons/netflix.png',
                            text: 'NETFLIX',
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                          },
                          child: const CardFilter(
                            image: 'assets/platform_icons/primeVideo.png',
                            text: 'PRIME VIDEO',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            pasoDeFiltro--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(190, 49, 68, 1),
                              width: 1.0,
                            ),
                          ),
                          fixedSize: const Size(130, 42),
                        ),
                        child: const Text(
                          'Atrás',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            //REINICIAR VALORES
                            pasoDeFiltro++;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(190, 49, 68, 1),
                              width: 1.0,
                            ),
                          ),
                          fixedSize: const Size(130, 42),
                        ),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            if (pasoDeFiltro == 2)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterFilmScreen()),
                            );
                          },
                          child: Container(
                            height: 240,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 133, 46, 26),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.25,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image:
                                      AssetImage('assets/icons/individual.png'),
                                  width: 90,
                                  height: 90,
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    'INDIVIDUAL',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            //DIRIGIMOS A LA ELECCIÓN GRUPAL
                          },
                          child: Container(
                            height: 240,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 133, 46, 26),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.25,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage('assets/icons/grupal.png'),
                                  width: 90,
                                  height: 90,
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: Text(
                                    'GRUPAL',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        //REINICIAR VALORES
                        pasoDeFiltro--;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(190, 49, 68, 1),
                          width: 1.0,
                        ),
                      ),
                      fixedSize: const Size(130, 42),
                    ),
                    child: const Text(
                      'Atrás',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
