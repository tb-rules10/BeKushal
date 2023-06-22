class Question {
  final String questionNo;
  final String questionPath;
  final String answer;

  Question({
    required this.questionNo,
    required this.questionPath,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionNo: json["questionNo"],
      questionPath: json["path"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() => {
    "questionNo": questionNo,
    "path": questionPath,
    "answer": answer,
  };
}