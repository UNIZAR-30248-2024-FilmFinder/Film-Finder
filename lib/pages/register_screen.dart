import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_finder/pages/principal_screen.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  void registerUser(BuildContext context) async {
    String email = emailController.text; // Supongo que usernameController es el email
    String password = passwordController.text; // Y passwordController es la contraseña
    String name = nameController.text; // Supongamos que tienes un controlador para el nombre
    String imagePath = 'path/to/image'; // Añade la lógica para obtener el imagePath
    String about = aboutController.text; // Añade un controlador para el campo "acerca de"
    String location = locationController.text; // Añade un controlador para la ubicación

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Almacenar datos adicionales en Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'imagePath': imagePath,
        'about': about,
        'location': location,
      });

      // Redirigir a la pantalla principal después del registro
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PrincipalScreen()),
      );

    } catch (e) {
      // Muestra un mensaje de error
      print("Error durante el registro: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error durante el registro: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Registrar Usuario',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const Spacer(),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Nombre completo',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Correo electrónico',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Contraseña',
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                hintText: 'Ubicación',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: aboutController,
              decoration: const InputDecoration(
                hintText: 'Acerca de mí',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => registerUser(context),
              child: const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
