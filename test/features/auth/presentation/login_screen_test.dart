import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:social_feed_app/features/auth/data/auth_repository.dart';
import 'package:social_feed_app/features/auth/presentation/login_screen.dart';
import 'package:social_feed_app/features/auth/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Widget createTestableWidget(AuthProvider authProvider) {
  return ChangeNotifierProvider<AuthProvider>.value(
    value: authProvider,
    child: MaterialApp(home: LoginScreen()),
  );
}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthProvider authProvider;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authProvider = AuthProvider(mockAuthRepository);
  });

  testWidgets(
    'LoginScreen shows email field, password field, and login button',
    (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(authProvider));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('ChatterFeed'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping login calls AuthProvider.login with entered credentials',
    (WidgetTester tester) async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer((_) async => throw Exception('irrelevant for this test'));

      await tester.pumpWidget(createTestableWidget(authProvider));
      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      verify(() => mockAuthRepository.login('test@example.com', 'password123')).called(1);

    },
  );
}
