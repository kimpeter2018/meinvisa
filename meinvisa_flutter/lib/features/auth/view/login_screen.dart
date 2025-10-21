import 'package:meinvisa/core/utils/validators.dart';
import 'package:meinvisa/data/providers/user_provider.dart';
import 'package:meinvisa/data/repositories/user_repository.dart';
import 'package:meinvisa/features/auth/view/email_confirmation_screen.dart';
import 'package:meinvisa/features/auth/view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:meinvisa/features/auth/widgets/auth_dialog';
import 'package:meinvisa/features/home/view/home_layout.dart';
import '../../../data/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

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
  bool _obscurePassword = true;

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

    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  Future<void> _submitEmailPassword() async {
    setState(() => _isEmailLoading = true);

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final confirmed = await ref
          .read(authViewModelProvider.notifier)
          .signInWithEmail(email, password);

      if (!mounted) return;

      if (confirmed) {
        context.go(HomeLayout.routeName);
      }
    } on EmailNotConfirmedException {
      showAuthDialog(
        context: context,
        title: "Confirm Your Email",
        content: 'Your email is not confirmed yet. Please check your inbox.',
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref
                  .read(authViewModelProvider.notifier)
                  .resendVerificationEmail(email);
              if (mounted) {
                context.go(
                  EmailConfirmationScreen.routeName,
                  extra: {'email': email, 'password': password},
                );
              }
            },
            child: const Text("Confirm Email"),
          ),
        ],
      );
    } on AuthFailedException catch (e) {
      showAuthDialog(
        context: context,
        title: "Authentication Failed",
        content: e.message,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Try Again"),
          ),
        ],
      );
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  Future<void> _signinWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      final isFirstLogin = await ref
          .read(authViewModelProvider.notifier)
          .signInWithGoogle();

      if (!mounted) return;

      if (isFirstLogin) {
        context.go('/onboarding'); // navigate to OnboardingScreen
      } else {
        context.go(HomeLayout.routeName); // existing user
      }
    } catch (e) {
      showAuthDialog(
        context: context,
        title: "Google Sign-In Failed",
        content: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
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
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    focusNode: _passwordFocusNode,
                    obscureText: _obscurePassword,
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
                  Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
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
                  const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                else
                  OutlinedButton.icon(
                    icon: Image.asset(
                      "assets/images/google_logo.webp",
                      height: 24,
                    ),
                    label: const Text("Sign in with Google"),
                    onPressed: () {
                      _signinWithGoogle();
                    },
                  ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.push(SignupScreen.routeName);
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
