import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

Future<String> generateUniqueRoomCode(int length) async {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();

  String generateCode() {
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  String code = "000000";
  bool isUnique = false;

  while (!isUnique) {
    code = generateCode();

    // Verifica en Firestore si el código ya existe
    final querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('code', isEqualTo: code)
        .get();

    if (querySnapshot.docs.isEmpty) {
      isUnique = true; // El código no está en uso, podemos usarlo
    }
  }

  return code; // Retorna un código único
}

Future<String> createRoom() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception("El usuario no está autenticado");

  // Espera el resultado del código único generado
  final code = await generateUniqueRoomCode(6);
  final roomId = FirebaseFirestore.instance.collection('rooms').doc().id;

  await FirebaseFirestore.instance.collection('rooms').doc(roomId).set({
    'admin': user.uid,
    'code': code,
    'createdAt': FieldValue.serverTimestamp(),
    'members': [user.uid],
  });

  print('Sala creada con éxito con código: $code');

  return code;
}

Future<void> joinRoom(String code) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception("El usuario no está autenticado");

  final querySnapshot = await FirebaseFirestore.instance
      .collection('rooms')
      .where('code', isEqualTo: code)
      .get();

  if (querySnapshot.docs.isEmpty) {
    throw Exception('No se encontró ninguna sala con ese código.');
  }

  final room = querySnapshot.docs.first;

  // Agregar al usuario a la sala si aún no es miembro
  final members = List<String>.from(room['members']);
  if (!members.contains(user.uid)) {
    await room.reference.update({
      'members': FieldValue.arrayUnion([user.uid]),
    });
    print('Te has unido a la sala ${room['name']}');
  } else {
    print('Ya eres miembro de esta sala');
  }
}

Future<void> deleteRoomByCode(String code) async {
  try {
    // Busca la sala por el código
    final querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('code', isEqualTo: code)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception(
          'No se encontró ninguna sala con el código proporcionado');
    }

    // Elimina cada documento encontrado (por si hay duplicados)
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print('Sala(s) eliminada(s) con éxito');
  } catch (e) {
    print('Error al eliminar la sala por código: $e');
    throw Exception('No se pudo eliminar la sala');
  }
}
