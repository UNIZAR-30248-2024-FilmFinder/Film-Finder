import 'package:film_finder/pages/auth_pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:film_finder/widgets/profile_widgets/text_field_login_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUser(BuildContext context) async {
    try {
      // Verifica si los campos están vacíos
      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, rellena todos los campos'),
          ),
        );
        return; // Detiene la ejecución si faltan campos
      }

      // Muestra el diálogo de carga
      showLoadingDialog(context);

      // Realiza el inicio de sesión
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      // Cierra el diálogo de carga
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // Cierra el diálogo de carga en caso de error
      Navigator.of(context).pop();

      // Muestra un mensaje de error al usuario
      String errorMessage;
      if (e.code == 'invalid-email') {
        errorMessage = 'Correo no encontrado.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Contraseña incorrecta.';
      } else {
        errorMessage = 'Error al iniciar sesión';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      // Cierra el diálogo de carga en caso de errores no esperados
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error inesperado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                    "Iniciando sesión...",
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

  Future<UserCredential?> loginwithGoogle(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn();

      // Cerrar la sesión anterior de Google si existe.
      await googleSignIn.signOut();
      final googleUser = await GoogleSignIn().signIn();

      // Muestra el diálogo de carga
      showLoadingDialog(context);

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión.
        Navigator.of(context).pop(); // Cierra el diálogo de carga.
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(cred);

      // Almacenar datos adicionales si es un nuevo usuario.
      if (userCredential.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': googleUser.displayName ?? 'Usuario de Google',
          'email': googleUser.email,
          'imagePath': googleUser.photoUrl ?? '',
          'about': '---',
          'location': '---',
        });
      }

      // Cierra el diálogo de carga antes de redirigir.
      Navigator.of(context).pop();

      // Redirigir a la pantalla principal.
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PrincipalScreen()),
      );

      return userCredential;
    } catch (e) {
      // Cierra el diálogo de carga en caso de error.
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      print("Error durante el inicio de sesión con Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error en el inicio de sesión con Google")),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la altura de la barra de estado
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: statusBarHeight + 50),
          SizedBox(
            width: 150.0,
            height: 150.0,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcATop,
              ),
              child: Image.asset(
                'assets/images/app_icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 50),
          const Text(
            'INICIAR SESIÓN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          const SizedBox(height: 20),
          MyTextField(
            controller: usernameController,
            hintText: 'Correo electrónico',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          MyTextField(
            controller: passwordController,
            hintText: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: RichText(
              text: const TextSpan(
                text: '¿No tienes una cuenta? ',
                style: TextStyle(
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'Regístrate aquí',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              signUser(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: const BorderSide(
                  color: Color.fromRGBO(190, 49, 68, 1),
                  width: 1.0,
                ),
              ),
              fixedSize: const Size(190, 50),
            ),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'O continuar con',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Ink(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(21, 4, 29, 1),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: const Color.fromRGBO(190, 49, 68, 1),
                width: 1.0,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              splashColor:
                  Colors.white.withOpacity(0.2), // Color del efecto de onda
              highlightColor: Colors.transparent, // Evita el resaltado de fondo
              onTap: () {
                loginwithGoogle(context);
                // Acción al tocar el botón
              },
              child: Container(
                width: 250,
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'assets/images/google_icon.png',
                        width: 30.0,
                        height: 30.0,
                      ),
                    ),
                    const Text(
                      'Continuar con Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
