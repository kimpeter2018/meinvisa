import 'package:echad/core/theme/theme.dart';
import 'package:echad/features/app/app_router.dart';
import 'package:echad/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

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
      title: 'Echad App',
      theme: AppTheme.lightTheme(textTheme),
      // theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
