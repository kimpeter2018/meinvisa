import 'package:flutter/material.dart';

/// 3️⃣ Occupation Page (Optional)
class OccupationPage extends StatelessWidget {
  final ValueChanged<String?> onNext;
  const OccupationPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What's your occupation?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "e.g. Student, Engineer, Researcher",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => onNext(
              controller.text.trim().isEmpty ? null : controller.text.trim(),
            ),
            child: const Text("Next"),
          ),
          TextButton(
            onPressed: () => onNext(null),
            child: const Text("Skip for now"),
          ),
        ],
      ),
    );
  }
}
