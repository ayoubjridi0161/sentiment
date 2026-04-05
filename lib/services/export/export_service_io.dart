import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_template/domain/entity/sentiment_result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportService {
  static Future<String> exportToCSV(List<SentimentResult> results) async {
    try {
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
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/sentiment_analysis_$timestamp.csv');

      await file.writeAsString(csv);
      return file.path;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  static Future<void> exportToPDF(List<SentimentResult> results) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          header: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Sentiment Analysis Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Generated on: ${DateTime.now().toLocal()}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
              pw.Divider(),
            ],
          ),
          build: (_) => [
            ...results.map(
              (result) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(8),
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Text: ${result.text}',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Sentiment: ${result.sentiment.toUpperCase()}',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: result.sentiment.toLowerCase() == 'positive'
                                    ? PdfColors.green
                                    : PdfColors.red,
                              ),
                            ),
                            pw.Text(
                              'Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%',
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Analyzed: ${result.analyzedAt}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 16),
                ],
              ),
            ),
          ],
          footer: (context) => pw.Column(
            children: [
              pw.Divider(),
              pw.Text(
                'Total Analyses: ${results.length}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
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
