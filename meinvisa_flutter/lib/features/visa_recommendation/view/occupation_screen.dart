import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meinvisa/data/providers/visa_recommendation_provider.dart';

class OccupationPage extends ConsumerStatefulWidget {
  final ValueChanged<String?> onNext;
  const OccupationPage({super.key, required this.onNext});

  @override
  ConsumerState<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends ConsumerState<OccupationPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final occupation =
        ref.read(visaRecommendationProvider).value?.occupation ?? '';
    _controller = TextEditingController(text: occupation);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("What's your occupation?", style: TextStyle(fontSize: 22)),
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
