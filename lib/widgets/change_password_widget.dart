import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordDialog extends StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
        'Cambiar Contraseña',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Antigua Contraseña',
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(190, 49, 68, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(190, 49, 68, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Confirmar Nueva Contraseña',
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(190, 49, 68, 1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
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
            if (newPasswordController.text == confirmPasswordController.text) {
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Obtener credenciales con la contraseña antigua
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: oldPasswordController.text,
                  );

                  // Re-autenticar al usuario
                  await user.reauthenticateWithCredential(credential);

                  // Actualizar la contraseña
                  await user.updatePassword(newPasswordController.text);

                  // Mostrar mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contraseña actualizada correctamente.')),
                  );
                  Navigator.of(context).pop();
                }
              } catch (e) {
                // Manejar errores, como credenciales incorrectas
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Las contraseñas no coinciden.')),
              );
            }
          },
          child: const Text(
            'Cambiar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
