# Sentiment Analyzer - Implementation Guide

This document provides detailed information about the Sentiment Analyzer feature implementation.

## Overview

The Sentiment Analyzer is a Flutter mobile application that performs real-time sentiment analysis on user-provided text using the Hugging Face Inference API. It features local history persistence, multi-language support, and comprehensive error handling.

## Core Features

### 1. Real-time Sentiment Analysis
- Users input text and receive immediate sentiment classification
- Sentiments are classified as Positive or Negative
- Confidence scores range from 0-100%

### 2. Local History Management
- All analyses are automatically saved to local SQLite database (via Drift)
- History persists across app sessions
- Users can view, delete, or clear history
- Most recent analyses appear first

### 3. Data Export
- Export history as CSV file for spreadsheet analysis
- Export history as PDF report for documentation
- Both formats include metadata (sentiment, confidence, timestamp)

### 4. Error Handling
The application gracefully handles:
- **Network Timeouts**: Connection timeout errors
- **Rate Limiting (429)**: API rate limit exceeded
- **Invalid API Key (401)**: Authentication failures
- **Network Errors**: General connection issues
- **Malformed Responses**: Invalid API response formats
- **Empty Input**: Validation of user input

### 5. Internationalization
Supported languages:
- English (en-US)
- Hindi (hi-IN)
- Arabic (ar-SA)

### 6. Theme Support
- Light and Dark modes
- Material Design 3 components
- System theme integration
- Dynamic color support (Android 12+)

## Architecture

### Clean Architecture Implementation

```
┌─────────────────────────────────────────┐
│       Presentation Layer (UI)           │
│  - Screens, Widgets, State Management   │
└──────────────────┬──────────────────────┘
                   ↑ Depends on
┌──────────────────┴──────────────────────┐
│       Interactor Layer (Providers)      │
│  - Riverpod StateNotifiers & Providers  │
└──────────────────┬──────────────────────┘
                   ↑ Depends on
┌──────────────────┴──────────────────────┐
│       Domain Layer (Business Logic)     │
│  - Entities, Repositories, Use Cases    │
└──────────────────┬──────────────────────┘
                   ↑ Depends on
┌──────────────────┴──────────────────────┐
│    Data Layer (Data Sources)            │
│  - API Services, Database, Repositories │
└─────────────────────────────────────────┘
```

### Layer Details

#### Domain Layer
**Location**: `lib/domain/`

- **Entities** (`entity/sentiment_result.dart`):
  - `SentimentResult`: Immutable data class with Freezed
  - Fields: id, text, sentiment, confidence, analyzedAt

- **Repository Contracts** (`repository/sentiment_repository.dart`):
  - `SentimentRepository`: Abstract interface
  - Methods: analyzeSentiment(), getHistory(), saveSentimentResult(), deleteSentimentResult(), clearHistory()
  - `SentimentAnalysisException`: Custom exception

- **Use Cases** (`use_case/`):
  - `AnalyzeSentimentUseCase`: Validates input and calls repository
  - `GetSentimentHistoryUseCase`: Retrieves all analyses
  - `DeleteSentimentResultUseCase`: Deletes specific analysis
  - `ClearSentimentHistoryUseCase`: Clears all analyses

#### Data Layer
**Location**: `lib/data/`

- **Remote Data Source** (`datasource/hugging_face_remote_data_source.dart`):
  - `HuggingFaceRemoteDataSource`: API client wrapper
  - Handles Dio HTTP requests to Hugging Face API
  - Parses API responses
  - Comprehensive error handling

- **Local Data Source** (`local/app_database.dart`):
  - Drift database implementation
  - SQLite database file (`sentiment_analysis.db`)
  - Type-safe queries and migrations

- **Repository Implementation** (`repository/sentiment_repository_impl.dart`):
  - Coordinates between remote and local data sources
  - Saves results immediately after API analysis
  - Returns combined results

#### Presentation Layer
**Location**: `lib/presentation/destinations/sentiment/`

- **Screens**:
  - `SentimentAnalyzerScreen`: Main analysis screen
  - Real-time input with analysis button
  - Result display card
  - History view with export options

- **Widgets**:
  - `SentimentInputField`: Text input with character count
  - `SentimentResultCard`: Displays analysis results visually
  - `SentimentHistoryView`: Lists past analyses
  - `SentimentHistoryItem`: Individual history entry

- **State Management**:
  - Riverpod providers for dependency injection
  - StateNotifiers for business logic
  - Reactive state updates

#### Interactor Layer
**Location**: `lib/interactor/sentiment/`

- **Providers** (`sentiment_providers.dart`):
  - Database provider
  - HTTP client provider (Dio)
  - Remote data source provider
  - Repository provider
  - Use case providers

- **State Notifiers** (`sentiment_notifiers.dart`):
  - `SentimentAnalysisNotifier`: Handles sentiment analysis state
  - `SentimentHistoryNotifier`: Manages history state
  - `SentimentTextInputNotifier`: Tracks user input

#### Services Layer
**Location**: `lib/services/export/`

- **ExportService** (`export_service.dart`):
  - `exportToCSV()`: Generates CSV file
  - `exportToPDF()`: Generates PDF report
  - `getSummaryStatistics()`: Calculates history statistics

## State Management

### Riverpod Architecture

