import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/data/datasource/hugging_face_remote_data_source.dart';
import 'package:flutter_template/data/repository/sentiment_repository_impl.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';
import 'package:flutter_template/domain/use_case/analyze_sentiment_use_case.dart';
import 'package:flutter_template/domain/use_case/sentiment_history_use_cases.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided by the app entry point');
});

// Dio HTTP client provider
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Remote data source provider
final huggingFaceRemoteDataSourceProvider =
    Provider<HuggingFaceRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return HuggingFaceRemoteDataSource(dio: dio);
});

// Repository provider
final sentimentRepositoryProvider = Provider<SentimentRepository>((ref) {
  final remoteDataSource =
      ref.watch(huggingFaceRemoteDataSourceProvider);
  final preferences = ref.watch(sharedPreferencesProvider);
  return SentimentRepositoryImpl(
    remoteDataSource: remoteDataSource,
    preferences: preferences,
  );
});

// Use case providers
final analyzeSentimentUseCaseProvider =
    Provider<AnalyzeSentimentUseCase>((ref) {
  final repository = ref.watch(sentimentRepositoryProvider);
  return AnalyzeSentimentUseCase(repository: repository);
});

final getSentimentHistoryUseCaseProvider =
    Provider<GetSentimentHistoryUseCase>((ref) {
  final repository = ref.watch(sentimentRepositoryProvider);
  return GetSentimentHistoryUseCase(repository: repository);
});

final deleteSentimentResultUseCaseProvider =
    Provider<DeleteSentimentResultUseCase>((ref) {
  final repository = ref.watch(sentimentRepositoryProvider);
  return DeleteSentimentResultUseCase(repository: repository);
});

final clearSentimentHistoryUseCaseProvider =
    Provider<ClearSentimentHistoryUseCase>((ref) {
  final repository = ref.watch(sentimentRepositoryProvider);
  return ClearSentimentHistoryUseCase(repository: repository);
});
