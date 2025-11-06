import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/data/providers/auth_provider.dart';
import 'package:meinvisa/data/providers/user_provider.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';
import 'package:meinvisa/features/home/widgets/quick_action_card.dart';
import 'package:meinvisa/features/home/widgets/visa_card.dart';
import 'package:meinvisa/features/settings/view/settings_screen.dart';
import 'package:meinvisa/features/visa_recommendation/view/visa_recommendation_screen.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({super.key});
  static const routeName = '/home';

  @override
  ConsumerState<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  int _selectedIndex = 0;

  /// Define pages for bottom nav
  static List<Widget> _pages(BuildContext context) => <Widget>[
    _HomeTab(),
    const _ApplicationsTab(),
    const _AssistantTab(),
    const SettingsPage(),
  ];

  /// Dynamic titles for each tab
  static const List<String> _titles = [
    'MeinVisa',
    'Applications',
    'AI Assistant',
    'Settings',
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
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
            title: Text(_titles[_selectedIndex]),
            centerTitle: true,
          ),

          /// Show current tab
          body: _pages(context)[_selectedIndex],

          /// Modern Bottom Navigation Bar
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            child: Wrap(
              children: [
                BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.assignment_rounded),
                      label: 'Applications',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.smart_toy_rounded),
                      label: 'AI',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings_rounded),
                      label: 'Settings',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Failed to load user data')),
    );
  }
}

//
// ───────────────────────────────────────────────
// │ Individual Tab Widgets
// ───────────────────────────────────────────────
//

/// 🏠 Home Tab – Dashboard style
class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hi there 👋',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Ready to start your visa journey?'),
        const SizedBox(height: 24),

        // Quick Actions
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            QuickActionCard(
              icon: Icons.explore,
              label: 'New Visa Check',
              onTap: () => context.push(VisaRecommendationScreen.routeName),
            ),
            QuickActionCard(
              icon: Icons.assignment,
              label: 'Track Application',
              onTap: () {}, // TODO: link to Applications tab
            ),
            QuickActionCard(
              icon: Icons.alarm,
              label: 'Termin Alerts',
              onTap: () {}, // TODO: add alert setup
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Recommended Visas section
        const Text(
          'Recommended Visas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        VisaCard(
          title: 'Blue Card',
          description:
              'For skilled professionals with a university degree and job offer.',
          onApply: () {},
        ),
        VisaCard(
          title: 'Job Seeker Visa',
          description:
              'For professionals seeking employment opportunities in Germany.',
          onApply: () {},
        ),
      ],
    );
  }
}

/// 📄 Applications Tab
class _ApplicationsTab extends StatelessWidget {
  const _ApplicationsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Your ongoing and past visa applications will appear here.'),
    );
  }
}

/// 🤖 AI Assistant Tab
class _AssistantTab extends StatelessWidget {
  const _AssistantTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chat with your Visa Assistant 🤖'));
  }
}
