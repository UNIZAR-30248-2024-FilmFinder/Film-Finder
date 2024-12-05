import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/widgets/profile_widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DiaryFilm extends StatefulWidget {
  final Movie movie;

  const DiaryFilm({super.key, required this.movie});

  @override
  // ignore: library_private_types_in_public_api
  _DiaryFilmState createState() => _DiaryFilmState();
}

class _DiaryFilmState extends State<DiaryFilm> {
  late DateTime selectedDate;

  late double finalRating = 0;

  late TextEditingController reviewController;

  late bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    reviewController = TextEditingController(text: "");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
        title: const Text(
          "Añadir película al diario",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
                      'https://image.tmdb.org/t/p/original${widget.movie.posterPath}',
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
                                widget.movie.title,
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
                                widget.movie.title,
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
                            '${DateTime.parse(widget.movie.releaseDay).year}',
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
                      initialRating: 0,
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
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: isFavourite
                              ? const Color.fromRGBO(190, 49, 68, 1)
                              : const Color.fromRGBO(190, 49, 68, 1),
                          size: 30,
                        ),
                      ),
                    ],
                  )),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //COMPROBAR QUE LA CRITICA NO ES MUY LARGA Y SE HA AÑADIDO VALORIACIÓN
                    print(
                        "Película: ${widget.movie.title}, Fecha seleccionada: ${DateFormat('yyyy-MM-dd').format(selectedDate)}");
                    Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
