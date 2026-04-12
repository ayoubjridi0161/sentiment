import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_template/domain/repository/sentiment_repository.dart';

class ApiNinjasRequest {
  final String text;

  ApiNinjasRequest({required this.text});

  Map<String, dynamic> toJson() => {
        'text': text,
      };
}

class ApiNinjasResponse {
  final double positive;
  final double negative;
  final double neutral;

  ApiNinjasResponse({
    required this.positive,
    required this.negative,
    required this.neutral,
  });

  factory ApiNinjasResponse.fromJson(Map<String, dynamic> json) {
    return ApiNinjasResponse(
      positive: (json['positive'] as num?)?.toDouble() ?? 0.0,
      negative: (json['negative'] as num?)?.toDouble() ?? 0.0,
      neutral: (json['neutral'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String getSentiment() {
    if (positive > negative && positive > neutral) return 'positive';
    if (negative > positive && negative > neutral) return 'negative';
    return 'neutral';
  }

  double getConfidence() {
    return [positive, negative, neutral].reduce((a, b) => a > b ? a : b);
  }
}

class ApiNinjasRemoteDataSource {
  final Dio dio;

  ApiNinjasRemoteDataSource({required this.dio}) {
    _initializeClient();
  }

  void _initializeClient() {
    final apiKey = dotenv.env['API_NINJAS_API_KEY'] ?? '';
    final baseUrl = dotenv.env['API_NINJAS_BASE_URL'] ?? 'https://api.api-ninjas.com/v1';

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    dio.options.headers = {
      'X-Api-Key': apiKey,
      'Content-Type': 'application/json',
    };
  }

  Future<ApiNinjasResponse> analyzeSentiment(String text) async {
    try {
      final response = await dio.post(
        '/sentiment',
        data: ApiNinjasRequest(text: text).toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ApiNinjasResponse.fromJson(response.data);
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
        } else if (statusCode == 401 || statusCode == 403) {
          message = 'Invalid API key. Please check your configuration.';
          code = 'INVALID_KEY';
        } else if (statusCode == 400) {
          message = 'Bad request. Text may be too long or invalid.';
          code = 'BAD_REQUEST';
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
