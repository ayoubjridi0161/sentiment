import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SentimentInputField extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final VoidCallback onAnalyze;
  final bool isLoading;
  final bool isEnabled;

  const SentimentInputField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.onAnalyze,
    this.isLoading = false,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'emotion.input_label'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          enabled: isEnabled,
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(
            hintText: 'emotion.input_hint'.tr(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: isEnabled && !isLoading && value.trim().isNotEmpty
              ? onAnalyze
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text('emotion.analyze_button'.tr()),
        ),
      ],
    );
  }
}
