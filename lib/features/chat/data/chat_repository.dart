// features/chat/data/chat_repository.dart
import 'package:uuid/uuid.dart';

import '../../../core/models/message.dart';

class ChatRepository {
  final uuid = Uuid();
  Future<List<Message>> fetchMessages(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.generate(
      5,
      (i) => Message(
        id: 'm$i',
        senderId: 'other',
        senderName: 'Alex',
        text: 'Message #$i for $userId',
        sentAt: DateTime.now().subtract(Duration(minutes: i)),
      ),
    );
  }

  Future<Message> sendMessage(
    String userId,
    String senderName,
    String text,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return Message(
      id: uuid.v4(),
      senderId: userId,
      senderName: senderName,
      text: text,
      sentAt: DateTime.now(),
    );
  }

  Stream<Message> incomingMessageStream() async*{
    int counter = 0;
    while(true){
      await Future.delayed(Duration(seconds: 4));
      counter++;
      yield Message(id: uuid.v4(), senderId: 'other', senderName: 'Alex', text: 'Income message #$counter', sentAt: DateTime.now());
    }
  }
}
