import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomPopup extends StatelessWidget {
  const RoomPopup({super.key, required this.code, required this.isAdmin});

  final int code;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    void showExitConfirmation(BuildContext context, bool isAdmin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Confirmación',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const Divider(
                    color: Color.fromRGBO(190, 49, 68, 1),
                    thickness: 2.0,
                    height: 20.0,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    isAdmin
                        ? '¿Seguro que quieres salir de la sala? \n Esto borrará la sala.'
                        : '¿Seguro que quieres salir de la sala?',
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Cerrar el diálogo de confirmación
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(190, 49, 68, 1),
                              width: 1.0,
                            ),
                          ),
                          fixedSize: const Size(115, 42),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Cerrar el diálogo de confirmación
                          Navigator.of(context)
                              .pop(); // Cerrar el popup principal
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(190, 49, 68, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Color.fromRGBO(190, 49, 68, 1),
                              width: 1.0,
                            ),
                          ),
                          fixedSize: const Size(115, 42),
                        ),
                        child: const Text(
                          'Salir',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sala del Grupo',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15.0),
            const Divider(
              color: Color.fromRGBO(190, 49, 68, 1),
              thickness: 2.0,
              height: 20.0,
            ),
            const SizedBox(height: 5.0),
            Column(
              children: [
                const Text(
                  'Código de la sala',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12.0),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code.toString()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(34, 9, 44, 1),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color.fromRGBO(190, 49, 68, 1),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      code.toString(),
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            const Divider(
              color: Color.fromRGBO(190, 49, 68, 1),
              thickness: 2.0,
              height: 20.0,
            ),
            const SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Miembros del grupo',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                ...List.generate(4, (index) {
                  return Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 10.0),
                      Text(
                        'Usuario ${index + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 48.0,
                  height: 48.0,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(34, 9, 44, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                        color: Color.fromRGBO(190, 49, 68, 1),
                        width: 1.0,
                      ),
                    ),
                    fixedSize: const Size(115, 42),
                  ),
                  child: const Text(
                    'Comenzar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showExitConfirmation(context, isAdmin);
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    size: 33,
                  ),
                  color: const Color.fromRGBO(190, 49, 68, 1),
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
