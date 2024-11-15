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

  // Actualiza la lista de miembros directamente desde Firestore para evitar problemas de sincronización
  final updatedRoomSnapshot =
      await FirebaseFirestore.instance.collection('rooms').doc(room.id).get();
  final members = List<String>.from(updatedRoomSnapshot['members']);

  // Agregar al usuario a la sala si aún no es miembro
  if (!members.contains(user.uid)) {
    await room.reference.update({
      'members': FieldValue.arrayUnion([user.uid]),
    });
    print('Te has unido a la sala con código $code');
  } else {
    print('Ya eres miembro de esta sala.');
  }
}

Future<void> leaveRoom(String code) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception("El usuario no está autenticado");

  // Busca la sala por el código
  final querySnapshot = await FirebaseFirestore.instance
      .collection('rooms')
      .where('code', isEqualTo: code)
      .get();

  if (querySnapshot.docs.isEmpty) {
    throw Exception('No se encontró ninguna sala con ese código.');
  }

  final room = querySnapshot.docs.first;
  final roomId = room.id;

  // Verifica si el usuario está en la sala
  final members = List<String>.from(room['members']);
  if (!members.contains(user.uid)) {
    throw Exception('El usuario no es miembro de esta sala.');
  }

  // Elimina al usuario de la sala
  await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
    'members': FieldValue.arrayRemove([user.uid]),
  });

  print('El usuario ha salido de la sala.');

  // Si la sala queda vacía, elimínala automáticamente
  final updatedRoom =
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).get();
  final updatedMembers = List<String>.from(updatedRoom['members']);
  if (updatedMembers.isEmpty) {
    await updatedRoom.reference.delete();
    print('La sala estaba vacía y ha sido eliminada.');
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

/// Escucha la eliminación de una sala basada en su código
void listenToRoomDeletionByCode(
    String code, void Function() onRoomDeleted) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('rooms')
      .where('code', isEqualTo: code)
      .get();

  if (querySnapshot.docs.isEmpty) {
    print('No se encontró ninguna sala con el código: $code');
    return;
  }

  final roomId = querySnapshot.docs.first.id;

  listenToRoomDeletion(roomId, onRoomDeleted);
}

/// Escucha la eliminación de una sala basada en su ID
void listenToRoomDeletion(String roomId, void Function() onRoomDeleted) {
  final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);

  // Escucha cambios en el documento de la sala
  roomRef.snapshots().listen((snapshot) {
    if (!snapshot.exists) {
      // Si el documento ya no existe, se ejecuta el callback
      print('La sala ha sido eliminada.');
      onRoomDeleted();
    }
  });
}
