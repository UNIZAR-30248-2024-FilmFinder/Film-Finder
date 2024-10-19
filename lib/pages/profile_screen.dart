import 'package:film_finder/methods/user.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const myUser = User(
        imagePath: 'assets/images/example_poster.jpg',
        name: 'Jorge',
        email: '845647@unizar.es',
        about: 'about',
        location: 'España, Zaragoza');

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 35,
              ),
              ProfileWidget(
                imagePath: myUser.imagePath,
                onClicked: () async {},
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myUser.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 26),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    myUser.location,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    myUser.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 179, 178, 178),
                        fontSize: 15),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 35,
          ),
          const Center(
            child: Text(
              'Peliculas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 27,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'XXXX',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 29,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Vistas',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: 50,
                    child: VerticalDivider(
                      thickness: 1.5,
                      color: Color.fromRGBO(190, 49, 68, 1),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'XXXX',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 29,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Favoritas',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: 50,
                    child: VerticalDivider(
                      thickness: 1.5,
                      color: Color.fromRGBO(190, 49, 68, 1),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'XXXX',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 29,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          '5 Estrellas',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
