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


class QuizData {
  final String quizCode;
  final int questionNumber;
  final int level;
  final List<int> marksCounter;
  final List<int> prevMarks;
  final List<String> attemptedQuestions;

  QuizData({
    required this.quizCode,
    required this.questionNumber,
    required this.level,
    required this.marksCounter,
    required this.prevMarks,
    required this.attemptedQuestions,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      quizCode: json["quizCode"],
      questionNumber: json["questionNumber"],
      level: json["level"],
      marksCounter: List<int>.from(json["marksCounter"]),
      prevMarks: List<int>.from(json["prevMarks"]),
      attemptedQuestions: List<String>.from(json["attemptedQuestions"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "quizCode": quizCode,
    "questionNumber": questionNumber,
    "level": level,
    "marksCounter": marksCounter,
    "prevMarks": prevMarks,
    "attemptedQuestions": attemptedQuestions,
  };
}