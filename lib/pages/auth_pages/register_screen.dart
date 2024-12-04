import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:film_finder/widgets/profile_widgets/text_field_login_widget.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

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
                    "Creando la cuenta...",
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

  Future<void> validateAndRegister(BuildContext context) async {
    String password = passwordController.text;
    String confirmPassword = confirmpasswordController.text;
    String email = emailController.text;
    String name = nameController.text;

    if (password.isEmpty ||
        confirmPassword.isEmpty ||
        email.isEmpty ||
        name.isEmpty) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, rellena todos los campos.'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres.'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
      return;
    }

    if (name.length > 20) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre no puede tener más de 20 caracteres'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
      return;
    }

    // Llama a la función de registro si las contraseñas coinciden
    await registerUser(context);
  }

  Future<void> registerUser(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String name = nameController.text;
    // Añadir lógica para obtener el path de la imagen
    String imagePath = '';
    String about = '---';
    String location = '---';

    try {
      // Muestra el diálogo de carga
      showLoadingDialog(context);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Almacenar datos adicionales en Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'imagePath': imagePath,
        'about': about,
        'location': location,
      });

      // Cierra el diálogo de carga antes de redirigir
      Navigator.of(context).pop();

      // Redirigir a la pantalla principal después del registro
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PrincipalScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Cierra el diálogo de carga en caso de error
      Navigator.of(context).pop();

      // Maneja errores específicos de FirebaseAuth
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'El correo ya está en uso.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'El correo no es válido.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'La contraseña es demasiado débil.';
      } else {
        errorMessage = 'Error desconocido al registrar';
      }

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(days: 1),
          backgroundColor: const Color.fromRGBO(21, 4, 29, 1),
        ),
      );
    } catch (e) {
      // Cierra el diálogo de carga en caso de error
      Navigator.of(context).pop();

      // Maneja otros errores inesperados
      print("Error durante el registro: $e");

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error inesperado'),
          duration: Duration(days: 1),
          backgroundColor: Color.fromRGBO(21, 4, 29, 1),
        ),
      );
    }
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
            'CREAR UNA CUENTA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
          const SizedBox(height: 20),
          MyTextField(
            controller: nameController,
            hintText: 'Nombre de usuario',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          MyTextField(
            controller: emailController,
            hintText: 'Correo electrónico',
            obscureText: false,
          ),
          const SizedBox(height: 15),
          MyTextField(
            controller: passwordController,
            hintText: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 15),
          MyTextField(
            controller: confirmpasswordController,
            hintText: 'Repetir contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 5),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: RichText(
              text: const TextSpan(
                text: '¿Ya tienes cuenta? ',
                style: TextStyle(
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'Inicia sesión aquí',
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
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              validateAndRegister(context);
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
              'Registrarse',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
