import 'dart:convert';

import 'package:flutter_template/data/datasource/assembly_ai_remote_data_source.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SentimentRepositoryImpl implements SentimentRepository {
  final ApiNinjasRemoteDataSource remoteDataSource;
  final SharedPreferences preferences;

  static const String _historyKey = 'sentiment_history';

  SentimentRepositoryImpl({
    required this.remoteDataSource,
    required this.preferences,
  });

  @override
  Future<SentimentResult> analyzeSentiment(String text) async {
    // Call the remote API
    final response = await remoteDataSource.analyzeSentiment(text);

    // Create a sentiment result
    final result = SentimentResult(
      id: const Uuid().v4(),
      text: text,
      sentiment: response.getSentiment(),
      confidence: response.getConfidence(),
      analyzedAt: DateTime.now(),
    );

    await saveSentimentResult(result);

    return result;
  }

  @override
  Future<List<SentimentResult>> getHistory() async {
    final historyJson = preferences.getStringList(_historyKey) ?? const [];
    return historyJson
        .map((item) => SentimentResult.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ))
        .toList()
      ..sort((left, right) => right.analyzedAt.compareTo(left.analyzedAt));
  }

  @override
  Future<void> saveSentimentResult(SentimentResult result) async {
    final currentHistory = await getHistory();
    final updatedHistory = [result, ...currentHistory]
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();
    await preferences.setStringList(_historyKey, updatedHistory);
  }

  @override
  Future<void> deleteSentimentResult(String id) async {
    final currentHistory = await getHistory();
    final updatedHistory = currentHistory
        .where((entry) => entry.id != id)
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();
    await preferences.setStringList(_historyKey, updatedHistory);
  }

  @override
  Future<void> clearHistory() async {
    await preferences.remove(_historyKey);
  }
}
