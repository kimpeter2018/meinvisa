import 'package:flutter/foundation.dart';
import 'package:meinvisa/core/debug/debug_button.dart';
import 'package:meinvisa/core/theme/theme.dart';
import 'package:meinvisa/features/app/app_router.dart';
import 'package:meinvisa/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(
      context,
      "Noto Sans KR",
      "Noto Sans KR",
    );
    // MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'meinvisa App',
      theme: AppTheme.lightTheme(textTheme),
      // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Builder(
          builder: (innerContext) {
            return Stack(
              children: [
                child ?? const SizedBox(),
                if (kDebugMode) const DebugButton(),
              ],
            );
          },
        );
      },
    );
  }
}
