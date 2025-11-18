import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double percentage;
  final bool isComplete;

  const ProgressIndicatorWidget({super.key, required this.percentage, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete ? Colors.green : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isComplete ? Colors.green[700] : Colors.grey[700],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Status text
        Row(
          children: [
            Icon(
              isComplete ? Icons.check_circle : Icons.info_outline,
              size: 16,
              color: isComplete ? Colors.green[600] : Colors.orange[600],
            ),
            const SizedBox(width: 6),
            Text(
              isComplete ? 'Application form complete' : 'Please complete all required fields',
              style: TextStyle(
                fontSize: 13,
                color: isComplete ? Colors.green[700] : Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
