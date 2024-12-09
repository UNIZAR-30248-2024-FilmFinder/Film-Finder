// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_finder/methods/movie.dart';
import 'package:film_finder/pages/profile_pages/diary_screen.dart';
import 'package:film_finder/pages/profile_pages/favorites_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/profile_widgets/profile_widget.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  Future<Map<String, int>> fetchMovieStatistics() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not authenticated");

      final diarySnapshot = await FirebaseFirestore.instance
          .collection('diary')
          .where('userId', isEqualTo: user.uid)
          .get();

      final totalViews = diarySnapshot.docs.length;
      final rating10Count = diarySnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        return data != null && data['rating'] == 10;
      }).length;

      final favoritesSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .get();

      final favoriteMoviesCount = (favoritesSnapshot.exists
              ? (favoritesSnapshot.data()?['movieIds'] as List<dynamic>)
              : [])
          .length;

      return {
        'totalViews': totalViews,
        'rating10Count': rating10Count,
        'favoriteCount': favoriteMoviesCount,
      };
    } catch (e) {
      print("Error fetching movie stats: $e");
      return {'totalViews': 0, 'rating10Count': 0, 'favoriteCount': 0};
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
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData!['name'] ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userData!['location'] ?? 'Ubicación no disponible',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email ?? 'Correo no disponible',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 179, 178, 178),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
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
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder<Map<String, int>>(
                  future: fetchMovieStatistics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final stats = snapshot.data ??
                        {
                          'totalViews': 0,
                          'rating10Count': 0,
                          'favoriteCount': 0
                        };
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MovieStatColumn(
                            label: 'Vistas',
                            count: stats['totalViews'].toString()),
                        const _MovieDivider(),
                        _MovieStatColumn(
                            label: 'Favoritas',
                            count: stats['favoriteCount'].toString()),
                        const _MovieDivider(),
                        _MovieStatColumn(
                            label: '10 Estrellas',
                            count: stats['rating10Count'].toString()),
                      ],
                    );
                  },
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
            onTap: () async {
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
                // Manejo de errores
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al cargar el diario: $e'),
                  ),
                );
              }
            },
          ),
          _ProfileOptionTile(
            icon: Icons.star,
            label: 'Ver lista de favoritos',
            onTap: () async {
              List<int> favoriteMovieIds = [];

              try {
                final userId = FirebaseAuth.instance.currentUser?.uid;

                if (userId != null) {
                  final docSnapshot = await FirebaseFirestore.instance
                      .collection('favorites')
                      .doc(userId)
                      .get();

                  if (docSnapshot.exists) {
                    final data = docSnapshot.data();
                    favoriteMovieIds = List<int>.from(data?['movieIds'] ?? []);
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(
                      movieIds: favoriteMovieIds,
                    ),
                  ),
                );
              } catch (e) {
                // Manejo de errores
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al cargar las favoritas: $e'),
                  ),
                );
              }
            },
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
        style: const TextStyle(
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
