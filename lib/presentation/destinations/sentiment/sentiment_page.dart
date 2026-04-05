import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/destinations/sentiment/sentiment_analyzer_screen.dart';

@RoutePage()
class SentimentPage extends StatelessWidget {
  static const String path = '/sentiment';

  const SentimentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SentimentAnalyzerScreen();
  }
}
