import 'package:film_finder/pages/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:film_finder/pages/principal_screen.dart';
import 'package:film_finder/widgets/text_field_login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LogIn extends StatelessWidget {
  LogIn({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text, password: passwordController.text);
  }

  Future<UserCredential?> loginwithGoogle(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión.
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(cred);

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
      // Redirigir a la pantalla principal.
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PrincipalScreen()),
      );
      return userCredential;
    } catch (e) {
      print("Error durante el inicio de sesión con Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error en el inicio de sesión con Google")),
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
            onPressed: signUser,
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
