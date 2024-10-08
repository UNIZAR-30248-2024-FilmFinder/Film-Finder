import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:film_finder/pages/initial_screen.dart';
import 'package:film_finder/pages/explore_screen.dart';
import 'package:film_finder/pages/friends_screen.dart';
import 'package:film_finder/pages/profile_screen.dart';

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
              ),
              GButton(
                icon: Icons.search,
                text: 'Explorar',
              ),
              GButton(
                icon: Icons.add_reaction,
                text: 'Amigos',
              ),
              GButton(
                icon: Icons.person,
                text: 'Perfil',
              ),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
