class Question {
  int number;
  String name;
  bool isActive = true;

  Question(int number, String name, {bool isActive: true}) {
    this.number = number;
    this.name = name;
    this.isActive = isActive;
  }

  void deactivate() {
    this.isActive = false;
  }

}

class NoQuestionsLeftException implements Exception {}

class GameHolder {
  GameHolder._privateConstructor();
  static final GameHolder _instance = GameHolder._privateConstructor();
  static GameHolder get instance => _instance;

  static List<Question> defaultQuestionsList() {
    return [
      new Question(1, '1'),
      new Question(2, '2'),
      new Question(3, '3'),
      new Question(4, '4'),
      new Question(5, 'БЛИЦ'),
      new Question(6, '6'),
      new Question(7, '7'),
      new Question(8, '8'),
      new Question(9, 'СУПЕР БЛИЦ'),
      new Question(10, '10'),
      new Question(11, '11'),
      new Question(12, '12'),
      new Question(13, '13'),
    ];
  }

  List<Question> _questions = defaultQuestionsList();

  List<Question> getQuestions() {
    return _questions;
  }

  void reset() {
    _questions = defaultQuestionsList();
  }

  Question getNextQuestion(int number) {
    int j = 0;
    for (int i = number - 1; j < _questions.length; i++, j++) {
      if (i >= _questions.length) {
        i = 0;
      }
      Question question = _questions[i];
      if (question.isActive) {
        return question;
      }
    }
    throw new NoQuestionsLeftException();
  }

}