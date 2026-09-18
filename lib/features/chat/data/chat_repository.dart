import 'package:social_feed_app/core/models/messages.dart';

class ChatRepository {
  Future<List<Message>> fetchMessages(String userId) async {
    Future.delayed(Duration(milliseconds: 800));
    return List.generate(5, (index) {
      return Message(id: '$index',
          senderId: 'sender-$index',
          senderName: 'sender_name-$index',
          text: 'Hi im user - $index',
          sentAt: DateTime.now());
    });
  }
}