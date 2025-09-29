import 'package:flutter/material.dart';

class NamePage extends StatelessWidget {
  final ValueChanged<String> onNext;
  const NamePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("What's your name?", style: TextStyle(fontSize: 22)),
          TextField(controller: controller),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onNext(controller.text),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}

class AvatarPage extends StatelessWidget {
  final ValueChanged<String?> onNext;
  const AvatarPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Upload a profile picture (optional)"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onNext("https://example.com/avatar.png"),
            child: const Text("Skip for now"),
          ),
        ],
      ),
    );
  }
}

class BioPage extends StatelessWidget {
  final ValueChanged<String?> onNext;
  const BioPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Tell us about yourself", style: TextStyle(fontSize: 22)),
          TextField(controller: controller, maxLines: 3),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => onNext(controller.text),
            child: const Text("Finish"),
          ),
        ],
      ),
    );
  }
}
