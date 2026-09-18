import 'package:flutter/material.dart';
import 'package:social_feed_app/core/models/messages.dart';
import 'package:social_feed_app/features/chat/data/chat_repository.dart';
import 'package:social_feed_app/features/chat/provider/chat_state.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider({required this._repository});

  final ChatRepository _repository;
  ChatState _state = ChatState.idle();

  ChatState get state => _state;

  Future<void> loadMessages(String userId) async {
    _state = _state.copyWith(status: ChatStatus.loading);
    notifyListeners();

    try {
      List<Message> message = await _repository.fetchMessages(userId);
      _state = _state.copyWith(status: ChatStatus.loaded, messages: message);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }
}
