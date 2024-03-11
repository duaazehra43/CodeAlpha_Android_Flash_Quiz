class Flashcard {
  final String question;
  final bool isTrue;

  Flashcard({required this.question, required this.isTrue});
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'isTrue': isTrue,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      isTrue: json['isTrue'],
    );
  }
}
