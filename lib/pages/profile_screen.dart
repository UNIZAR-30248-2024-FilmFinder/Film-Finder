import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/profile_widget.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;
  Map<String, dynamic>? userData;
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Verificar si el usuario ha iniciado sesión con Google
      if (user.providerData
          .any((provider) => provider.providerId == 'google.com')) {
        data ??= {};
        data['imagePath'] = user.photoURL;
      }
      setState(() {
        userData = data;
      });
    } catch (e) {
      print("Error al cargar los datos del usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 35),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 35),
              ProfileWidget(
                imagePath: userData!['imagePath'] ?? '',
                onClicked: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(user: userData!),
                    ),
                  );

                  // Verifica el resultado y actualiza la página si es necesario
                  if (result == true) {
                    setState(() {
                      _loadUserData();
                    });
                  }
                },
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData!['name'] ?? 'Nombre no disponible',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userData!['location'] ?? 'Ubicación no disponible',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email ?? 'Correo no disponible',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 179, 178, 178),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
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
          const SizedBox(height: 15),
          // Contenedor de estadísticas de películas
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
                    _MovieStatColumn(label: 'Vistas', count: 'XXXX'),
                    _MovieDivider(),
                    _MovieStatColumn(label: 'Favoritas', count: 'XXXX'),
                    _MovieDivider(),
                    _MovieStatColumn(label: '10 Estrellas', count: 'XXXX'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
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
                const SizedBox(height: 10),
                Text(
                  userData!['about'] ?? 'Sin descripción',
                  style: const TextStyle(
                      height: 1.4, color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          _ProfileOptionTile(
            icon: Icons.book_outlined,
            label: 'Ver diario',
            onTap: () {},
          ),
          _ProfileOptionTile(
            icon: Icons.star,
            label: 'Ver lista de favoritos',
            onTap: () {},
          ),
          const Divider(
            height: 35,
            indent: 75,
            endIndent: 75,
            color: Color.fromRGBO(190, 49, 68, 1),
          ),
          _ProfileOptionTile(
            icon: Icons.exit_to_app,
            label: 'Cerrar sesión',
            color: const Color.fromRGBO(190, 49, 68, 1),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}

class _MovieStatColumn extends StatelessWidget {
  final String label;
  final String count;

  const _MovieStatColumn({
    Key? key,
    required this.label,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieDivider extends StatelessWidget {
  const _MovieDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 35,
      width: 25,
      child: VerticalDivider(
        thickness: 1.5,
        color: Color.fromRGBO(190, 49, 68, 1),
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ProfileOptionTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 35),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color.withOpacity(0.2),
        ),
        child: Icon(icon, size: 32, color: color),
      ),
      title: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
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
    );
  }
}
