import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';
import 'package:flutter_template/interactor/sentiment/sentiment_providers.dart';

// State class for sentiment analysis
class SentimentAnalysisState {
  final SentimentResult? result;
  final bool isLoading;
  final String? error;
  final String? errorCode;

  const SentimentAnalysisState({
    this.result,
    this.isLoading = false,
    this.error,
    this.errorCode,
  });

  SentimentAnalysisState copyWith({
    SentimentResult? result,
    bool? isLoading,
    String? error,
    String? errorCode,
  }) {
    return SentimentAnalysisState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  bool get hasError => error != null;
  bool get isEmpty => result == null && !isLoading && !hasError;
}

// Notifier for sentiment analysis
class SentimentAnalysisNotifier extends StateNotifier<SentimentAnalysisState> {
  final SentimentRepository repository;

  SentimentAnalysisNotifier({required this.repository})
      : super(const SentimentAnalysisState());

  Future<void> analyzeSentiment(String text) async {
    state = state.copyWith(isLoading: true, error: null, errorCode: null);
    try {
      final result = await repository.analyzeSentiment(text);
      state = state.copyWith(result: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        errorCode: _extractErrorCode(e),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null, errorCode: null);
  }

  void reset() {
    state = const SentimentAnalysisState();
  }

  String? _extractErrorCode(Object error) {
    final message = error.toString();
    if (message.contains('TIMEOUT')) return 'TIMEOUT';
    if (message.contains('RATE_LIMIT')) return 'RATE_LIMIT';
    if (message.contains('INVALID_KEY')) return 'INVALID_KEY';
    if (message.contains('NETWORK')) return 'NETWORK_ERROR';
    if (message.contains('EMPTY_TEXT')) return 'EMPTY_TEXT';
    return null;
  }
}

// Provider for sentiment analysis state
final sentimentAnalysisProvider =
    StateNotifierProvider<SentimentAnalysisNotifier, SentimentAnalysisState>(
        (ref) {
  final repository = ref.watch(sentimentRepositoryProvider);
  return SentimentAnalysisNotifier(repository: repository);
});

// State class for history
class SentimentHistoryState {
  final List<SentimentResult> results;
  final bool isLoading;
  final String? error;

  const SentimentHistoryState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  SentimentHistoryState copyWith({
    List<SentimentResult>? results,
    bool? isLoading,
    String? error,
  }) {
    return SentimentHistoryState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasError => error != null;
  bool get isEmpty => results.isEmpty && !isLoading && !hasError;
}

// Notifier for sentiment history
class SentimentHistoryNotifier extends StateNotifier<SentimentHistoryState> {
  final SentimentRepository repository;

  SentimentHistoryNotifier({required this.repository})
      : super(const SentimentHistoryState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await repository.getHistory();
      state = state.copyWith(results: results, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> refresh() {
    return _loadHistory();
  }

  Future<void> deleteResult(String id) async {
    try {
      await repository.deleteSentimentResult(id);
      state = state.copyWith(
        results: state.results.where((r) => r.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> clearAll() async {
    try {
      await repository.clearHistory();
      state = state.copyWith(results: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Provider for sentiment history state
final sentimentHistoryProvider =
    StateNotifierProvider<SentimentHistoryNotifier, SentimentHistoryState>(
        (ref) {
  final repository = ref.watch(sentimentRepositoryProvider);
  return SentimentHistoryNotifier(repository: repository);
});

// Notifier to track text input
class SentimentTextInputNotifier extends StateNotifier<String> {
  SentimentTextInputNotifier() : super('');

  void setText(String text) {
    state = text;
  }

  void clear() {
    state = '';
  }
}

// Provider for text input
final sentimentTextInputProvider =
    StateNotifierProvider<SentimentTextInputNotifier, String>((ref) {
  return SentimentTextInputNotifier();
});
