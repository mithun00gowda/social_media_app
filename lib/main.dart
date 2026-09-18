import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_feed_app/core/models/messages.dart';
import 'package:social_feed_app/features/auth/data/auth_repository.dart';
import 'package:social_feed_app/features/auth/presentation/login_screen.dart';
import 'package:social_feed_app/features/auth/providers/auth_provider.dart';

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
    ChangeNotifierProvider(
      create: (_) => AuthProvider(repository: AuthRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    ),
  );
}
