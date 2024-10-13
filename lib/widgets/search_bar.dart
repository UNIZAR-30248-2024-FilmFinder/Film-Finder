import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:film_finder/pages/film_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart';

import '../movie.dart';
import 'package:http/http.dart' as http;

class SearchingBar extends StatefulWidget {
  const SearchingBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchingBarState createState() => _SearchingBarState();
}

class _SearchingBarState extends State<SearchingBar> {
  List<Map<String, dynamic>> searchResult = [];

  final TextEditingController searchText = TextEditingController();

  var val1;
  List<Movie> movies = [];
  bool showList = false;

  //FUNCION CON LA QUE SE EXRTRAERAN LOS DATOS DE LA API
  Future<void> searchListFunction(String val) async {
    // Simulación de búsqueda
    String searchMovie = 'https://api.themoviedb.org/3/search/movie?query=$val&include_adult=false&language=en-US&page=1&api_key=c5147b4f6bccd1f46f693db2fb007b78';
    final response = await http.get(Uri.parse(searchMovie));
      if(response.statusCode == 200){
        final decodedData = json.decode(response.body)['results'] as List;
        movies = decodedData.map((movie) => Movie.fromJson(movie)).toList();
      }
      else{
        throw Exception('Something happened');
      }
      print(movies.length);
    for (var i = 0; i < movies.length; i++) {
      searchResult.add({
        'title': movies[i].title,
        'poster_path': movies[i].posterPath,
        'rating': movies[i].voteAverage,
      });
    }

    if (searchResult.length > 20) {
      searchResult.removeRange(20, searchResult.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showList != showList;
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                autofocus: false,
                controller: searchText,
                onSubmitted: (value) {
                  searchResult.clear();

                  setState(
                    () {
                      val1 = value;
                    },
                  );
                },
                onChanged: (value) {
                  setState(
                    () {
                      searchResult.clear();

                      setState(
                        () {
                          val1 = value;
                        },
                      );
                    },
                  );
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        webBgColor: "#000000",
                        webPosition: "center",
                        webShowClose: true,
                        msg: "Búsqueda borrada",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                        textColor: Colors.white,
                        fontSize: 16,
                      );
                      setState(() {
                        searchText.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color:
                          const Color.fromRGBO(190, 49, 68, 1).withOpacity(0.6),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromRGBO(190, 49, 68, 1),
                  ),
                  hintText: 'Buscar Película',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            if (searchText.text.length > 0)
              FutureBuilder(
                  future: searchListFunction(val1),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        height: 400,
                        child: ListView.builder(
                          itemCount: searchResult.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            String posterUrl = 'https://image.tmdb.org/t/p/w500${searchResult[index]['poster_path']}';
                            return GestureDetector(
                              //Envío a la descripción
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FilmInfo(film: "Interstellar")),
                                );
                                setState(() {
                                  searchText.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(21, 4, 29, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        //POSTER DE LA PELI
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              posterUrl,
                                            ),
                                            fit: BoxFit.cover
                                            //fit: BoxFit.cover,
                                          ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(190, 49, 68, 1),
                        ),
                      );
                    }
                  })
          ],
        ),
      ),
    );
  }
}
