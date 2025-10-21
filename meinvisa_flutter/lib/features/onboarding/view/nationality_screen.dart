import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/providers/onboarding_provider.dart';

class PassportNationalityPage extends ConsumerStatefulWidget {
  final ValueChanged<String?> onNext;
  const PassportNationalityPage({super.key, required this.onNext});

  @override
  ConsumerState<PassportNationalityPage> createState() =>
      _PassportNationalityPageState();
}

class _PassportNationalityPageState
    extends ConsumerState<PassportNationalityPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final nationality = ref.read(onboardingProvider).value?.nationality ?? '';
    _controller = TextEditingController(text: nationality);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What's your nationality?",
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 12),
          TextField(controller: _controller),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => widget.onNext(null),
                child: const Text("Skip for now"),
              ),
              ElevatedButton(
                onPressed: () => widget.onNext(_controller.text),
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
