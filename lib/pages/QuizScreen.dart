import 'dart:convert';

import 'package:bekushal/Components/Buttons.dart';
import 'package:bekushal/utils/quizModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatefulWidget {
  static String id = "QuizScreen";
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> allQuestions = [];
  late int questionNumber;
  String selectedAns = "";
  String? correctAns;
  String? inCorrectAns;
  Set<String> isDisabled = <String>{};
  String feedbackText = "";
  String submitText = "Submit";
  bool showFeedback = false;
  bool isQuesCompleted = false;
  int tryCount = 0;

  void reset() {
    feedbackText = "";
    submitText = "Submit";
    showFeedback = false;
    isQuesCompleted = false;
    tryCount = 0;
    selectedAns = "";
    correctAns = null;
    inCorrectAns = null;
    isDisabled.clear();
  }

  Future<void> readData() async {
    String jsonString = await rootBundle.loadString(
        'assets/questions/pandas_and_numpy/_questions.json');
    final jsonData = json.decode(jsonString) as List<dynamic>;
    allQuestions = jsonData.map<Question>((item) {
      return Question.fromJson(item);
    }).toList();
    print(allQuestions.length);
    fetchQNUM();
  }

  Future<void> fetchQNUM() async {
    questionNumber = 0;
  }

  @override
  void initState() {
    super.initState();
    readData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Restore the status bar when the screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final Color disabledColor = Theme.of(context).colorScheme.secondary.withOpacity(0.1);
    const Color incorrectColor = Color(0xFFD32F2F);
    const Color correctColor = Color(0xff00C853);
    final Color selectedButtonColor = Theme.of(context).colorScheme.tertiary;
    final Color buttonBgColor = Theme.of(context).colorScheme.secondary == Colors.black ? Colors.white : const Color(0xFF1E1E1E);
    if (allQuestions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // backgroundColor: incorrectColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: height * 0.13,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 15.0, right: 25),
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
                            color: Theme
                                .of(context)
                                .colorScheme
                                .tertiary,
                            size: 35,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Pandas & Numpy",
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 20),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Image.asset(
                    'assets/questions/${allQuestions[questionNumber]
                        .questionPath}',
                    fit: BoxFit.cover,
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
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    children: [
                      QuizButton(
                        color: (inCorrectAns == "A")
                            ? incorrectColor
                            : (isDisabled.contains("A"))
                            ? disabledColor
                            : (correctAns == "A")
                            ? correctColor
                            : (selectedAns == "A")
                            ? selectedButtonColor
                            : buttonBgColor,
                        text: "A",
                        borderColor: (isDisabled.contains("A"))
                            ? disabledColor
                            : (correctAns == "A")
                            ? correctColor
                            : Theme.of(context).colorScheme.secondary,
                        onTap: (isDisabled.contains("A"))
                            ? () {}
                            : () {
                          setState(() {
                            selectedAns = "A";
                          });
                        },
                      ),
                      QuizButton(
                        color: (inCorrectAns == "B")
                            ? incorrectColor
                            : (isDisabled.contains("B"))
                            ? disabledColor
                            : (correctAns == "B")
                            ? correctColor
                            : (selectedAns == "B")
                            ? selectedButtonColor
                            : buttonBgColor,
                        text: "B",
                        borderColor: (isDisabled.contains("B"))
                            ? disabledColor
                            : (correctAns == "B")
                            ? correctColor
                            : Theme.of(context).colorScheme.secondary,
                        onTap: (isDisabled.contains("B"))
                            ? () {}
                            : () {
                          setState(() {
                            selectedAns = "B";
                          });
                        },
                      ),
                      QuizButton(
                        color: (inCorrectAns == "C")
                            ? incorrectColor
                            : (isDisabled.contains("C"))
                            ? disabledColor
                            : (correctAns == "C")
                            ? correctColor
                            : (selectedAns == "C")
                            ? selectedButtonColor
                            : buttonBgColor,
                        text: "C",
                        borderColor: (isDisabled.contains("C"))
                            ? disabledColor
                            : (correctAns == "C")
                            ? correctColor
                            : Theme.of(context).colorScheme.secondary,
                        onTap: (isDisabled != null && isDisabled.contains("C"))
                            ? () {}
                            : () {
                          setState(() {
                            selectedAns = "C";
                          });
                        },
                      ),
                      QuizButton(
                        color: (inCorrectAns == "D")
                            ? incorrectColor
                            : (isDisabled != null && isDisabled.contains("D"))
                            ? disabledColor
                            : (correctAns == "D")
                            ? correctColor
                            : (selectedAns == "D")
                            ? selectedButtonColor
                            : buttonBgColor,
                        text: "D",
                        borderColor: (isDisabled != null &&
                            isDisabled.contains("D"))
                            ? disabledColor
                            : (correctAns == "D")
                            ? correctColor
                            : Theme.of(context).colorScheme.secondary,
                        onTap: (isDisabled != null && isDisabled.contains("D"))
                            ? () {}
                            : () {
                          setState(() {
                            selectedAns = "D";
                          });
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      QuizButton(
                        color: selectedButtonColor,
                        text: submitText,
                        borderColor: Colors.transparent,
                        fontSize: 22,
                        onTap: isQuesCompleted
                            ? () {
                          setState(() {
                            reset();
                            questionNumber ++;
                          });
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
                                  correctAnsOperation(selectedAns);
                                }
                                else {
                                  feedbackText = "Incorrect, Try Again";
                                  isDisabled.add(selectedAns);
                                  selectedAns = "";
                                }
                              }
                              else {
                                if (selectedAns ==
                                    allQuestions[questionNumber].answer) {
                                  feedbackText = "Correct";
                                  correctAnsOperation(selectedAns);
                                }
                                else {
                                  feedbackText = "Incorrect";
                                  isDisabled.add(selectedAns);
                                  correctAnsOperation(
                                      allQuestions[questionNumber].answer);
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

  void correctAnsOperation(String selectedAns) {
    submitText = "Next";
    correctAns = selectedAns;
    isQuesCompleted = true;
    isDisabled.addAll(["A", "B", "C", "D"]..remove(selectedAns));
  }
}


class QuizButton extends StatelessWidget {
  const QuizButton({
    super.key, required this.color, required this.text, required this.borderColor, required this.onTap, this.textStyle, this.fontSize,
  });

  final Color color;
  final Color borderColor;
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
                  width: 2.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  text,
                  style: textStyle ?? GoogleFonts.outfit(
                    textStyle: TextStyle(
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
