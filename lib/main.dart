import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_feed_app/features/auth/data/auth_repository.dart';
import 'package:social_feed_app/features/auth/presentation/login_screen.dart';
import 'package:social_feed_app/features/auth/providers/auth_provider.dart';
import 'features/chat/data/chat_repository.dart';
import 'features/chat/providers/chat_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepository()),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          create: (context) => ChatProvider(
            ChatRepository(),
            context.read<AuthProvider>().state.user,
          ),
          update: (context, authProvider, previousChatProvider) {
            previousChatProvider!.updateUser(authProvider.state.user);
            return previousChatProvider;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatterFeed',
        home: const LoginScreen(),
      ),
    ),
  );
}
