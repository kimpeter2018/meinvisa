// lib/core/debug/debug_overlay.dart
import 'package:flutter/material.dart';
import 'debug_logger.dart';

class DebugOverlay extends StatefulWidget {
  static const String routeName = '/debug';

  const DebugOverlay({super.key});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  final logger = DebugLogger();

  @override
  void initState() {
    super.initState();
    logger.addListener(_onLogsChanged);
  }

  @override
  void dispose() {
    logger.removeListener(_onLogsChanged);
    super.dispose();
  }

  void _onLogsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.85),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Debug Console',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: logger.clear,
                ),
              ],
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView.builder(
                itemCount: logger.logs.length,
                itemBuilder: (context, index) {
                  final log = logger.logs[index];
                  final isError = log.contains('[ERROR]');
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    child: Text(
                      log,
                      style: TextStyle(
                        color: isError ? Colors.redAccent : Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
