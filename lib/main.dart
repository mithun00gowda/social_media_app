import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_feed_app/features/auth/data/auth_repository.dart';
import 'package:social_feed_app/features/auth/presentation/login_screen.dart';
import 'package:social_feed_app/features/auth/providers/auth_provider.dart';
import 'package:social_feed_app/features/auth/providers/auth_state.dart';
import 'package:social_feed_app/features/chat/presentation/feed_screen.dart';
import 'features/chat/data/chat_repository.dart';
import 'features/chat/providers/chat_provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: AuthRepository()),
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
        home: Selector<AuthProvider, AuthStatus>(
          selector: (context, auth) => auth.state.status,
          builder: (context, status, _) {
            if (status == AuthStatus.loading || status == AuthStatus.initial) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (status == AuthStatus.authenticated) {
              return FeedScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    ),
  );
}
