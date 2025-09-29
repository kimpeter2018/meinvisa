import 'package:echad/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailConfirmationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailConfirmationScreen({super.key, required this.email});

  @override
  ConsumerState<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState
    extends ConsumerState<EmailConfirmationScreen> {
  void _resendEmail() {
    ref
        .read(authViewModelProvider.notifier)
        .resendVerificationEmail(widget.email);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Verification email resent.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm your email")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              "Check your email",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "We’ve sent a confirmation link to:\n${widget.email}",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Resend button
            TextButton(
              onPressed: _resendEmail,
              child: const Text("Resend confirmation email"),
            ),
          ],
        ),
      ),
    );
  }
}
