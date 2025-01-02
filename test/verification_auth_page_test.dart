import 'package:film_finder/pages/auth_pages/login_screen.dart';
import 'package:film_finder/pages/menu_pages/principal_screen.dart';
import 'package:film_finder/pages/auth_pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Mock para FirebaseAuth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Mock para User
class MockUser extends Mock implements User {
  @override
  String get uid => 'testUserId';
}

// Genera el mock para FirebaseAuth y User
@GenerateMocks([FirebaseAuth, User])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
  });

  Widget createTestableWidget(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }

  group('AuthPage', () {
    testWidgets('Shows LogIn when user is not authenticated',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));

      await tester.pumpWidget(
        createTestableWidget(
          StreamBuilder<User?>(
            stream: mockFirebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              return AuthPage();
            },
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(LogIn), findsOneWidget);
    });

    testWidgets('Shows PrincipalScreen when user is authenticated',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(mockUser));

      await tester.pumpWidget(
        createTestableWidget(
          StreamBuilder<User?>(
            stream: mockFirebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              return AuthPage();
            },
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(PrincipalScreen), findsOneWidget);
    });

    testWidgets('Shows CircularProgressIndicator while loading',
        (WidgetTester tester) async {
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(
        createTestableWidget(
          StreamBuilder<User?>(
            stream: mockFirebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              return AuthPage();
            },
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
