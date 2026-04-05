import 'package:flutter_template/domain/entity/sentiment_result.dart';

abstract class SentimentRepository {
  /// Analyze the sentiment of the given [text]
  /// Throws [SentimentAnalysisException] if analysis fails
  Future<SentimentResult> analyzeSentiment(String text);

  /// Get all previous sentiment analyses
  Future<List<SentimentResult>> getHistory();

  /// Save sentiment analysis to history
  Future<void> saveSentimentResult(SentimentResult result);

  /// Delete a sentiment result by ID
  Future<void> deleteSentimentResult(String id);

  /// Clear all history
  Future<void> clearHistory();
}

class SentimentAnalysisException implements Exception {
  final String message;
  final String? code;

  SentimentAnalysisException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}
