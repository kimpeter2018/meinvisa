import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ModernDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime?) onDateChanged;
  final String? labelText;
  final String? hintText;

  const ModernDatePicker({
    super.key,
    this.initialDate,
    required this.onDateChanged,
    this.labelText = 'Date',
    this.hintText = 'DD/MM/YYYY',
  });

  @override
  State<ModernDatePicker> createState() => _ModernDatePickerState();
}

class _ModernDatePickerState extends State<ModernDatePicker> {
  late TextEditingController _controller;
  DateTime? _selectedDate;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndParseDate(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorText = null;
        _selectedDate = null;
      });
      widget.onDateChanged(null);
      return;
    }

    try {
      // Parse DD/MM/YYYY format
      final parts = value.split('/');
      if (parts.length != 3) {
        throw const FormatException('Invalid format');
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      // Validate the date is correct (handles invalid dates like 31/02/2024)
      if (date.day != day || date.month != month || date.year != year) {
        throw const FormatException('Invalid date');
      }

      setState(() {
        _errorText = null;
        _selectedDate = date;
      });
      widget.onDateChanged(date);
    } catch (e) {
      setState(() {
        _errorText = 'Invalid date format (DD/MM/YYYY)';
        _selectedDate = null;
      });
      widget.onDateChanged(null);
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
        _errorText = null;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: _errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: _pickDate,
          tooltip: 'Pick date',
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        LengthLimitingTextInputFormatter(10),
        _DateInputFormatter(),
      ],
      onChanged: _validateAndParseDate,
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    int selectionIndex = newValue.selection.end;

    // Remove all slashes first
    final digitsOnly = text.replaceAll('/', '');

    for (int i = 0; i < digitsOnly.length && i < 8; i++) {
      buffer.write(digitsOnly[i]);

      // Add slash after day (position 2) and month (position 4)
      if (i == 1 || i == 3) {
        buffer.write('/');
        if (i < newValue.selection.end - 1) {
          selectionIndex++;
        }
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: selectionIndex.clamp(0, formattedText.length),
      ),
    );
  }
}
