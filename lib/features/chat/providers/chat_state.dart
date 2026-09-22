import 'package:social_feed_app/core/models/message.dart';

enum ChatStatus { idle, loading, loaded, error }

class ChatState {
  final ChatStatus status;
  final List<Message> messages;
  final String? errorMessage;
  final bool isSending;

  const ChatState({
    required this.status,
    this.messages = const [],
    this.errorMessage,
    this.isSending = false
  });

  const ChatState.idle() : this(status: ChatStatus.idle);
  bool get isLoading => status == ChatStatus.loading;
  bool get hasMessage => messages.isNotEmpty;


  ChatState copyWith({
    ChatStatus? status,
    List<Message>? messages,
    String? errorMessage,
    bool? isSending
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
      isSending:  isSending ?? this.isSending
    );
  }
}
