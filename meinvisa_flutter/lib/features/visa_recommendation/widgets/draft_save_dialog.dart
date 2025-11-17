import 'package:flutter/material.dart';

enum DraftAction { saveToCloud, saveLocal, discard }

class DraftSaveDialog extends StatelessWidget {
  final VoidCallback? onSaveToCloud;
  final VoidCallback? onSaveLocal;
  final VoidCallback? onDiscard;

  const DraftSaveDialog({super.key, this.onSaveToCloud, this.onSaveLocal, this.onDiscard});

  static Future<DraftAction?> show(BuildContext context) async {
    return showDialog<DraftAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DraftSaveDialog(
        onSaveToCloud: () => Navigator.of(context).pop(DraftAction.saveToCloud),
        onSaveLocal: () => Navigator.of(context).pop(DraftAction.saveLocal),
        onDiscard: () => Navigator.of(context).pop(DraftAction.discard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.save_outlined, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          const Text('Save Your Progress?'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You have unsaved changes. How would you like to proceed?',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 24),
          _buildOption(
            context,
            icon: Icons.cloud_upload_outlined,
            title: 'Save to Cloud',
            subtitle: 'Access from any device',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            icon: Icons.phone_android,
            title: 'Save Locally',
            subtitle: 'Only on this device',
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            icon: Icons.delete_outline,
            title: 'Discard Changes',
            subtitle: 'All progress will be lost',
            color: Colors.red,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    VoidCallback? onTap;
    if (title.contains('Cloud')) {
      onTap = onSaveToCloud;
    } else if (title.contains('Locally')) {
      onTap = onSaveLocal;
    } else if (title.contains('Discard')) {
      onTap = onDiscard;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
