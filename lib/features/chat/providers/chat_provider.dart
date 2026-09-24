// features/chat/providers/chat_provider.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:social_feed_app/core/models/message.dart';
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
  AppUser? _currentUser;
  StreamSubscription<Message>? _incomingSubscription;


  ChatState get state => _state;

  // Called every time AuthProvider changes
  void _handleUserChange(AppUser? user) {
    if (user == null) {
      _currentUserId = null;
      _currentUser = null;
      _state = const ChatState.idle();
      _incomingSubscription?.cancel();
      _incomingSubscription = null;
      notifyListeners();
      return;
    }
    if (user.id == _currentUserId) return; // same user, don't re-fetch
    _currentUserId = user.id;
    _currentUser = user;
    _loadMessages(user.id);
    _startLisitingForIncoming();
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

  Future<void> sendMessage(String text) async {
    _state = _state.copyWith(isSending: true);
    notifyListeners();
    try{
      final newMessage = await _repository.sendMessage(_currentUser!.id, _currentUser!.name, text);
      final updateMessage = [..._state.messages,newMessage];
      _state = _state.copyWith(status: ChatStatus.loaded,messages: updateMessage,isSending: false);
    }catch(e){
      _state = _state.copyWith(errorMessage: e.toString(),isSending: false);
    }
    notifyListeners();
  }

  void _startLisitingForIncoming(){
    _incomingSubscription?.cancel();
    _incomingSubscription = _repository.incomingMessageStream().listen((newMessage){
      final updatedMessage = [...state.messages,newMessage];
      _state = _state.copyWith(messages: updatedMessage);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _incomingSubscription?.cancel();
    super.dispose();
  }

  // Public method the proxy calls on every AuthProvider change
  void updateUser(AppUser? user) => _handleUserChange(user);
}