import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/interactor/sentiment/sentiment_notifiers.dart';
import 'package:flutter_template/presentation/destinations/sentiment/widgets/sentiment_history_item.dart';
import 'package:flutter_template/services/export/export_service.dart';

class SentimentHistoryView extends StatelessWidget {
  final SentimentHistoryState state;
  final Function(String) onDelete;
  final VoidCallback onClear;
  final VoidCallback onBack;

  const SentimentHistoryView({
    super.key,
    required this.state,
    required this.onDelete,
    required this.onClear,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'emotion.history_title'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (state.results.isNotEmpty)
                Row(
                  children: [
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.download),
                      itemBuilder: (BuildContext context) => const [
                        PopupMenuItem<String>(
                          value: 'csv',
                          child: Row(
                            children: [
                              Icon(Icons.table_chart),
                              SizedBox(width: 8),
                              Text('Export as CSV'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'pdf',
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf),
                              SizedBox(width: 8),
                              Text('Export as PDF'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (String value) async {
                        if (value == 'csv') {
                          try {
                            await ExportService.exportToCSV(state.results);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('CSV exported successfully'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Export failed: $e')),
                              );
                            }
                          }
                        } else if (value == 'pdf') {
                          try {
                            await ExportService.exportToPDF(state.results);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Export failed: $e')),
                              );
                            }
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep),
                      onPressed: _showClearConfirmation(context),
                      tooltip: 'emotion.clear_history_tooltip'.tr(),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Expanded(
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.hasError
                  ? _buildErrorWidget(context)
                  : state.isEmpty
                      ? _buildEmptyWidget(context)
                      : _buildHistoryList(context),
        ),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final result = state.results[index];
        return Dismissible(
          key: Key(result.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onDelete(result.id),
          child: SentimentHistoryItem(result: result),
        );
      },
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text('emotion.history_empty'.tr()),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(state.error ?? 'An error occurred'),
        ],
      ),
    );
  }

  VoidCallback _showClearConfirmation(BuildContext context) {
    return () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('emotion.confirm_clear_title'.tr()),
          content: Text('emotion.confirm_clear_message'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('emotion.cancel_button'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onClear();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('emotion.clear_button'.tr()),
            ),
          ],
        ),
      );
    };
  }
}
