import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_news/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lotus_news/main.dart';
import 'package:provider/provider.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E5AA8), Color(0xFF2B7FD9), Color(0xFF1E5AA8)],
          ),
        ),
        child: SafeArea(
          child: Consumer<AuthViewModel>(
            builder: (context, state, child) {
              if (state.state is SignInSuccess) {
                Future.microtask(() {
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => App()),
                    (route) => false,
                  );
                });
              }
              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Image.asset(
                            'assets/images/news_logo.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 48),

                          // Login Title
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Email Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'username@gmail.com',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Password Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<AuthViewModel>().signIn(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0D3B66),
                                padding: EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Divider
                          Text(
                            'or continue with',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 24),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/google.svg',
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16),
                              SocialButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/github.svg',
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16),
                              SocialButton(
                                icon: SvgPicture.string(
                                  'assets/icons/facebook.svg',
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Register Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account yet? ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Register for free',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
