import 'package:flutter/material.dart';
import 'package:meinvisa/data/models/application_form_data_model/application_form_data_model.dart';
import 'package:meinvisa/data/models/visa_recommendation_response_model/visa_recommendation_response_model.dart';
import 'package:meinvisa/features/visa_application/widgets/edit_field_dialog.dart';

class PreFilledSection extends StatelessWidget {
  final List<PreFilledField> fields;
  final ApplicationFormData formData;
  final Function(String fieldKey, dynamic value) onEdit;
  final Function(String fieldKey) onVerify;

  const PreFilledSection({
    super.key,
    required this.fields,
    required this.formData,
    required this.onEdit,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    // Group fields by section
    final groupedFields = <String, List<PreFilledField>>{};
    for (final field in fields) {
      final section = field.formSection ?? 'Other';
      groupedFields.putIfAbsent(section, () => []).add(field);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600]),
                const SizedBox(width: 12),
                const Text(
                  'Pre-filled Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'We\'ve pre-filled ${fields.length} fields from your questionnaire. Please review and verify.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            // Sections
            ...groupedFields.entries.map((entry) => _buildSection(context, entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String sectionName,
    List<PreFilledField> sectionFields,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 16),
          child: Text(
            sectionName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        // Fields in this section
        ...sectionFields.map((field) => _buildFieldItem(context, field)),

        const Divider(height: 32),
      ],
    );
  }

  Widget _buildFieldItem(BuildContext context, PreFilledField field) {
    final currentValue = formData.getValue(field.formFieldKey);
    final isVerified = formData.isVerified(field.formFieldKey);
    final needsVerification = field.requiresVerification && !isVerified;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: needsVerification
            ? Colors.orange[50]
            : isVerified
            ? Colors.green[50]
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: needsVerification
              ? Colors.orange[200]!
              : isVerified
              ? Colors.green[200]!
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Field label and status
          Row(
            children: [
              Expanded(
                child: Text(
                  field.formFieldLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Confidence badge
              _buildConfidenceBadge(field.confidence),

              const SizedBox(width: 8),

              // Status icon
              Icon(
                needsVerification
                    ? Icons.warning_amber_rounded
                    : isVerified
                    ? Icons.check_circle
                    : Icons.info_outline,
                size: 18,
                color: needsVerification
                    ? Colors.orange[700]
                    : isVerified
                    ? Colors.green[700]
                    : Colors.grey[600],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Field value
          Row(
            children: [
              Expanded(
                child: Text(
                  currentValue?.toString() ?? field.value?.toString() ?? 'N/A',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          // Action buttons
          const SizedBox(height: 12),
          Row(
            children: [
              // Edit button
              TextButton.icon(
                onPressed: () => _showEditDialog(context, field, currentValue),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),

              const SizedBox(width: 8),

              // Verify button (only if needs verification)
              if (needsVerification)
                FilledButton.icon(
                  onPressed: () => onVerify(field.formFieldKey),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Verify'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),

              // Already verified badge
              if (isVerified && field.requiresVerification)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 14, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBadge(String confidence) {
    Color color;
    String label;

    switch (confidence.toLowerCase()) {
      case 'high':
        color = Colors.green;
        label = 'High';
        break;
      case 'medium':
        color = Colors.orange;
        label = 'Medium';
        break;
      case 'low':
        color = Colors.red;
        label = 'Low';
        break;
      default:
        color = Colors.grey;
        label = confidence;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  void _showEditDialog(BuildContext context, PreFilledField field, dynamic currentValue) {
    showDialog(
      context: context,
      builder: (context) => EditFieldDialog(
        fieldLabel: field.formFieldLabel,
        currentValue: currentValue ?? field.value,
        onSave: (newValue) {
          onEdit(field.formFieldKey, newValue);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
