class Question {
  final String id;
  final String text;
  final String category;
  final bool favorite;

  Question({
    required this.id,
    required this.text,
    required this.category,
    required this.favorite,
  });

  factory Question.fromRecord(Map<String, dynamic> record) {
    return Question(
      id: record['id'] ?? '',
      text: record['text'] ?? '',
      category: record['category'] ?? '',
      favorite: record['favorite'] ?? false,
    );
  }
}
