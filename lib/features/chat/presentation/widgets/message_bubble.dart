import 'package:flutter/material.dart';
import 'package:social_feed_app/core/models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          SizedBox(height: 2),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(message.text),
          ),
        ],
      ),
    );
  }
}
