import 'package:flutter/material.dart';

class FilmInfo extends StatelessWidget {
  const FilmInfo({super.key, required this.film});

  // Sustituir por un tipo de dato que almace los datos de las películas
  final String film;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(top: 2, left: 16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(34, 9, 44, 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
            expandedHeight: 275,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Stack(
                children: [
                  Text(
                    film,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    film,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.asset(
                  'assets/images/example.jpg',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ), //Image.network(src),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  SizedBox(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/example_poster.jpg',
                          height: 165,
                          width: 165,
                        ), //Image.network(src),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                    film,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = Colors.black,
                                    ),
                                  ),
                                  Text(
                                    film,
                                    style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                children: [
                                  Text(
                                    'Géneros: ',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Ciencia ficción - Aventura',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                children: [
                                  Text(
                                    'Duración: ',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '169 mins',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                children: [
                                  Text(
                                    'Director: ',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Christopher Nolan',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                '¿TRAILER?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Fecha de estreno: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'xx/xx/xxxx',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'Puntuación: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '9/10 ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'En un futuro cercano en el Medio Oeste de Estados Unidos, Cooper, un ex ingeniero científico y piloto, está atado a su tierra de cultivo con su hija Murph y su hijo Tom. Mientras devastadoras tormentas de arena arrasan los cultivos de la Tierra, la gente de la Tierra se da cuenta de que su vida aquí está llegando a su fin a medida que la comida comienza a escasear. Finalmente, al tropezar con una base de la NASA a 6 horas de la casa de Cooper, se le pide que participe en una audaz misión con otros científicos en un agujero de gusano debido al intelecto científico de Cooper y su capacidad para pilotear aviones a diferencia de los otros miembros de la tripulación. Para encontrar un nuevo hogar mientras la Tierra se desintegra, Cooper debe decidir si se queda o corre el riesgo de no volver a ver a sus hijos para salvar a la raza humana encontrando otro planeta habitable.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Futuras Opciones',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
