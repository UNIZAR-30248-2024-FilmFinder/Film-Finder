import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(21, 4, 29, 1),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: const Color.fromRGBO(190, 49, 68, 1),
                width: 2.0,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(190, 49, 68, 1)),
                ),
                SizedBox(width: 20),
                Text(
                  "Borrando cuenta...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

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
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
                  if (user.providerData
                      .any((info) => info.providerId == 'password')) {
                    // Reautenticación con correo y contraseña
                    String? password = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        String enteredPassword = '';
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
                            'Confirma tu contraseña',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: TextField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              enteredPassword = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(null),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(enteredPassword),
                              child: const Text(
                                'Confirmar',
                                style: TextStyle(
                                    color: Color.fromRGBO(190, 49, 68, 1)),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    // Si el usuario cancela, detén el proceso
                    if (password == null || password.isEmpty) {
                      return;
                    }

                    // Reautenticación para correo y contraseña
                    final credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: password,
                    );

                    await user.reauthenticateWithCredential(credential);
                  } else if (user.providerData
                      .any((info) => info.providerId == 'google.com')) {
                    // Reautenticación con Google usando el flujo proporcionado
                    try {
                      final googleSignIn = GoogleSignIn();

                      // Cerrar la sesión anterior de Google si existe
                      await googleSignIn.signOut();
                      final googleUser = await googleSignIn.signIn();

                      if (googleUser == null) {
                        // El usuario canceló el inicio de sesión.
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reautenticación cancelada.'),
                            duration: Duration(days: 1),
                            backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                          ),
                        );
                        return;
                      }

                      // Verifica que el correo de Google coincida con el del usuario actual
                      if (googleUser.email != user.email) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Por favor, usa la misma cuenta de Google.'),
                            duration: Duration(days: 1),
                            backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                          ),
                        );
                        return;
                      }

                      final googleAuth = await googleUser.authentication;

                      final credential = GoogleAuthProvider.credential(
                        idToken: googleAuth.idToken,
                        accessToken: googleAuth.accessToken,
                      );

                      // Reautenticar al usuario con las credenciales de Google
                      await user.reauthenticateWithCredential(credential);
                    } catch (e) {
                      print('Error reautenticando con Google: $e');
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error reautenticando con Google'),
                          duration: Duration(days: 1),
                          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                        ),
                      );
                      return;
                    }
                  }

                  // Muestra el diálogo de carga
                  showLoadingDialog(context);

                  // Eliminar el documento del usuario en Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .delete();
                  } catch (e) {
                    Navigator.of(context).pop();
                    print(
                        'Error al eliminar el documento del usuario en Firestore: $e');
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Error al eliminar la información del usuario.'),
                        duration: Duration(days: 1),
                        backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).removeCurrentSnackBar();

                  // Eliminar la cuenta después de reautenticarse
                  await user.delete();
                  Navigator.of(context).pop();

                  // Navegar a la página de autenticación
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                  Navigator.of(context).pushReplacementNamed('/');
                }
              } catch (e) {
                print('Error al borrar la cuenta: $e');
                ScaffoldMessenger.of(context).removeCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al borrar la cuenta'),
                    duration: Duration(days: 1),
                    backgroundColor: Color.fromRGBO(21, 4, 29, 1),
                  ),
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
