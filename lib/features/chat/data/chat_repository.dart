// features/chat/data/chat_repository.dart
import '../../../core/models/message.dart';

class ChatRepository {
  Future<List<Message>> fetchMessages(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.generate(5, (i) => Message(
      id: 'm$i',
      senderId: 'other',
      senderName: 'Alex',
      text: 'Message #$i for $userId',
      sentAt: DateTime.now().subtract(Duration(minutes: i)),
    ));
  }
}