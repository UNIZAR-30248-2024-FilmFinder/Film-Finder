import 'package:flutter/material.dart';

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
            onPressed: () {
              print('Cuenta borrada');
              Navigator.of(context).pop();
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
