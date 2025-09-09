import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lotus_news/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lotus_news/features/news/presentation/view/news_screen.dart';
import 'package:lotus_news/main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<AuthViewModel>(
            builder: (_, state, child) {
              debugPrint('auth state: ${state.state}');
              switch (state.state) {
                case SignInSuccess _:
                  Future.microtask(() => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => App())));
                  break;
              }
              return IconButton(
                onPressed: () => context.read<AuthViewModel>().signInWithBiometric(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.fingerprint, color: theme.primaryColor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
