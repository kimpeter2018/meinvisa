import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meinvisa/features/settings/widgets/settings_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meinvisa/data/providers/auth_provider.dart';
import 'package:meinvisa/features/auth/view/login_screen.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  bool _darkMode = false;
  bool _terminAlerts = true;
  String _selectedLanguage = 'English';

  void _toggleDarkMode(bool value) {
    setState(() => _darkMode = value);
    // TODO: Implement theme switching logic (e.g., ref.read(themeProvider))
  }

  void _toggleAlerts(bool value) {
    setState(() => _terminAlerts = value);
    // TODO: Save user preference to Supabase or local storage
  }

  void _changeLanguage(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (_) => LanguagePicker(selected: _selectedLanguage),
    );
    if (selected != null) {
      setState(() => _selectedLanguage = selected);
      // TODO: Apply localization
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _signOut(BuildContext context) async {
    await ref.read(authViewModelProvider.notifier).signOut();
    if (mounted) context.go(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          const Text(
            'Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.person,
                  title: 'Profile Information',
                  subtitle: 'Manage your name, email, and country',
                  onTap: () {
                    // TODO: Go to profile edit page
                  },
                ),
                SettingsTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'Log out from your MeinVisa account',
                  onTap: () => _signOut(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SwitchTile(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  value: _darkMode,
                  onChanged: _toggleDarkMode,
                ),
                SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  onTap: () => _changeLanguage(context),
                ),
                SwitchTile(
                  icon: Icons.notifications_active,
                  title: 'Termin Alerts',
                  subtitle: 'Get notified when appointment slots open',
                  value: _terminAlerts,
                  onChanged: _toggleAlerts,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Common visa questions and guides',
                  onTap: () => _launchUrl('https://meinvisa.help'),
                ),
                SettingsTile(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  subtitle: 'Share your thoughts with our team',
                  onTap: () => _launchUrl('mailto:support@meinvisa.app'),
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Understand how your data is handled',
                  onTap: () => _launchUrl('https://meinvisa.app/privacy'),
                ),
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About MeinVisa',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'MeinVisa',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.public),
                      children: [
                        const Text(
                          'MeinVisa helps you find, apply for, and manage your German visa easily.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
