import 'package:film_finder/methods/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../widgets/profile_widget.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //ESTO TENDRA QUE SACARSE DE LA BASE DE DATOS
    const myUser = User(
        imagePath: '',
        name: 'Jorge',
        email: '845647@unizar.es',
        about:
            'Aqui irá la descripción que se quiera añadir el usuario a su perfil.',
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
                onClicked: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(
                              user: myUser,
                            )),
                  );
                },
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
            height: 25,
          ),
          const Center(
            child: Text(
              'Peliculas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(21, 4, 29, 1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color.fromRGBO(190, 49, 68, 1),
                width: 2,
              ),
            ),
            child: const IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                              fontSize: 26,
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
                      width: 25,
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
                              fontSize: 26,
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
                      width: 25,
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
                              fontSize: 26,
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '10 Estrellas',
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
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sobre mi:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 21),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  myUser.about,
                  style: const TextStyle(
                      height: 1.4, color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.book_outlined,
                size: 32,
                color: Color.fromRGBO(21, 4, 29, 1),
              ),
            ),
            title: const Text(
              'Ver diario',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16),
            ),
            trailing: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.star,
                color: Color.fromRGBO(21, 4, 29, 1),
                size: 32,
              ),
            ),
            title: const Text(
              'Ver lista de favoritos',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16),
            ),
            trailing: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ),
          const Divider(
            height: 35,
            indent: 75,
            endIndent: 75,
            color: Color.fromRGBO(190, 49, 68, 1),
          ),
          ListTile(
            onTap: () async {},
            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.exit_to_app,
                color: Color.fromRGBO(21, 4, 29, 1),
                size: 32,
              ),
            ),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(190, 49, 68, 1),
                  fontSize: 16),
            ),
            trailing: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
