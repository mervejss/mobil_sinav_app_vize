class Question {
  String id;
  String questionText;
  List<String> options;
  String correctAnswer;
  bool isMultipleChoice;
  bool isMultiAnswer;
  bool isOpenEnded;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.isMultipleChoice,
    required this.isMultiAnswer,
    required this.isOpenEnded,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'isMultipleChoice': isMultipleChoice,
      'isMultiAnswer': isMultiAnswer,
      'isOpenEnded': isOpenEnded,
    };
  }

  static Question fromMap(String id, Map<String, dynamic> data) {
    return Question(
      id: id,
      questionText: data['questionText'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      isMultipleChoice: data['isMultipleChoice'] ?? false,
      isMultiAnswer: data['isMultiAnswer'] ?? false,
      isOpenEnded: data['isOpenEnded'] ?? false,
    );
  }
}
