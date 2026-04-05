import 'dart:html' as html;
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static Future<String> exportToCSV(List<SentimentResult> results) async {
    final rows = <List<dynamic>>[
      ['Text', 'Sentiment', 'Confidence (%)', 'Analyzed At'],
      ...results.map((result) => [
            result.text,
            result.sentiment.toUpperCase(),
            (result.confidence * 100).toStringAsFixed(2),
            result.analyzedAt.toIso8601String(),
          ]),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = 'sentiment_analysis.csv'
      ..click();
    html.Url.revokeObjectUrl(url);
    return 'sentiment_analysis.csv';
  }

  static Future<void> exportToPDF(List<SentimentResult> results) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => results
            .map(
              (result) => pw.Text(
                '${result.text} - ${result.sentiment} - ${(result.confidence * 100).toStringAsFixed(1)}%',
              ),
            )
            .toList(),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static Map<String, dynamic> getSummaryStatistics(
    List<SentimentResult> results,
  ) {
    if (results.isEmpty) {
      return {
        'total': 0,
        'positive': 0,
        'negative': 0,
        'average_confidence': 0.0,
      };
    }

    final positiveCount = results.where((r) => r.sentiment.toLowerCase() == 'positive').length;
    final negativeCount = results.length - positiveCount;
    final averageConfidence = results.fold<double>(0, (sum, r) => sum + r.confidence) / results.length;

    return {
      'total': results.length,
      'positive': positiveCount,
      'negative': negativeCount,
      'average_confidence': averageConfidence,
    };
  }
}
