// features/chat/providers/chat_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/models/user.dart';
import '../data/chat_repository.dart';
import 'chat_state.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider(this._repository, AppUser? user) {
    _handleUserChange(user);
  }

  final ChatRepository _repository;
  ChatState _state = const ChatState.idle();
  String? _currentUserId;

  ChatState get state => _state;

  // Called every time AuthProvider changes
  void _handleUserChange(AppUser? user) {
    if (user == null) {
      _currentUserId = null;
      print('current user is null');
      _state = const ChatState.idle();
      notifyListeners();
      return;
    }
    print('current user is same as user');
    if (user.id == _currentUserId) return; // same user, don't re-fetch
    _currentUserId = user.id;
    print('current user is new');
    _loadMessages(user.id);
  }

  Future<void> _loadMessages(String userId) async {
    _state = _state.copyWith(status: ChatStatus.loading);
    notifyListeners();
    try {
      final messages = await _repository.fetchMessages(userId);
      _state = _state.copyWith(status: ChatStatus.loaded, messages: messages);
    } catch (e) {
      _state = _state.copyWith(status: ChatStatus.error, errorMessage: e.toString());
    }
    notifyListeners();
  }

  // Public method the proxy calls on every AuthProvider change
  void updateUser(AppUser? user) => _handleUserChange(user);
}