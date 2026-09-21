import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_feed_app/features/auth/providers/auth_provider.dart';
import 'package:social_feed_app/features/auth/providers/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'ChatterFeed',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Only this small widget rebuilds when auth status changes
              Selector<AuthProvider, AuthStatus>(
                selector: (context, auth) => auth.state.status,
                builder: (context, status, _) {
                  if (status == AuthStatus.loading) {
                    return Center(child: const CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<AuthProvider>().login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('Login'),
                  );
                },
              ),

              const SizedBox(height: 12),

              // A second, separate Selector, only for the error message
              Selector<AuthProvider, String?>(
                selector: (context, auth) => auth.state.errorMessage,
                builder: (context, errorMessage, _) {
                  if (errorMessage == null) return const SizedBox.shrink();
                  return Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  );
                },
              ),
              Selector<AuthProvider, AuthStatus>(
                builder: (context, status, _) {
                  if (status == AuthStatus.authenticated) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<AuthProvider>().logOut();
                      },
                      child: Text('Logout'),
                    );
                  }
                  return SizedBox();
                },
                selector: (context, auth) => auth.state.status,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
