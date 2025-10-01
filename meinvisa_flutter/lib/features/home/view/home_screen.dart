import 'package:meinvisa/core/providers/auth_provider.dart';
import 'package:meinvisa/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final user = ref.read(userProvider).value;

    // if (user != null) {
    //   print('User email: ${user.email}');
    // } else {
    //   print('No user signed in');
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Fonts", style: textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
            },
            tooltip: "Sign Out",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Headline Large", style: textTheme.headlineLarge),
            Text("Headline Medium", style: textTheme.headlineMedium),
            Text("Body Large", style: textTheme.bodyLarge),
            Text("Body Medium", style: textTheme.bodyMedium),
            ElevatedButton(
              onPressed: () {},
              child: Text("Label Large", style: textTheme.labelLarge),
            ),

            SizedBox(height: 32),
            Text("대제목", style: textTheme.headlineLarge),
            Text("${user?.email}", style: textTheme.headlineMedium),
            Text(
              "※ 예스24는 음악에 대한 저작권 소유자가 아니므로 영상 및 광고를 통해 수익 창출을 할 수 없습니다.",
              style: textTheme.bodyLarge,
            ),
            Text(
              "해당 영상은 자동으로 광고가 발생할 수 있으며, 광고로 인한 수익은 음악 저작권자에게 돌아갑니다.",
              style: textTheme.bodyMedium,
            ),

            ElevatedButton(
              onPressed: () {},
              child: Text("라벨지", style: textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
