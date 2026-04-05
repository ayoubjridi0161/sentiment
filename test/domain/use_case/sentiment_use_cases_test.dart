import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';
import 'package:flutter_template/domain/use_case/analyze_sentiment_use_case.dart';
import 'package:flutter_template/domain/use_case/sentiment_history_use_cases.dart';

class MockSentimentRepository extends Mock implements SentimentRepository {}

void main() {
  late AnalyzeSentimentUseCase analyzeSentimentUseCase;
  late GetSentimentHistoryUseCase getSentimentHistoryUseCase;
  late DeleteSentimentResultUseCase deleteSentimentResultUseCase;
  late ClearSentimentHistoryUseCase clearSentimentHistoryUseCase;
  late MockSentimentRepository mockRepository;

  setUp(() {
    mockRepository = MockSentimentRepository();
    analyzeSentimentUseCase = AnalyzeSentimentUseCase(
      repository: mockRepository,
    );
    getSentimentHistoryUseCase = GetSentimentHistoryUseCase(
      repository: mockRepository,
    );
    deleteSentimentResultUseCase = DeleteSentimentResultUseCase(
      repository: mockRepository,
    );
    clearSentimentHistoryUseCase = ClearSentimentHistoryUseCase(
      repository: mockRepository,
    );
  });

  group('AnalyzeSentimentUseCase', () {
    test('throws when text is empty', () async {
      expect(
        () => analyzeSentimentUseCase.call(''),
        throwsA(isA<SentimentAnalysisException>()),
      );
    });

    test('throws when text is whitespace', () async {
      expect(
        () => analyzeSentimentUseCase.call('   '),
        throwsA(isA<SentimentAnalysisException>()),
      );
    });

    test('returns repository result for valid text', () async {
      const testText = 'This is a great product!';
      final testResult = SentimentResult(
        id: '1',
        text: testText,
        sentiment: 'positive',
        confidence: 0.95,
        analyzedAt: DateTime(2026),
      );

      when(() => mockRepository.analyzeSentiment(testText))
          .thenAnswer((_) async => testResult);

      final result = await analyzeSentimentUseCase.call(testText);

      expect(result, equals(testResult));
      verify(() => mockRepository.analyzeSentiment(testText)).called(1);
    });
  });

  group('GetSentimentHistoryUseCase', () {
    test('returns history from repository', () async {
      final testResults = [
        SentimentResult(
          id: '1',
          text: 'Great!',
          sentiment: 'positive',
          confidence: 0.9,
          analyzedAt: DateTime(2026),
        ),
        SentimentResult(
          id: '2',
          text: 'Bad!',
          sentiment: 'negative',
          confidence: 0.85,
          analyzedAt: DateTime(2026),
        ),
      ];

      when(() => mockRepository.getHistory()).thenAnswer((_) async => testResults);

      final result = await getSentimentHistoryUseCase.call();

      expect(result, hasLength(2));
      expect(result.first.sentiment, 'positive');
      verify(() => mockRepository.getHistory()).called(1);
    });

    test('returns empty list when no history exists', () async {
      when(() => mockRepository.getHistory()).thenAnswer((_) async => []);

      final result = await getSentimentHistoryUseCase.call();

      expect(result, isEmpty);
      verify(() => mockRepository.getHistory()).called(1);
    });
  });

  group('DeleteSentimentResultUseCase', () {
    test('calls repository delete method', () async {
      const id = 'test-id';
      when(() => mockRepository.deleteSentimentResult(id))
          .thenAnswer((_) async {});

      await deleteSentimentResultUseCase.call(id);

      verify(() => mockRepository.deleteSentimentResult(id)).called(1);
    });
  });

  group('ClearSentimentHistoryUseCase', () {
    test('calls repository clear history method', () async {
      when(() => mockRepository.clearHistory()).thenAnswer((_) async {});

      await clearSentimentHistoryUseCase.call();

      verify(() => mockRepository.clearHistory()).called(1);
    });
  });
}
