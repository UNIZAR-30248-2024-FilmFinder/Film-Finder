import 'package:flutter/material.dart';
import 'package:film_finder/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Color.fromRGBO(190, 49, 68, 1),
            width: 1.0,
          ),
        ),
        title: const Text(
          'Confirmar Borrado',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Está seguro de que desea borrar su cuenta? Todos sus datos se perderán.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.delete();
                  Navigator.of(context).pop(); // Cerrar el diálogo.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                }
              } catch (e) {
                print('Error al borrar la cuenta: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al borrar la cuenta: $e')),
                );
              }
            },
            child: const Text(
              'Borrar Cuenta',
              style: TextStyle(color: Color.fromRGBO(190, 49, 68, 1)),
            ),
          ),
        ],
      );
    },
  );
}
