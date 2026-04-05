class SentimentResult {
  final String id;
  final String text;
  final String sentiment;
  final double confidence;
  final DateTime analyzedAt;

  const SentimentResult({
    required this.id,
    required this.text,
    required this.sentiment,
    required this.confidence,
    required this.analyzedAt,
  });

  factory SentimentResult.fromJson(Map<String, dynamic> json) {
    return SentimentResult(
      id: json['id'] as String,
      text: json['text'] as String,
      sentiment: json['sentiment'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sentiment': sentiment,
      'confidence': confidence,
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SentimentResult &&
        other.id == id &&
        other.text == text &&
        other.sentiment == sentiment &&
        other.confidence == confidence &&
        other.analyzedAt == analyzedAt;
  }

  @override
  int get hashCode => Object.hash(id, text, sentiment, confidence, analyzedAt);
}
