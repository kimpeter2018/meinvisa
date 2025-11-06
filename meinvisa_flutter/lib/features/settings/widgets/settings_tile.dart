import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
    );
  }
}

class LanguagePicker extends StatelessWidget {
  final String selected;
  const LanguagePicker({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final langs = [
      'English', 'Deutsch',
      // 'Français', 'Español'
    ];
    return ListView(
      shrinkWrap: true,
      children: langs
          .map(
            (lang) => RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: selected,
              onChanged: (value) => Navigator.pop(context, value),
            ),
          )
          .toList(),
    );
  }
}
