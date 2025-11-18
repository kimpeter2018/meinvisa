import 'package:flutter/material.dart';
import 'package:meinvisa/core/debug/debug_logger.dart';

/// Enhanced autocomplete that shows derived information
class EnhancedAutocomplete extends StatefulWidget {
  final String? initialValue;
  final List<String> options;
  final String labelText;
  final String hintText;
  final Function(String) onSelected;
  final Future<Map<String, dynamic>> Function(String)? onFetchDetails;
  final String? fieldType; // 'profession', 'university', 'degree_field'

  const EnhancedAutocomplete({
    super.key,
    this.initialValue,
    required this.options,
    required this.labelText,
    required this.hintText,
    required this.onSelected,
    this.onFetchDetails,
    this.fieldType,
  });

  @override
  State<EnhancedAutocomplete> createState() => _EnhancedAutocompleteState();
}

class _EnhancedAutocompleteState extends State<EnhancedAutocomplete> {
  Map<String, dynamic>? _derivedInfo;
  bool _isLoadingDetails = false;

  Future<void> _handleSelection(String selection) async {
    // Save the selection
    widget.onSelected(selection);

    // Fetch and display derived details
    if (widget.onFetchDetails != null) {
      setState(() => _isLoadingDetails = true);

      try {
        final details = await widget.onFetchDetails!(selection);
        setState(() {
          _derivedInfo = details;
          _isLoadingDetails = false;
        });

        DebugLogger().log('✅ Fetched details for $selection: $details');
      } catch (e) {
        DebugLogger().error('❌ Error fetching details', e);
        setState(() => _isLoadingDetails = false);
      }
    }
  }

  Widget _buildDerivedInfoCard() {
    if (_derivedInfo == null || _derivedInfo!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Auto-populated information',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._buildDerivedInfoItems(),
        ],
      ),
    );
  }

  List<Widget> _buildDerivedInfoItems() {
    final items = <Widget>[];

    // For universities
    if (widget.fieldType == 'university') {
      if (_derivedInfo!['university_country'] != null) {
        items.add(
          _buildInfoRow(
            Icons.location_on,
            'Location',
            '${_derivedInfo!['city'] ?? ''}, ${_derivedInfo!['university_country']}',
          ),
        );
      }

      if (_derivedInfo!['is_recognized'] != null) {
        final isRecognized = _derivedInfo!['is_recognized'] as bool;
        items.add(
          _buildInfoRow(
            isRecognized ? Icons.verified : Icons.info,
            'Recognition',
            isRecognized ? 'Recognized in Germany' : 'May need recognition (Anerkennung)',
            color: isRecognized ? Colors.green : Colors.orange,
          ),
        );
      }
    }

    // For professions
    if (widget.fieldType == 'profession') {
      if (_derivedInfo!['is_it_field'] == true) {
        items.add(
          _buildInfoRow(
            Icons.computer,
            'Field',
            'IT/Software profession - Strong visa options available!',
            color: Colors.green,
          ),
        );
      }

      if (_derivedInfo!['is_healthcare'] == true) {
        items.add(
          _buildInfoRow(
            Icons.medical_services,
            'Field',
            'Healthcare profession - Recognition (Anerkennung) required',
            color: Colors.blue,
          ),
        );
      }

      if (_derivedInfo!['is_engineer'] == true) {
        items.add(
          _buildInfoRow(
            Icons.engineering,
            'Field',
            'Engineering profession - High demand in Germany',
            color: Colors.green,
          ),
        );
      }
    }

    // For degree fields
    if (widget.fieldType == 'degree_field') {
      if (_derivedInfo!['is_stem'] == true) {
        items.add(
          _buildInfoRow(
            Icons.science,
            'Field',
            'STEM field - Lower Blue Card salary threshold available',
            color: Colors.green,
          ),
        );
      }
    }

    return items;
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: color ?? Colors.blue[700]),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          initialValue: widget.initialValue != null
              ? TextEditingValue(text: widget.initialValue!)
              : null,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return widget.options.where(
              (option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()),
            );
          },
          onSelected: _handleSelection,
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            if (widget.initialValue != null && controller.text != widget.initialValue) {
              controller.text = widget.initialValue!;
            }
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: _isLoadingDetails
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              onEditingComplete: onEditingComplete,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Text(option, style: const TextStyle(fontSize: 14)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        if (_isLoadingDetails)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading additional information...',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        _buildDerivedInfoCard(),
      ],
    );
  }
}
