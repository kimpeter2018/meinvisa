import 'package:flutter/material.dart';

/// 4️⃣ Purpose of Stay Page (Optional)
class PurposeOfStayPage extends StatelessWidget {
  final ValueChanged<String?> onNext;
  const PurposeOfStayPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What’s your purpose of stay in Germany?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "e.g. Study, Work, Family reunion, etc.",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => onNext(
              controller.text.trim().isEmpty ? null : controller.text.trim(),
            ),
            child: const Text("Finish"),
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
