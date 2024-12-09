import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:film_finder/pages/profile_pages/diary_screen.dart';
import 'package:film_finder/widgets/profile_widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class DiaryFilm extends StatefulWidget {
  final int movieId;

  final String posterPath;

  final String title;

  final String releaseDay;

  final bool isEditing;

  final String editDate;

  final String editReview;

  final double editRating;

  final String documentId;

  const DiaryFilm(
      {super.key,
      required this.movieId,
      required this.posterPath,
      required this.releaseDay,
      required this.title,
      required this.isEditing,
      required this.editDate,
      required this.editRating,
      required this.editReview,
      required this.documentId});

  @override
  // ignore: library_private_types_in_public_api
  _DiaryFilmState createState() => _DiaryFilmState();
}

class _DiaryFilmState extends State<DiaryFilm> {
  late DateTime selectedDate;

  late double finalRating = 0;

  late TextEditingController reviewController;

  late bool isFavourite = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();

    if (widget.isEditing) {
      reviewController = TextEditingController(text: widget.editReview);
      selectedDate = DateTime.parse(widget.editDate);
      finalRating = widget.editRating;
    } else {
      reviewController = TextEditingController(text: "");
      selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromRGBO(190, 49, 68, 1),
              onPrimary: Colors.white,
              surface: Color.fromRGBO(34, 9, 44, 1),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color.fromRGBO(34, 9, 44, 1),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveToDiary() async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      await FirebaseFirestore.instance.collection('diary').add({
        'userId': user.uid,
        'movieId': widget.movieId,
        'viewingDate': DateFormat('yyyy-MM-dd').format(selectedDate),
        'review': reviewController.text,
        'rating': finalRating,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PrincipalScreen(),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
    }
  }

  Future<void> _updateDiaryEntry(String documentId) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      if (documentId.isEmpty) {
        throw Exception("El ID del documento no puede estar vacío");
      }

      await FirebaseFirestore.instance
          .collection('diary')
          .doc(documentId)
          .update({
        'viewingDate': DateFormat('yyyy-MM-dd').format(selectedDate),
        'review': reviewController.text,
        'rating': finalRating,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      List<MovieDiaryEntry> movieDiary = [];

      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          final diarySnapshot = await FirebaseFirestore.instance
              .collection('diary')
              .where('userId', isEqualTo: userId)
              .get();

          movieDiary = diarySnapshot.docs.map((doc) {
            final data = doc.data();
            return MovieDiaryEntry(
              documentId: doc.id,
              movieId: data['movieId'] ?? 0,
              viewingDate: data['viewingDate'] ?? '',
              personalRating: (data['rating'] ?? 0).toDouble(),
              review: data['review'] ?? '',
            );
          }).toList();
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Diary(
              movies: movieDiary,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el diario: $e'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al actualizar la entrada del diario'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
    }
  }

  Future<void> _deleteDiaryEntry(String documentId) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuario no autenticado");
      }

      if (documentId.isEmpty) {
        throw Exception("El ID del documento no puede estar vacío");
      }

      await FirebaseFirestore.instance
          .collection('diary')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrada del diario eliminada con éxito'),
          duration: Duration(seconds: 3),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );

      List<MovieDiaryEntry> movieDiary = [];

      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          final diarySnapshot = await FirebaseFirestore.instance
              .collection('diary')
              .where('userId', isEqualTo: userId)
              .get();

          movieDiary = diarySnapshot.docs.map((doc) {
            final data = doc.data();
            return MovieDiaryEntry(
              documentId: doc.id,
              movieId: data['movieId'] ?? 0,
              viewingDate: data['viewingDate'] ?? '',
              personalRating: (data['rating'] ?? 0).toDouble(),
              review: data['review'] ?? '',
            );
          }).toList();
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Diary(
              movies: movieDiary,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el diario: $e'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la entrada del diario'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("El usuario no está autenticado.");
      }

      final String userId = user.uid;

      final DocumentReference userFavoritesRef =
          _firestore.collection('favorites').doc(userId);

      final DocumentSnapshot snapshot = await userFavoritesRef.get();

