import 'package:meinvisa/core/utils/validators.dart';
import 'package:meinvisa/features/auth/view/email_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  int _currentStep = 0;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _validEmail = true;

  String _password = "";
  String _confirmPassword = "";

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
    _confirmPasswordController.addListener(() {
      setState(() {
        _confirmPassword = _confirmPasswordController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _password.length >= 8;
  bool get _hasUppercase => _password.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _password.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _password.contains(RegExp(r'\d'));
  bool get _hasSpecial =>
      _password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  bool get _isPasswordValid =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSpecial;

  bool get _passwordsMatch =>
      Validators.confirmPassword(_password, _confirmPassword);

  Widget _buildPasswordChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRule("At least 8 characters", _hasMinLength),
        _buildRule("At least one uppercase letter", _hasUppercase),
        _buildRule("At least one lowercase letter", _hasLowercase),
        _buildRule("At least one number", _hasNumber),
        _buildRule("At least one special character", _hasSpecial),
      ],
    );
  }

  Widget _buildRule(String text, bool valid) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: TextStyle(color: valid ? Colors.black : Colors.grey)),
        const SizedBox(width: 4),
        Icon(
          valid ? Icons.check : Icons.close,
          color: valid ? Colors.black : Colors.grey,
          size: 18,
        ),
      ],
    );
  }

  Future<void> _nextStep() async {
    if (_currentStep == 0) {
      if (!Validators.email(_emailController.text)) {
        setState(() => _validEmail = false);
        return;
      }

      setState(() => _validEmail = true);
      _passwordFocusNode.requestFocus();
    } else if (_currentStep == 1) {
      if (!_isPasswordValid) return;

      _obscurePassword = true;
      _confirmPasswordFocusNode.requestFocus();
    } else if (_currentStep == 2) {
      final exists = await ref
          .read(authViewModelProvider.notifier)
          .doesEmailExist(_emailController.text.trim());
      if (exists) {
        _showExistingEmailDialog();
        return;
      } else if (!_passwordsMatch) {
        return;
      }

      await _signUp();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              EmailConfirmationScreen(email: _emailController.text.trim()),
        ),
      );

      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref
          .read(authViewModelProvider.notifier)
          .signUpWithEmail(email, password);
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Unexpected Error"),
        content: const Text(
          "An unexpected error occurred. You will be redirected to the login screen.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showExistingEmailDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Email Already Registered"),
        content: const Text(
          "An account with this email already exists. Would you like to sign in instead?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Sign In"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _passwordController.clear();
                _confirmPasswordController.clear();
              });
            },
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                enabled: (_currentStep == 0),
              ),
              if (!_validEmail) _buildRule("Invalid Email", _validEmail),
              const SizedBox(height: 16),

              // Password
              if (_currentStep >= 1) ...[
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  focusNode: _passwordFocusNode,
                  obscureText: _obscurePassword,
                  enabled: (_currentStep == 1),
                ),
                const SizedBox(height: 8),
                if (_currentStep == 1) _buildPasswordChecklist(),
              ],

              // Confirm Password
              if (_currentStep == 2) ...[
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                ),
                const SizedBox(height: 8),
                _buildRule(
                  _passwordsMatch
                      ? "Passwords match"
                      : "Passwords do not match",
                  _passwordsMatch,
                ),
              ],

              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator(color: Colors.black)
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    child: Text(_currentStep == 2 ? "Sign Up" : "Continue"),
                  ),
                ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
