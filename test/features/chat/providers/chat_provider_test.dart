import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_feed_app/core/models/message.dart';
import 'package:social_feed_app/core/models/user.dart';
import 'package:social_feed_app/features/chat/data/chat_repository.dart';
import 'package:social_feed_app/features/chat/providers/chat_provider.dart';
import 'package:social_feed_app/features/chat/providers/chat_state.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
  });

  test('loadMessages sets status to loaded with messages on success', () async {
    final fakeMessages = [
      Message(
        id: '1',
        senderId: 'u1',
        senderName: 'Alex',
        text: 'Hi',
        sentAt: DateTime.now(),
      ),
    ];
    when(
      () => mockChatRepository.fetchMessages(any()),
    ).thenAnswer((_) async => fakeMessages);

    final testUser = AppUser(id: 'u1', name: 'Test User', avatarUrl: '');
    final chatProvider = ChatProvider(mockChatRepository, testUser);

    await Future.delayed(const Duration(milliseconds: 10));

    expect(chatProvider.state.status, ChatStatus.loaded);
    expect(chatProvider.state.messages.length, 1);
    expect(chatProvider.state.messages.first.text, 'Hi');
  });

  test('loadMessages sets status to error when repository throws', () async {
    when(
      () => mockChatRepository.fetchMessages(any()),
    ).thenThrow(Exception('network failure'));
    final testUser = AppUser(id: 'u1', name: 'Test User', avatarUrl: '');
    final chatProvider = ChatProvider(mockChatRepository, testUser);

    await Future.delayed(const Duration(milliseconds: 10));
    expect(chatProvider.state.status, ChatStatus.error);
    expect(chatProvider.state.errorMessage, contains('network failure'));
    expect(chatProvider.state.messages, isEmpty);
  });
}
