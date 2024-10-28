import 'package:flutter/material.dart';
import 'package:film_finder/widgets/card_filter_widget.dart';
import 'package:film_finder/pages/filter_film_screen.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/methods/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  int pasoDeFiltro = 0;

  List<String> filterGenres = [];
  List<String> filterProviders = ['337'];
  List<int> arrayGenres = List.filled(19, 0);
  List<int> arrayProviders = List.filled(5, 0);

  ScrollController _genreScrollController = ScrollController();
  ScrollController _platformScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _genreScrollController = ScrollController();
    _platformScrollController = ScrollController();
  }

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
            const SizedBox(height: 30),
            if (pasoDeFiltro == 0) ...[
              _buildGenreSelection(),
            ],
            if (pasoDeFiltro == 1) ...[
              _buildPlatformSelection(),
            ],
            if (pasoDeFiltro == 2) ...[
              _buildGroupSelection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenreSelection() {
    return Column(
      key: const Key('genre_selection'),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Selecciona generos que te gusten',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Scrollbar(
          controller: _genreScrollController,
          thumbVisibility: true,
          thickness: 10.0,
          radius: const Radius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: SingleChildScrollView(
              controller: _genreScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[0] == 0){
                          filterGenres.add('28');
                          arrayGenres[0] = arrayGenres[0] + 1;
                        }
                        else{
                          filterGenres.remove('28');
                          arrayGenres[0] = arrayGenres[0] - 1;
                        }
                      setState(() {});
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/accion.png',
                      text: 'ACCION',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[1] == 0){
                          filterGenres.add('16');
                          arrayGenres[1] = arrayGenres[1] + 1;
                        }
                        else{
                          filterGenres.remove('16');
                          arrayGenres[1] = arrayGenres[1] - 1;
                        }
                      });
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
                        if(arrayGenres[2] == 0){
                          filterGenres.add('12');
                          arrayGenres[2] = arrayGenres[2] + 1;
                        }
                        else{
                          filterGenres.remove('12');
                          arrayGenres[2] = arrayGenres[2] - 1;
                        }
                      setState(() {});
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/aventura.png',
                      text: 'AVENTURA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[3] == 0){
                          filterGenres.add('878');
                          arrayGenres[3] = arrayGenres[3] + 1;
                        }
                        else{
                          filterGenres.remove('878');
                          arrayGenres[3] = arrayGenres[3] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/cienciaFiccion.png',
                      text: 'CIENCIA FICCIÓN',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[4] == 0){
                          filterGenres.add('35');
                          arrayGenres[4] = arrayGenres[4] + 1;
                        }
                        else{
                          filterGenres.remove('35');
                          arrayGenres[4] = arrayGenres[4] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/comedia.png',
                      text: 'COMEDIA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[5] == 0){
                          filterGenres.add('80');
                          arrayGenres[5] = arrayGenres[5] + 1;
                        }
                        else{
                          filterGenres.remove('80');
                          arrayGenres[5] = arrayGenres[5] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/crimen.png',
                      text: 'CRIMEN',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[6] == 0){
                          filterGenres.add('99');
                          arrayGenres[6] = arrayGenres[6] + 1;
                        }
                        else{
                          filterGenres.remove('99');
                          arrayGenres[6] = arrayGenres[6] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/documental.png',
                      text: 'DOCUMENTAL',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[7] == 0){
                          filterGenres.add('18');
                          arrayGenres[7] = arrayGenres[7] + 1;
                        }
                        else{
                          filterGenres.remove('18');
                          arrayGenres[7] = arrayGenres[7] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/drama.png',
                      text: 'DRAMA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[8] == 0){
                          filterGenres.add('10751');
                          arrayGenres[8] = arrayGenres[8] + 1;
                        }
                        else{
                          filterGenres.remove('10751');
                          arrayGenres[8] = arrayGenres[8] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/familia.png',
                      text: 'FAMILIA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[9] == 0){
                          filterGenres.add('14');
                          arrayGenres[9] = arrayGenres[9] + 1;
                        }
                        else{
                          filterGenres.remove('14');
                          arrayGenres[9] = arrayGenres[9] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/fantasia.png',
                      text: 'FANTASIA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[10] == 0){
                          filterGenres.add('10752');
                          arrayGenres[10] = arrayGenres[10] + 1;
                        }
                        else{
                          filterGenres.remove('10752');
                          arrayGenres[10] = arrayGenres[10] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/guerra.png',
                      text: 'GUERRA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[11] == 0){
                          filterGenres.add('36');
                          arrayGenres[11] = arrayGenres[11] + 1;
                        }
                        else{
                          filterGenres.remove('36');
                          arrayGenres[11] = arrayGenres[11] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/historia.png',
                      text: 'HISTORIA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[12] == 0){
                          filterGenres.add('9648');
                          arrayGenres[12] = arrayGenres[12] + 1;
                        }
                        else{
                          filterGenres.remove('9648');
                          arrayGenres[12] = arrayGenres[12] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/misterio.png',
                      text: 'MISTERIO',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[13] == 0){
                          filterGenres.add('10402');
                          arrayGenres[13] = arrayGenres[13] + 1;
                        }
                        else{
                          filterGenres.remove('10402');
                          arrayGenres[13] = arrayGenres[13] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/musica.png',
                      text: 'MUSICA',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[14] == 0){
                          filterGenres.add('10770');
                          arrayGenres[14] = arrayGenres[14] + 1;
                        }
                        else{
                          filterGenres.remove('10770');
                          arrayGenres[14] = arrayGenres[14] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/peliculaTV.png',
                      text: 'PELICULA TV',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[15] == 0){
                          filterGenres.add('10749');
                          arrayGenres[15] = arrayGenres[15] + 1;
                        }
                        else{
                          filterGenres.remove('10749');
                          arrayGenres[15] = arrayGenres[15] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/romance.png',
                      text: 'ROMANCE',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[16] == 0){
                          filterGenres.add('53');
                          arrayGenres[16] = arrayGenres[16] + 1;
                        }
                        else{
                          filterGenres.remove('53');
                          arrayGenres[16] = arrayGenres[16] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/suspense.png',
                      text: 'SUSPENSE',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[17] == 0){
                          filterGenres.add('27');
                          arrayGenres[17] = arrayGenres[17] + 1;
                        }
                        else{
                          filterGenres.remove('27');
                          arrayGenres[17] = arrayGenres[17] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/terror.png',
                      text: 'TERROR',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA EL GENERO INDICADO
                        if(arrayGenres[18] == 0){
                          filterGenres.add('37');
                          arrayGenres[18] = arrayGenres[18] + 1;
                        }
                        else{
                          filterGenres.remove('37');
                          arrayGenres[18] = arrayGenres[18] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/genres_icons/western.png',
                      text: 'WESTERN',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              pasoDeFiltro++;
              _genreScrollController.jumpTo(0);
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
    );
  }

  Widget _buildPlatformSelection() {
    return Column(
      key: const Key('platform_selection'),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Selecciona las plataformas que tengas',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Scrollbar(
          controller: _platformScrollController,
          thumbVisibility: true,
          thickness: 10.0,
          radius: const Radius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: SingleChildScrollView(
              controller: _platformScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                        if(arrayProviders[0] == 0){
                          filterProviders.add('2');
                          arrayProviders[0] = arrayProviders[0] + 1;
                        }
                        else{
                          filterProviders.remove('2');
                          arrayProviders[0] = arrayProviders[0] - 1;
                        }
                      });
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
                        if(arrayProviders[1] == 0){
                          filterProviders.add('337');
                          arrayProviders[1] = arrayProviders[1] + 1;
                        }
                        else{
                          filterProviders.remove('337');
                          arrayProviders[1] = arrayProviders[1] - 1;
                        }
                        setState(() {});
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
                        if(arrayProviders[2] == 0){
                          filterProviders.add('1899');
                          arrayProviders[2] = arrayProviders[2] + 1;
                        }
                        else{
                          filterProviders.remove('1899');
                          arrayProviders[2] = arrayProviders[2] - 1;
                        }
                        setState(() {});
                    },
                    child: const CardFilter(
                      image: 'assets/platform_icons/hbo.png',
                      text: 'HBO MAX',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                        if(arrayProviders[3] == 0){
                          filterProviders.add('8');
                          arrayProviders[3] = arrayProviders[3] + 1;
                        }
                        else{
                          filterProviders.remove('8');
                          arrayProviders[3] = arrayProviders[3] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/platform_icons/netflix.png',
                      text: 'NETFLIX',
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // AÑADIR A LA LISTA LA PLATAFORMA INDICADO
                        if(arrayProviders[4] == 0){
                          filterProviders.add('119');
                          arrayProviders[4] = arrayProviders[4] + 1;
                        }
                        else{
                          filterProviders.remove('119');
                          arrayProviders[4] = arrayProviders[4] - 1;
                        }
                      });
                    },
                    child: const CardFilter(
                      image: 'assets/platform_icons/primeVideo.png',
                      text: 'PRIME VIDEO',
                    ),
                  ),
                ],
              ),
            ),
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
                  _platformScrollController.jumpTo(0);
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
                  _platformScrollController.jumpTo(0);
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
    );
  }

  Widget _buildGroupSelection() {
    return Column(
      key: const Key('group_selection'),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Selecciona como vas a hacer la búsqueda',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await fetchTopRatedMovies();
                    if (movies.isEmpty) {
                      print('No se encontraron películas.');
                    } else {
                      print('Se encontraron ${movies.length} películas.');
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterFilmScreen(
                            movies:movies,
                          )),
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
                          image: AssetImage('assets/icons/individual.png'),
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
    );
  }

  List<Movie> movies = [];

  Future<void> fetchTopRatedMovies() async {

    print('filterGenres: $filterGenres');
    print('filterProviders: $filterProviders');

    String url;
    if (filterGenres.isNotEmpty && filterProviders.isNotEmpty){
      String genreString = filterGenres.join('%2C');
      String providerString = filterProviders.join('%7C');
      url = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&include_adult=false&include_video=false&language=es-ES&page=1&region=ES&sort_by=popularity.desc&with_genres=$genreString&with_watch_providers=$providerString';
      print('llamada 1');
    }
    else if(filterGenres.isNotEmpty && filterProviders.isEmpty){
      String genreString = filterGenres.join('%2C');
      url = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&include_adult=false&include_video=false&language=es-ES&page=1&region=ES&sort_by=popularity.desc&with_genres=$genreString';
            print('llamada 2');
    }
    else if(filterGenres.isEmpty && filterProviders.isNotEmpty){
      
      String providerString = filterProviders.join('%7C');
      url = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&include_adult=false&include_video=false&language=es-ES&page=1&region=ES&sort_by=popularity.desc&with_watch_providers=$providerString';
            print('llamada 3');
    }
    else{
      url = 'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&include_adult=false&include_video=false&language=es-ES&page=1&region=ES&sort_by=popularity.desc';
      print('llamada 4');
    }

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var tempData = jsonDecode(response.body);
      var movieJson = tempData['results'];

      movies.clear(); // Limpiamos la lista de películas antes de llenarla nuevamente

      for (var movie in movieJson) {
        if (movie['id'] != null &&
            movie['poster_path'] != null &&
            movie['vote_average'] != null) {
          movies.add(Movie(
            id: movie['id'] ?? 0,
            title: movie['title'] ?? 'No title',
            posterPath: movie['poster_path'] ?? '',
            releaseDay: movie['release_date'] ?? 'Unknown',
            voteAverage: (movie['vote_average'] as num).toDouble(),
            // La información adicional la dejaremos en valores predeterminados
            mediaType: 'Movie',
            director: 'Unknown Director',
            duration: 0,
            genres: [],
            backDropPath: '',
            overview: 'No overview available',
            trailerUrl: '',
          ));
        }
      }
    } else {
      print('Error: No se pudo obtener la información');
    }
  }
}