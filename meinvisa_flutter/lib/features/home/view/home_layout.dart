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

  /// Define pages for bottom nav
  static List<Widget> _pages(BuildContext context) => <Widget>[
    _HomeTab(),
    const _ApplicationsTab(),
    const _AssistantTab(),
    const _SettingsTab(),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: signOut,
                tooltip: "Sign Out",
              ),
            ],
          ),

          /// Show current tab
          body: _pages(context)[_selectedIndex],

          /// Floating Action Button – "Start Visa Check"
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push(VisaRecommendationScreen.routeName);
            },
            label: const Text('Start Visa Check'),
            icon: const Icon(Icons.explore),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          /// Modern Bottom Navigation Bar
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Theme.of(context).colorScheme.surface,
            elevation: 4,
            child: BottomNavigationBar(
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
            _QuickActionCard(
              icon: Icons.explore,
              label: 'New Visa Check',
              onTap: () => context.push(VisaRecommendationScreen.routeName),
            ),
            _QuickActionCard(
              icon: Icons.assignment,
              label: 'Track Application',
              onTap: () {}, // TODO: link to Applications tab
            ),
            _QuickActionCard(
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
        _VisaCard(
          title: 'Blue Card',
          description:
              'For skilled professionals with a university degree and job offer.',
          onApply: () {},
        ),
        _VisaCard(
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

/// ⚙️ Settings Tab
class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings and preferences'));
  }
}

//
// ───────────────────────────────────────────────
// │ Reusable Widgets
// ───────────────────────────────────────────────
//

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 110,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VisaCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onApply;

  const _VisaCard({
    required this.title,
    required this.description,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onApply,
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