      if (snapshot.exists) {
        final List<dynamic> favoriteMovies = snapshot['movieIds'] ?? [];
        if (favoriteMovies.contains(widget.movieId)) {
          setState(() {
            isFavourite = true;
          });
        }
      }
    } catch (e) {
      print('Error al verificar favoritos: $e');
    }
  }

  Future<void> _updateFavorite(bool shouldAdd) async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("El usuario no está autenticado.");
      }

      final String userId = user.uid;

      final DocumentReference userFavoritesRef =
          _firestore.collection('favorites').doc(userId);

      final DocumentSnapshot snapshot = await userFavoritesRef.get();

      if (snapshot.exists) {
        List<dynamic> favoriteMovies = snapshot['movieIds'] ?? [];

        if (shouldAdd) {
          if (!favoriteMovies.contains(widget.movieId)) {
            favoriteMovies.add(widget.movieId);
            setState(() {
              isFavourite = true;
            });
            print('Película añadida a favoritos.');
          }
        } else {
          if (favoriteMovies.contains(widget.movieId)) {
            favoriteMovies.remove(widget.movieId);
            setState(() {
              isFavourite = false;
            });
            print('Película eliminada de favoritos.');
          }
        }

        await userFavoritesRef.update({'movieIds': favoriteMovies});
      } else if (shouldAdd) {
        await userFavoritesRef.set({
          'movieIds': [widget.movieId],
        });
        setState(() {
          isFavourite = true;
        });
        print('Película añadida a favoritos.');
      }
    } catch (e) {
      print('Error al manejar favoritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
          title: const Text(
            "Añadir película al diario",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              Navigator.pop(context);
            },
          ),
          actions: [
            if (widget.isEditing)
              PopupMenuButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromRGBO(190, 49, 68, 1),
                ),
                color: const Color.fromRGBO(190, 49, 68, 1),
                onSelected: (value) {
                  if (value == 'delete') {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();

                    _deleteDiaryEntry(widget.documentId);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      "Borrar entrada del diario",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/original${widget.posterPath}',
                        filterQuality: FilterQuality.high,
                        height: 130,
                        width: 130,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 3
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Text(
                              '${DateTime.parse(widget.releaseDay).year}',
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
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
                const Divider(
                  color: Color.fromRGBO(190, 49, 68, 1),
                  thickness: 1,
                  endIndent: 50,
                  indent: 50,
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      const Text(
                        "Fecha: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(21, 4, 29, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromRGBO(190, 49, 68, 1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFieldWidget(
                    label: 'Crítica:',
                    text: reviewController.text,
                    maxLines: 4,
                    onChanged: (value) =>
                        setState(() => reviewController.text = value),
                    controller: reviewController,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      const Text(
                        "Valoración: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      RatingBar.builder(
                        initialRating: widget.editRating / 2,
                        minRating: 0.5,
                        allowHalfRating: true,
                        itemSize: 40.0,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          finalRating = rating * 2;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        const Text(
                          "Añadir a favoritos: ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFavourite = !isFavourite;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: const BorderSide(
                                color: Color.fromRGBO(190, 49, 68, 1),
                                width: 1.0,
                              ),
                            ),
                            fixedSize: const Size(50, 50),
                          ),
                          child: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavourite
                                ? const Color.fromRGBO(190, 49, 68, 1)
                                : const Color.fromRGBO(190, 49, 68, 1),
                            size: 30,
                          ),
                        ),
                      ],
                    )),
                const Spacer(),
                if (!widget.isEditing)
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (finalRating == 0) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, añade una valoración'),
                              duration: Duration(days: 1),
                              backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                            ),
                          );
                          return;
                        }

                        if (reviewController.text.length >= 1000) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'La crítica tiene que tener menos de 1000 caracteres'),
                              duration: Duration(days: 1),
                              backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                            ),
                          );
                          return;
                        }

                        await _saveToDiary();
                        await _updateFavorite(isFavourite);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(190, 49, 68, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Añadir al diario",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                if (widget.isEditing)
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (finalRating == 0) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, añade una valoración'),
                              duration: Duration(days: 1),
                              backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                            ),
                          );
                          return;
                        }

                        if (reviewController.text.length >= 1000) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'La crítica tiene que tener menos de 1000 caracteres'),
                              duration: Duration(days: 1),
                              backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                            ),
                          );
                          return;
                        }

                        _updateDiaryEntry(widget.documentId);
                        await _updateFavorite(isFavourite);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                            color: Color.fromRGBO(190, 49, 68, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Guardar cambio",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
