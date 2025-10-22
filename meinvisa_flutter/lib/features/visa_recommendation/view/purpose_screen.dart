import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';

class PurposeOfStayPage extends ConsumerStatefulWidget {
  final ValueChanged<String?> onNext;
  const PurposeOfStayPage({super.key, required this.onNext});

  @override
  ConsumerState<PurposeOfStayPage> createState() => _PurposeOfStayPageState();
}

class _PurposeOfStayPageState extends ConsumerState<PurposeOfStayPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final purpose =
        ref.read(visaRecommendationProvider).value?.purposeOfStay ?? '';
    _controller = TextEditingController(text: purpose);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Purpose of stay in Germany?",
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 12),
          TextField(controller: _controller, maxLines: 3),
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
                child: const Text("Finish"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
