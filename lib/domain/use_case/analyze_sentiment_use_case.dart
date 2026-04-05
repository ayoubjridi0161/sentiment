import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';

class AnalyzeSentimentUseCase {
  final SentimentRepository repository;

  AnalyzeSentimentUseCase({required this.repository});

  Future<SentimentResult> call(String text) async {
    if (text.trim().isEmpty) {
      throw SentimentAnalysisException(
        message: 'Text cannot be empty',
        code: 'EMPTY_TEXT',
      );
    }
    return repository.analyzeSentiment(text);
  }
}