The app uses Riverpod for state management with these key providers:

1. **Infrastructure Providers**:
   - `appDatabaseProvider`: Drift database instance
   - `dioProvider`: HTTP client
   - `huggingFaceRemoteDataSourceProvider`: API service

2. **Repository Provider**:
   - `sentimentRepositoryProvider`: Main repository instance

3. **Use Case Providers**:
   - `analyzeSentimentUseCaseProvider`
   - `getSentimentHistoryUseCaseProvider`
   - `deleteSentimentResultUseCaseProvider`
   - `clearSentimentHistoryUseCaseProvider`

4. **State Providers**:
   - `sentimentAnalysisProvider`: StateNotifierProvider for analysis
   - `sentimentHistoryProvider`: StateNotifierProvider for history
   - `sentimentTextInputProvider`: StateNotifierProvider for user input

### State Classes

```dart
// Sentiment Analysis State
class SentimentAnalysisState {
  final SentimentResult? result;
  final bool isLoading;
  final String? error;
  final String? errorCode;
}

// Sentiment History State
class SentimentHistoryState {
  final List<SentimentResult> results;
  final bool isLoading;
  final String? error;
}
```

## Database Schema

### SentimentAnalysisTable
```sql
CREATE TABLE sentiment_analysis_table (
  id TEXT PRIMARY KEY,
  text TEXT NOT NULL,
  sentiment TEXT NOT NULL,
  confidence REAL NOT NULL,
  analyzed_at DATETIME NOT NULL
)
```

### Indexes
- Primary key on `id` for fast lookups

## API Integration

### Hugging Face API

**Endpoint**: `POST /models/{model_id}`

**Model**: `distilbert-base-uncased-finetuned-sst-2-english`

**Request Format**:
```json
{
  "inputs": "This is great!"
}
```

**Response Format**:
```json
[
  [
    {
      "label": "POSITIVE",
      "score": 0.9995
    },
    {
      "label": "NEGATIVE",
      "score": 0.0005
    }
  ]
]
```

**Authentication**: Bearer token in `Authorization` header

**Base URL**: `https://api-inference.huggingface.co/`

## Error Handling Strategy

### Error Types

1. **Network Errors**:
   - Timeout: "Request timeout. Please check your connection."
   - Connection: "Network error occurred"

2. **HTTP Errors**:
   - 401: "Invalid API key. Please check your configuration."
   - 429: "Rate limit exceeded. Please try again later."
   - 404: "Model not found."
   - 5xx: "Server error: {code}"

3. **Validation Errors**:
   - Empty text: "Text cannot be empty"
   - Parse error: "Failed to parse sentiment response"

4. **Response Errors**:
   - Malformed JSON: "Unexpected response format from API"

### Error Recovery

- User is shown meaningful error messages
- Error codes help distinguish between different failure scenarios
- Clear button to retry analysis
- Automatic fallback to last successful result

## Testing

### Unit Tests
Location: `test/domain/use_case/sentiment_use_cases_test.dart`

Tests cover:
- Empty input validation
- Valid sentiment analysis
- History retrieval
- Result deletion
- History clearing

### Widget Tests
Can be added to test UI components:
- Input field validation
- Result card display
- History list rendering
- Export functionality

### Integration Tests
Available in `integration_test/`

## Configuration

### Environment Variables

All environments require:
```env
HUGGING_FACE_API_KEY=your_api_key
HUGGING_FACE_BASE_URL=https://api-inference.huggingface.co/
HUGGING_FACE_MODEL=distilbert-base-uncased-finetuned-sst-2-english
```

### Feature Flags

Can be added for:
- Enable/disable offline mode
- Toggle between sentiment models
- Control history retention

## Performance Considerations

1. **Database Optimization**:
   - Indexed queries on `id`
   - Lazy loading of history with pagination (future enhancement)

2. **API Optimization**:
   - Request debouncing (future enhancement)
   - Response caching (future enhancement)

3. **UI Optimization**:
   - Efficient rebuilds with Riverpod selectors
   - Lazy loading of list items
   - Image caching for avatars

4. **Memory Management**:
   - Stream cleanup in StateNotifiers
   - Provider disposal
   - Database connection pooling

## Future Enhancements

1. **Analytics**:
   - Sentiment trends over time
   - Category-based analysis
   - Statistics dashboard

2. **Advanced Features**:
   - Batch sentiment analysis
   - Custom models support
   - Real-time streaming analysis

3. **Optimization**:
   - Offline sentiment analysis with on-device models
   - Response caching
   - Pagination for history

4. **Integration**:
   - Social media sentiment tracking
   - Email/message analysis
   - Document sentiment analysis

## Troubleshooting

### Common Issues

**Issue**: API key not working
**Solution**: Verify key at huggingface.co, check `.env` file format

**Issue**: Database not persisting
**Solution**: Check app permissions, verify Drift code generation ran

**Issue**: UI not updating
**Solution**: Ensure Riverpod providers are properly watched

**Issue**: Export not working
**Solution**: Check app permissions for file access

## References

- [Hugging Face Documentation](https://huggingface.co/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Drift Database Documentation](https://drift.simonbinder.eu)
- [Flutter Documentation](https://flutter.dev/docs)

---

**Last Updated**: 2024
**Version**: 1.0
**Status**: Production Ready
