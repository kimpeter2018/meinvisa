import 'package:echad/core/utils/validators.dart';
import 'package:echad/features/auth/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _showPasswordField = false;
  bool _emailLocked = false;
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _continueWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _emailLocked = true;
      _showPasswordField = true;
    });

    if (_showPasswordField) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    }
  }

  Future<void> _submitEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isEmailLoading = true);

    try {
      await ref
          .read(authViewModelProvider.notifier)
          .signInWithEmail(email, password);
    } catch (e) {
      _showAuthErrorDialog(e.toString());
    } finally {
      if (mounted) context.go('/home');
    }
  }

  void _showAuthErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Authentication Failed"),
        content: const Text("Invalid credentials or account not found."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _showPasswordField = true;
                _emailLocked = true;
              });
            },
            child: const Text("Try Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_emailLocked,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!Validators.email(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                if (_showPasswordField)
                  TextFormField(
                    controller: _passwordController,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(labelText: 'Password'),
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                // Back button (only visible after email is locked)
                if (_emailLocked) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _emailLocked = false;
                          _showPasswordField = false;
                          _passwordController.clear();
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Change Email"),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                if (_isEmailLoading)
                  const CircularProgressIndicator(color: Colors.black)
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _showPasswordField
                        ? _submitEmailPassword
                        : _continueWithEmail,
                    child: Text(_showPasswordField ? ("Sign In") : "Continue"),
                  ),
                const SizedBox(height: 16),

                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.black26)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(color: Colors.black26)),
                  ],
                ),
                const SizedBox(height: 16),

                // Google Sign-In button
                if (_isGoogleLoading)
                  const CircularProgressIndicator(color: Colors.black)
                else
                  OutlinedButton.icon(
                    icon: Image.asset(
                      "assets/images/google_logo.webp",
                      height: 24,
                    ),
                    label: const Text("Sign in with Google"),
                    onPressed: () {
                      ref
                          .read(authViewModelProvider.notifier)
                          .signInWithGoogle();
                      setState(() {
                        _isGoogleLoading = true;
                      });
                    },
                  ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(decoration: TextDecoration.underline),
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
  }
}
