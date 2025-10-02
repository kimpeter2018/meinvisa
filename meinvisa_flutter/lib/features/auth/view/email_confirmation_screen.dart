import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/core/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class EmailConfirmationScreen extends ConsumerStatefulWidget {
  final String email;
  final String password; // Keep the password temporarily to retry login

  const EmailConfirmationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState
    extends ConsumerState<EmailConfirmationScreen> {
  bool _isLoading = false;

  Future<void> _resendEmail() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authViewModelProvider.notifier)
          .resendVerificationEmail(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email resent.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkConfirmedAndContinue() async {
    setState(() => _isLoading = true);

    try {
      final confirmed = await ref
          .read(authViewModelProvider.notifier)
          .signInWithEmail(widget.email, widget.password);

      if (confirmed) {
        // Navigate to home
        if (mounted) context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email not confirmed yet.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Confirm Your Email"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mark_email_unread, size: 64, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              "Check your email",
              style: textTheme.headlineSmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "We’ve sent a confirmation link to:\n${widget.email}",
              style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Resend button
            TextButton(
              onPressed: _isLoading ? null : _resendEmail,
              child: const Text(
                "Resend confirmation email",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            // "I Confirmed" button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _isLoading ? null : _checkConfirmedAndContinue,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("I Confirmed"),
            ),
          ],
        ),
      ),
    );
  }
}
