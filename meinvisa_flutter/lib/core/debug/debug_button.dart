// lib/core/debug/debug_button.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';
import 'package:meinvisa/features/app/app_router.dart';
import 'debug_overlay.dart';

class DebugButton extends StatelessWidget {
  const DebugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DebugLogger().isOverlayOpen,
      builder: (context, isOpen, child) {
        if (isOpen) return const SizedBox.shrink();
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 60,
          right: 24,
          child: Builder(
            builder: (innerContext) => FloatingActionButton(
              backgroundColor: Colors.orangeAccent,
              onPressed: () {
                final routerContext = rootNavigatorKey.currentContext;
                if (routerContext != null) {
                  routerContext.push(DebugOverlay.routeName);
                } else {
                  debugPrint('❌ No GoRouter context found');
                }
              },
              child: const Icon(Icons.bug_report, color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
