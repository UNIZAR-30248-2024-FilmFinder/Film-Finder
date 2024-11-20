import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:film_finder/pages/menu_pages/initial_screen.dart';
import 'package:film_finder/pages/menu_pages/explore_screen.dart';
import 'package:film_finder/pages/profile_pages/friends_screen.dart';
import 'package:film_finder/pages/profile_pages/profile_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    InitialScreen(),
    ExploreScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(21, 4, 29, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: GNav(
            backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromRGBO(34, 9, 44, 1),
            gap: 8,
            onTabChange: _onItemTapped,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Inicio',
                key: Key('init_button'),
              ),
              GButton(
                icon: Icons.search,
                text: 'Explorar',
                key: Key('explore_button'),
              ),
              GButton(
                icon: Icons.add_reaction,
                text: 'Amigos',
                key: Key('friends_button'),
              ),
              GButton(
                icon: Icons.person,
                text: 'Perfil',
                key: Key('profile_button'),
              ),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
