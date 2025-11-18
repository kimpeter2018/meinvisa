import 'package:flutter/material.dart';

class EditFieldDialog extends StatefulWidget {
  final String fieldLabel;
  final dynamic currentValue;
  final Function(dynamic value) onSave;

  const EditFieldDialog({
    super.key,
    required this.fieldLabel,
    required this.currentValue,
    required this.onSave,
  });

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.fieldLabel}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current value:', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            widget.currentValue?.toString() ?? 'N/A',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'New value',
              border: const OutlineInputBorder(),
              helperText: 'Enter the corrected value',
            ),
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  void _save() {
    final newValue = _controller.text.trim();
    if (newValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Value cannot be empty'), backgroundColor: Colors.red),
      );
      return;
    }

    widget.onSave(newValue);
  }
}
