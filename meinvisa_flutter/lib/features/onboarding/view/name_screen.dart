import 'package:flutter/material.dart';

/// 1️⃣ Passport Name Page (Required)
class PassportNamePage extends StatelessWidget {
  final ValueChanged<String> onNext;
  const PassportNamePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What's your passport name?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Full name as shown on passport",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onNext(controller.text.trim());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter your name.")),
                );
              }
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
