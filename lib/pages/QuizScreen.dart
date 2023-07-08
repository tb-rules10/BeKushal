import 'dart:convert';
import 'package:bekushal/constants/quizMap.dart';
import 'package:bekushal/pages/OtherScreens/QuizCompletedScreen.dart';
import 'package:bekushal/utils/quizModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OnboardingScreens/UserForm.dart';

class QuizScreen extends StatefulWidget {
  static String id = "QuizScreen";
  String? quizCode;
  QuizScreen({
    this.quizCode,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<String> quizData;
  late List<Question> allQuestions = [];
  late int questionNumber;
  late int quizLength;
  late int maxMarks;
  int marksCounter = 0;
  late double finalScore;
  bool isQuizCompleted = false;
  String selectedAns = "";
  String? correctAns;
  String? autoCorrectAns;
  String? inCorrectAns;
  Set<String> isDisabled = <String>{};
  String feedbackText = "";
  String submitText = "Submit";
  bool showFeedback = false;
  bool isQuesCompleted = false;
  int tryCount = 0;
  late Color disabledBorderColor;
  late Color disabledColor;
  late Color selectedButtonColor;
  late Color buttonBgColor;
  late Color incorrectColor;
  late Color correctColor;
  bool _hasLoggedInToday = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      quizData = quizCodeMap[widget.quizCode] ?? ["Pandas & Numpy", 'assets/questions/pandas_and_numpy/_questions.json'];
    });
    readData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    if(!isQuizCompleted){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  Future<void> readData() async {
    String path = quizData[1];
    String jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString) as List<dynamic>;
    setState(() {
      allQuestions = jsonData.map<Question>((item) {
        return Question.fromJson(item);
      }).toList();
    });
    // quizLength = allQuestions.length;
    quizLength = 5;
    maxMarks = quizLength * 4;
    print(quizLength);
    fetchQNUM();
  }

  Future<void> fetchQNUM() async {
    questionNumber = 0;
  }


  void reset() {
    feedbackText = "";
    submitText = "Submit";
    showFeedback = false;
    isQuesCompleted = false;
    tryCount = 0;
    selectedAns = "";
    correctAns = null;
    autoCorrectAns = null;
    inCorrectAns = null;
    isDisabled.clear();
  }
  void manualCorrectOperation(String selectedAns) {
    submitText = "Next";
    correctAns = selectedAns;
    isQuesCompleted = true;
    isDisabled.addAll(["A", "B", "C", "D"]..remove(selectedAns));
    attemptedPlus();
  }
  void autoCorrectOperation(String selectedAns) {
    submitText = "Next";
    autoCorrectAns = selectedAns;
    isQuesCompleted = true;
    isDisabled.addAll(["A", "B", "C", "D"]..remove(selectedAns));
    attemptedPlus();
  }
  void defineColors(BuildContext context) {
    disabledBorderColor = Theme.of(context).colorScheme.secondary.withOpacity(0.15);
    disabledColor = Colors.transparent;
    correctColor = const Color(0xff00C853);
    incorrectColor = const Color(0xFFD32F2F);
    selectedButtonColor = Theme.of(context).colorScheme.tertiary;
    buttonBgColor = Theme.of(context).colorScheme.secondary == Colors.black ? Colors.white : const Color(0xFF1E1E1E);
  }
  void calculateScore() {
    finalScore = (marksCounter*100)/maxMarks;
  }

  Future<void> maintainStreak() async {

    var prefs = await SharedPreferences.getInstance();

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    int? currentStreak = userProvider.streak;
    int newStreak = currentStreak! + 1;
    userProvider.setStreak(newStreak);

    await prefs.setInt('streak',newStreak);
  }

  Future<void> _checkLoginStreak() async {

    var prefs = await SharedPreferences.getInstance();

    final lastLoginDate = prefs.getString('lastLoginDate');
    final today = DateTime.now();

    if (lastLoginDate != null) {
      final lastLoginDateTime = DateTime.parse(lastLoginDate);
      final isSameDay = lastLoginDateTime.year == today.year &&
          lastLoginDateTime.month == today.month &&
          lastLoginDateTime.day == today.day;

      if (isSameDay) {
        setState(() {
          _hasLoggedInToday = true;
        });
      } else {
        final difference = today.difference(lastLoginDateTime).inDays;
        if (difference > 1) {
          prefs.setInt('streak', 0);
          UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setStreak(0);
        }
      }
    }

    if (!_hasLoggedInToday) {
      prefs.setString('lastLoginDate', today.toIso8601String());
      maintainStreak();
    }
  }

