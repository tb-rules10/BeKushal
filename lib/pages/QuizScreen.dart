import 'dart:convert';
import 'package:bekushal/constants/quizMap.dart';
import 'package:bekushal/utils/quizModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late List<Question> allQuestions = [];
  late int questionNumber;
  late int quizLength;
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

  @override
  void initState() {
    super.initState();
    readData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Restore the status bar when the screen is disposed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> readData() async {
    print(widget.quizCode);
    String path = quizCodeMap[widget.quizCode] ?? 'assets/questions/pandas_and_numpy/_questions.json';
    print(path);
    print("*********************************");
    String jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString) as List<dynamic>;
    setState(() {
      allQuestions = jsonData.map<Question>((item) {
        return Question.fromJson(item);
      }).toList();
    });
    quizLength = allQuestions.length;
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
  }
  void autoCorrectOperation(String selectedAns) {
    submitText = "Next";
    autoCorrectAns = selectedAns;
    isQuesCompleted = true;
    isDisabled.addAll(["A", "B", "C", "D"]..remove(selectedAns));
  }
  void defineColors(BuildContext context) {
    disabledBorderColor = Theme.of(context).colorScheme.secondary.withOpacity(0.15);
    disabledColor = Colors.transparent;
    correctColor = const Color(0xff00C853);
    incorrectColor = const Color(0xFFD32F2F);
    selectedButtonColor = Theme.of(context).colorScheme.tertiary;
    buttonBgColor = Theme.of(context).colorScheme.secondary == Colors.black ? Colors.white : const Color(0xFF1E1E1E);
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
                      onTap: (isDisabled.contains(buttonText))
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
