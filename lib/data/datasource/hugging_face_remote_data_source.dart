import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';

class HuggingFaceRequest {
  final String inputs;

  HuggingFaceRequest({required this.inputs});

  Map<String, dynamic> toJson() => {
        'inputs': inputs,
      };
}

class HuggingFaceResponse {
  final List<Map<String, dynamic>> scores;

  HuggingFaceResponse({required this.scores});

  factory HuggingFaceResponse.fromJson(List<dynamic> json) {
    try {
      final scores = (json.first as Map<String, dynamic>)['scores'] ??
          (json as List<dynamic>)
              .map((item) => item as Map<String, dynamic>)
              .toList();

      if (scores is List<dynamic>) {
        return HuggingFaceResponse(
          scores: scores.cast<Map<String, dynamic>>(),
        );
      }

      return HuggingFaceResponse(scores: []);
    } catch (e) {
      throw SentimentAnalysisException(
        message: 'Failed to parse sentiment response: $e',
        code: 'PARSE_ERROR',
      );
    }
  }

  String getSentiment() {
    if (scores.isEmpty) return 'neutral';

    // Assuming the API returns [positive, negative] or similar
    // For distilbert model: scores has label and score
    final positive = scores.firstWhere(
      (item) => (item['label'] ?? '').toString().toLowerCase().contains('positive'),
      orElse: () => {},
    );

    if (positive.isNotEmpty) {
      return positive['label'].toString().toLowerCase().contains('positive')
          ? 'positive'
          : 'negative';
    }

    return 'neutral';
  }

  double getConfidence() {
    if (scores.isEmpty) return 0.0;

    final score = scores.first['score'] as num?;
    return (score ?? 0.0).toDouble();
  }
}

class HuggingFaceRemoteDataSource {
  final Dio dio;

  HuggingFaceRemoteDataSource({required this.dio}) {
    _initializeClient();
  }

  void _initializeClient() {
    final apiKey = dotenv.env['HUGGING_FACE_API_KEY'] ?? '';
    final baseUrl = dotenv.env['HUGGING_FACE_BASE_URL'] ?? '';

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Add authorization header
    dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  Future<HuggingFaceResponse> analyzeSentiment(String text) async {
    try {
      final model = dotenv.env['HUGGING_FACE_MODEL'] ??
          'distilbert-base-uncased-finetuned-sst-2-english';

      final response = await dio.post(
        'models/$model',
        data: HuggingFaceRequest(inputs: text).toJson(),
      );

      if (response.statusCode == 200 && response.data is List) {
        return HuggingFaceResponse.fromJson(response.data);
      }

      throw SentimentAnalysisException(
        message: 'Unexpected response format from API',
        code: 'INVALID_RESPONSE',
      );
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  void _handleDioException(DioException e) {
    String message = 'Network error occurred';
    String? code;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        message = 'Request timeout. Please check your connection.';
        code = 'TIMEOUT';
        break;
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          message = 'Rate limit exceeded. Please try again later.';
          code = 'RATE_LIMIT';
        } else if (statusCode == 401) {
          message = 'Invalid API key. Please check your configuration.';
          code = 'INVALID_KEY';
        } else if (statusCode == 404) {
          message = 'Model not found.';
          code = 'MODEL_NOT_FOUND';
        } else {
          message = 'Server error: $statusCode';
          code = 'SERVER_ERROR';
        }
        break;
      case DioExceptionType.unknown:
        if (e.error is! SentimentAnalysisException) {
          message = 'Unknown error occurred';
          code = 'UNKNOWN';
        }
        break;
      default:
        message = 'Network error: ${e.message}';
        code = 'NETWORK_ERROR';
    }

    throw SentimentAnalysisException(
      message: message,
      code: code,
    );
  }
}