  Future<void> attemptedPlus() async {
    var prefs = await SharedPreferences.getInstance();

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    int? currentAttempt = userProvider.attempted;
    int newAttempt = currentAttempt! + 1;
    userProvider.setAttempted(newAttempt);

    await prefs.setInt('attempted',newAttempt);
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    defineColors(context);
    if (allQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: height * 0.13,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 30),
              child: Center(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 35,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            quizData[0],
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .secondary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600
                                )
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: showFeedback,
                        child: Text(
                          feedbackText,
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: (feedbackText == "Correct")
                                      ? correctColor : incorrectColor,
                                  // color: correctColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600
                              )
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Image.asset(
                    'assets/questions/${allQuestions[questionNumber]
                        .questionPath}',
                    fit: BoxFit.fill,
                  ),
                ),
                // SizedBox(
                //   height: height, // Set the desired height
                //   child: AspectRatio(
                //     aspectRatio: 16 / 8,
                //     child: Container(
                //       child: Image.asset(
                //         'assets/questions/${allQuestions[questionNumber].questionPath}',
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    children: [
                      buildQuizButton("A", incorrectColor, disabledColor, disabledBorderColor, correctColor, selectedButtonColor, buttonBgColor, context),
                      buildQuizButton("B", incorrectColor, disabledColor, disabledBorderColor, correctColor, selectedButtonColor, buttonBgColor, context),
                      buildQuizButton("C", incorrectColor, disabledColor, disabledBorderColor, correctColor, selectedButtonColor, buttonBgColor, context),
                      buildQuizButton("D", incorrectColor, disabledColor, disabledBorderColor, correctColor, selectedButtonColor, buttonBgColor, context),
                      const SizedBox(
                        height: 12,
                      ),
                      QuizButton(
                        color: selectedButtonColor,
                        text: submitText,
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        fontSize: (submitText == "Try Again") ? 21 : 22,
                        onTap: isQuesCompleted
                            ? () {
                          print("marks - " +  marksCounter.toString());
                          questionNumber ++;
                          if(questionNumber<quizLength){
                            setState(() {
                              reset();
                              questionNumber;
                            });
                          }
                          else{
                            setState(() {
                              isQuizCompleted = true;
                              calculateScore();
                            });
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    QuizCompletedScreen(
                                      finalScore: finalScore,
                                    ),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          }
                        }

                            : () {
                          setState(() {
                            showFeedback = true;
                            if (selectedAns == "") {
                              feedbackText = "Please Select an Option";
                            }
                            else {
                              tryCount ++;
                              if (tryCount == 1) {
                                if (selectedAns ==
                                    allQuestions[questionNumber].answer) {
                                  feedbackText = "Correct";
                                  marksCounter += 4;
                                  _checkLoginStreak();
                                  manualCorrectOperation(selectedAns);
                                }
                                else {
                                  feedbackText = "Incorrect, Try Again";
                                  isDisabled.add(selectedAns);
                                  selectedAns = "";
                                  // submitText = "Try Again";
                                }
                              }
                              else {
                                if (selectedAns ==
                                    allQuestions[questionNumber].answer) {
                                  feedbackText = "Correct";
                                  marksCounter += 2;
                                  _checkLoginStreak();
                                  manualCorrectOperation(selectedAns);
                                }
                                else {
                                  feedbackText = "Incorrect";
                                  isDisabled.add(selectedAns);
                                  autoCorrectOperation(allQuestions[questionNumber].answer);
                                  inCorrectAns = selectedAns;
                                }
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  QuizButton buildQuizButton(String buttonText, Color incorrectColor, Color disabledColor, Color disabledBorderColor, Color correctColor, Color selectedButtonColor, Color buttonBgColor, BuildContext context) {
    return QuizButton(
                      color: (inCorrectAns == buttonText)
                          ? incorrectColor
                          : (isDisabled.contains(buttonText))
                          ? disabledColor
                          : (correctAns == buttonText)
                          ? correctColor
                          : (selectedAns == buttonText)
                          ? selectedButtonColor
                          : buttonBgColor,
                      text: buttonText,
                      textColor: (correctAns == buttonText || inCorrectAns == buttonText)
                          ? Colors.white
                          : (autoCorrectAns == buttonText)
                          ? correctColor : null,
                      borderColor: (isDisabled.contains(buttonText))
                          ? disabledBorderColor
                          : (correctAns == buttonText || autoCorrectAns == buttonText)
                          ? correctColor
                          : Theme.of(context).colorScheme.secondary,
                      onTap: (isDisabled.contains(buttonText) || autoCorrectAns == buttonText)
                          ? () {}
                          : () {
                        setState(() {
                          selectedAns = buttonText;
                        });
                      },
                    );
  }

}


class QuizButton extends StatelessWidget {
  const QuizButton({
    super.key, required this.color, required this.text, required this.borderColor, required this.onTap, this.textStyle, this.fontSize, this.textColor,
  });

  final Color color;
  final Color borderColor;
  final Color? textColor;
  final String text;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: borderColor, // Set the border color
                  width: 1.5, // Set the border width
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  text,
                  style: textStyle ?? GoogleFonts.outfit(
                    textStyle: TextStyle(
                      color: textColor,
                      fontSize: fontSize ?? 24,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
