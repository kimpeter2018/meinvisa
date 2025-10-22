import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/models/user_model.dart';
import 'package:meinvisa/data/providers/onboarding_provider.dart';

class PassportNamePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const PassportNamePage({super.key, required this.onNext});

  @override
  ConsumerState<PassportNamePage> createState() => _PassportNamePageState();
}

class _PassportNamePageState extends ConsumerState<PassportNamePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(onboardingProvider).value ?? UserModel.empty();

    _firstNameController = TextEditingController(text: user.firstName ?? '');
    _middleNameController = TextEditingController(text: user.middleName ?? '');
    _lastNameController = TextEditingController(text: user.lastName ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _onNextPressed() async {
    final first = _firstNameController.text.trim();
    final middle = _middleNameController.text.trim();
    final last = _lastNameController.text.trim();

    if (first.isEmpty || last.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first and last name.')),
      );
      return;
    }

    await ref
        .read(onboardingProvider.notifier)
        .updateName(first, middle.isNotEmpty ? middle : null, last);

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your full name?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please enter your name exactly as it appears on your passport.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _middleNameController,
            decoration: const InputDecoration(
              labelText: 'Middle name (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _onNextPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text("Next", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
