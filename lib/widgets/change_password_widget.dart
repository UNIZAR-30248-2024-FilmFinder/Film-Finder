import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                  "Cambiando contraseña...",
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

class ChangePasswordDialog extends StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
              if (newPasswordController.text.length >= 6) {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Muestra el diálogo de carga
                    showLoadingDialog(context);

                    // Obtener credenciales con la contraseña antigua
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: oldPasswordController.text,
                    );

                    // Re-autenticar al usuario
                    await user.reauthenticateWithCredential(credential);

                    // Actualizar la contraseña
                    await user.updatePassword(newPasswordController.text);

                    Navigator.of(context).pop(); // Cerrar el cuadro de diálo

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Contraseña actualizada correctamente.')),
                    );
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálo

                  // Manejar errores, como credenciales incorrectas
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Error al cambiar la contraseña')),
                  );
                }
              } else {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálo

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'La contraseña debe tener al menos seis caracteres')),
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
