import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/auth_provider.dart';
import 'package:meinvisa/data/providers/user_provider.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/visa_recommendation_screen.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  int _selectedIndex = 0;
  static List<Widget> _pages(BuildContext context) => <Widget>[
    Center(
      child: ElevatedButton(
        onPressed: () {
          context.push(VisaRecommendationScreen.routeName);
        },
        child: const Text('Go to Visa Recommendation'),
      ),
    ),
    const Center(child: Text('Search')),
    const Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> signOut() async {
    try {
      await ref.read(authViewModelProvider.notifier).signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      if (mounted) context.go(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Layout'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  signOut();
                },
                tooltip: "Sign Out",
              ),
            ],
          ),
          body: _pages(context)[_selectedIndex], // <-- updated here
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(child: Text('Failed to load user data')),
    );
  }
}
