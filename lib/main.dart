import 'package:flutter/material.dart';
import 'package:social_feed_app/core/models/messages.dart';
import 'package:social_feed_app/features/auth/presentation/login_screen.dart';

void main() {
  final m = Message(
    id: '1',
    senderId: 'u1',
    senderName: 'Mithun',
    text: 'Hi How are you',
    sentAt: DateTime.now(),
  );
  debugPrint('${m.senderName}: ${m.text}');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}
