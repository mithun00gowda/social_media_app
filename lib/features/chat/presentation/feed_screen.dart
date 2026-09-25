import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_feed_app/core/models/message.dart';
import 'package:social_feed_app/features/auth/presentation/login_screen.dart';
import 'package:social_feed_app/features/auth/providers/auth_provider.dart';
import 'package:social_feed_app/features/auth/providers/auth_state.dart';
import 'package:social_feed_app/features/chat/presentation/widgets/message_bubble.dart';
import 'package:social_feed_app/features/chat/providers/chat_provider.dart';

import '../providers/chat_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatProvider>().sendMessage(text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatterFeed'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthProvider>().logOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Selector<ChatProvider, ChatStatus>(
              selector: (context, chat) => chat.state.status,
              builder: (context, status, _) {
                if (status == ChatStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (status == ChatStatus.error) {
                  return Center(
                    child: Selector<ChatProvider, String?>(
                      selector: (context, chat) => chat.state.errorMessage,
                      builder: (context, error, _) =>
                          Text(error ?? 'Something went wrong'),
                    ),
                  );
                }
                return _MessageList();
              },
            ),
          ),
          Selector<ChatProvider, String?>(
            builder: (context, error, _) {
              if (error == null) return SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              );
            },
            selector: (context, chat) =>
                chat.state.status == ChatStatus.loaded
                ? chat.state.errorMessage
                : null,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Selector<ChatProvider, bool>(
                    builder: (context, isSending, _) {
                      return IconButton(
                        onPressed: isSending
                            ? null
                            : () => _handleSend(context),
                        icon: isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send),
                      );
                    },
                    selector: (context, chat) => chat.state.isSending,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList();

  @override
  Widget build(BuildContext context) {
    return Selector<ChatProvider, List<Message>>(
      builder: (context, messages, _) {
        if (messages.isEmpty) {
          return const Center(child: Text('No Message yet'));
        }
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) =>
              MessageBubble(message: messages[index]),
        );
      },
      selector: (context, chat) => chat.state.messages,
    );
  }
}
