import 'package:social_feed_app/core/models/messages.dart';

enum ChatStatus { idle, loading, loaded, error }

class ChatState {
  final ChatStatus status;
  final List<Message> messages;
  final String? errorMessage;

  const ChatState({
    required this.status,
    this.messages = const [],
    this.errorMessage,
  });

  const ChatState.idle() : this(status: ChatStatus.idle);

  ChatState copyWith({
    ChatStatus? status,
    List<Message>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }
}
