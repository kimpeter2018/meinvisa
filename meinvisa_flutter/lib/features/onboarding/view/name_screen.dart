import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/providers/onboarding_provider.dart';

class PassportNamePage extends ConsumerStatefulWidget {
  final ValueChanged<String> onNext;
  const PassportNamePage({super.key, required this.onNext});

  @override
  ConsumerState<PassportNamePage> createState() => _PassportNamePageState();
}

class _PassportNamePageState extends ConsumerState<PassportNamePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final name = ref.read(onboardingProvider).value?.name ?? '';
    _controller = TextEditingController(text: name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("What's your name?", style: TextStyle(fontSize: 22)),
          const SizedBox(height: 12),
          TextField(controller: _controller),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => widget.onNext(_controller.text),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
