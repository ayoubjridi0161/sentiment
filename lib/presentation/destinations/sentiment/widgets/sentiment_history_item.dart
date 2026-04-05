import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';

class SentimentHistoryItem extends StatelessWidget {
  final SentimentResult result;

  const SentimentHistoryItem({
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(sentimentIcon, color: sentimentColor),
        title: Text(
          result.text.length > 50
              ? '${result.text.substring(0, 50)}...'
              : result.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: sentimentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result.sentiment.toUpperCase(),
                    style: TextStyle(
                      color: sentimentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(result.confidence * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('emotion.datetime_format'.tr())
                  .format(result.analyzedAt),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
