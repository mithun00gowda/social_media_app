// features/chat/data/chat_repository.dart
import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/message.dart';

class ChatRepository {
  ChatRepository(this._box);
  final Box<String> _box;
  final uuid = Uuid();

  String _key(String userId) => 'messages_$userId';
  Future<void> chacedMessage(String userId, List<Message> messages) async {
    final encoded = jsonEncode(
      messages
          .map(
            (m) => {
              'id': m.id,
              'senderId': m.senderId,
              'senderName': m.senderName,
              'text': m.text,
              'sentAt': m.sentAt.toIso8601String(),
            },
          )
          .toList(),
    );
    await _box.put(_key(userId), encoded);
  }

  List<Message> getCachedMessage(String userId) {
    final raw = _box.get(_key(userId));
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return Message(
        id: map['id'] as String,
        senderId: map['senderId'] as String,
        senderName: map['senderName'] as String,
        text: map['text'] as String,
        sentAt: DateTime.parse(map['sentAt'] as String),
      );
    }).toList();
  }

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

  Stream<Message> incomingMessageStream() async* {
    int counter = 0;
    while (true) {
      await Future.delayed(Duration(seconds: 4));
      counter++;
      yield Message(
        id: uuid.v4(),
        senderId: 'other',
        senderName: 'Alex',
        text: 'Income message #$counter',
        sentAt: DateTime.now(),
      );
    }
  }
}
