import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';

class GetSentimentHistoryUseCase {
  final SentimentRepository repository;

  GetSentimentHistoryUseCase({required this.repository});

  Future<List<SentimentResult>> call() {
    return repository.getHistory();
  }
}

class DeleteSentimentResultUseCase {
  final SentimentRepository repository;

  DeleteSentimentResultUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteSentimentResult(id);
  }
}

class ClearSentimentHistoryUseCase {
  final SentimentRepository repository;

  ClearSentimentHistoryUseCase({required this.repository});

  Future<void> call() {
    return repository.clearHistory();
  }
}
