import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_template/interactor/sentiment/sentiment_notifiers.dart';
import 'package:flutter_template/presentation/destinations/sentiment/widgets/sentiment_result_card.dart';
import 'package:flutter_template/presentation/destinations/sentiment/widgets/sentiment_input_field.dart';
import 'package:flutter_template/presentation/destinations/sentiment/widgets/sentiment_history_view.dart';

class SentimentAnalyzerScreen extends HookConsumerWidget {
  const SentimentAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(sentimentAnalysisProvider);
    final historyState = ref.watch(sentimentHistoryProvider);
    final textInput = ref.watch(sentimentTextInputProvider);
    final analyzeNotifier = ref.read(sentimentAnalysisProvider.notifier);
    final historyNotifier = ref.read(sentimentHistoryProvider.notifier);
    final textNotifier = ref.read(sentimentTextInputProvider.notifier);

    final showHistory = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentiment Analyzer'),
        elevation: 0,
        actions: [
          if (historyState.results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => showHistory.value = !showHistory.value,
              tooltip: 'View History',
            ),
        ],
      ),
      body: showHistory.value
          ? SentimentHistoryView(
              state: historyState,
              onDelete: (id) => historyNotifier.deleteResult(id),
              onClear: () => historyNotifier.clearAll(),
              onBack: () => showHistory.value = false,
            )
          : _buildAnalyzerView(
              context,
              analysisState,
              textInput,
              analyzeNotifier,
              textNotifier,
            ),
    );
  }

  Widget _buildAnalyzerView(
    BuildContext context,
    SentimentAnalysisState analysisState,
    String textInput,
    SentimentAnalysisNotifier analyzeNotifier,
    SentimentTextInputNotifier textNotifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input section
          SentimentInputField(
            value: textInput,
            onChanged: (text) => textNotifier.setText(text),
            onAnalyze: () => analyzeNotifier.analyzeSentiment(textInput),
            isLoading: analysisState.isLoading,
            isEnabled: !analysisState.isLoading,
          ),
          const SizedBox(height: 24),
          // Result section
          if (analysisState.isLoading)
            _buildLoadingState()
          else if (analysisState.hasError)
            _buildErrorState(context, analysisState)
          else if (analysisState.result != null)
            SentimentResultCard(result: analysisState.result!)
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Analyzing sentiment...'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, SentimentAnalysisState state) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.sentiment_satisfied,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter text to analyze',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
