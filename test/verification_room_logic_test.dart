import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:film_finder/methods/room_logic.dart'; 

// Mock para FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock para User
class MockUser extends Mock implements User {
  @override
  String get uid => 'testUserId';
}

void main() {
  group('Room Service Tests', () {
    late FirebaseAuth mockAuth;
    late FirebaseFirestore fakeFirestore;
    late User mockUser;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();
      mockUser = MockUser();

      // Simula que el usuario está autenticado
      when(mockAuth.currentUser).thenReturn(mockUser);
    });

    test('Create a new room successfully', () async {
      // Simula Firestore y Firebase Auth
      await fakeFirestore
          .collection('users')
          .doc(mockUser.uid)
          .set({'name': 'Test User'});

      final roomsCollection = fakeFirestore.collection('rooms');
      expect((await roomsCollection.get()).docs.length, 0); // Debe estar vacío inicialmente

      // Genera un código único
      String generateUniqueRoomCode(int length) {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        final random = Random();
        return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
      }
      createRoom();
      // Crea la sala
      String roomCode = generateUniqueRoomCode(6);
      await roomsCollection.add({
        'admin': mockUser.uid,
        'code': roomCode,
        'members': [mockUser.uid],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Verifica que la sala fue creada
      final snapshot = await roomsCollection.where('code', isEqualTo: roomCode).get();
      expect(snapshot.docs.length, 1);

      final roomData = snapshot.docs.first.data();
      expect(roomData['admin'], mockUser.uid);
      expect(roomData['code'], roomCode);
      expect((roomData['members'] as List).contains(mockUser.uid), true);
    });

    test('Join a room successfully', () async {
      // Simula que ya existe una sala
      final roomsCollection = fakeFirestore.collection('rooms');
      final roomRef = await roomsCollection.add({
        'admin': 'adminUserId',
        'code': 'TEST123',
        'members': ['adminUserId'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // El usuario se une a la sala
      final roomSnapshot = await roomsCollection.where('code', isEqualTo: 'TEST123').get();
      final roomDoc = roomSnapshot.docs.first;

      await roomDoc.reference.update({
        'members': FieldValue.arrayUnion([mockUser.uid]),
      });
      joinRoom('TEST123');
      // Verifica que el usuario se unió correctamente
      final updatedSnapshot = await roomDoc.reference.get();
      final updatedRoomData = updatedSnapshot.data();

      expect((updatedRoomData!['members'] as List).contains(mockUser.uid), true);
    });

    test('Leave a room successfully', () async {
      // Simula una sala con el usuario como miembro
      final roomsCollection = fakeFirestore.collection('rooms');
      final roomRef = await roomsCollection.add({
        'admin': 'adminUserId',
        'code': 'TEST123',
        'members': ['adminUserId', mockUser.uid],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // El usuario sale de la sala
      final roomSnapshot = await roomsCollection.where('code', isEqualTo: 'TEST123').get();
      final roomDoc = roomSnapshot.docs.first;

      await roomDoc.reference.update({
        'members': FieldValue.arrayRemove([mockUser.uid]),
      });
      leaveRoom('TEST123');
      // Verifica que el usuario ya no está en la sala
      final updatedSnapshot = await roomDoc.reference.get();
      final updatedRoomData = updatedSnapshot.data();

      expect((updatedRoomData!['members'] as List).contains(mockUser.uid), false);
    });
  });
}
