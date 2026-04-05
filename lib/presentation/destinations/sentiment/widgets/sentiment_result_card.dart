import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';

class SentimentResultCard extends StatelessWidget {
  final SentimentResult result;

  const SentimentResultCard({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSentimentPositive = result.sentiment.toLowerCase() == 'positive';
    final sentimentColor = isSentimentPositive ? Colors.green : Colors.red;
    final sentimentIcon = isSentimentPositive
        ? Icons.sentiment_satisfied_alt
        : Icons.sentiment_dissatisfied;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              sentimentIcon,
              size: 64,
              color: sentimentColor,
            ),
            const SizedBox(height: 16),
            // Sentiment label
            Text(
              result.sentiment.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: sentimentColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Confidence score
            Column(
              children: [
                Text(
                  'emotion.confidence_label'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: result.confidence,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      sentimentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(result.confidence * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Analyzed text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'emotion.analyzed_text_label'.tr(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Timestamp
            Text(
              DateFormat('emotion.datetime_format'.tr())
                  .format(result.analyzedAt),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
