import 'dart:convert';
import 'dart:math';
import 'package:bekushal/Components/Buttons.dart';
import 'package:bekushal/constants/quizMap.dart';
import 'package:bekushal/pages/OtherScreens/QuizCompletedScreen.dart';
import 'package:bekushal/utils/quizModel.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OnboardingScreens/UserForm.dart';

int finalmarks = 0;
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
  // Create a GlobalKey to access the ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<String> quizData;
  late List<Question> allQuestions = [];
  late List<String> attemptedQuestions = [];
  late int questionNumber;
  late int quizLength;
  late int maxMarks;
  List<int> marksCounter = [];
  List<int> prevMarksCounter = [];
  List<QuizData> allQuizData = [];
  QuizData? currQuiz;
  late double finalScore = 0;
  int level = 0;
  List<String> levels = ["Beginner Level", "Intermediate Level", "Expert Level"];
  int level_Length = 3;
  Random random = Random();
  bool isMedalDrawer = false;
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
    fetchQuizData();
    readData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    saveQuizData();
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
    quizLength = allQuestions.length;
    print(quizLength);
    if(currQuiz == null){
      fetchQNUM();
    }
    print(currQuiz);
  }
  Future<void> fetchQuizData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('allQuizData');
    if(data != null){
      for(String qData in data){
        var json = jsonDecode(qData);
        setState(() {
          allQuizData.add(QuizData.fromJson(json));
        });
      }
      setState(() {
        currQuiz = allQuizData.firstWhere(
              (data) => data.quizCode == widget.quizCode,
          orElse: () => null as QuizData,
        );
        if (currQuiz != null) {
          print("Indput DATA");
          attemptedQuestions = currQuiz!.attemptedQuestions;
          questionNumber = currQuiz!.questionNumber;
          marksCounter = currQuiz!.marksCounter;
          prevMarksCounter = currQuiz!.prevMarks;
          level = currQuiz!.level;
        }
      });
    }
  }
  Future<void> saveQuizData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = [];
    allQuizData.remove(currQuiz);
    var newData = QuizData(
        quizCode: widget.quizCode ?? "ML101",
        questionNumber: questionNumber,
        level: level,
        marksCounter: marksCounter,
        prevMarks: prevMarksCounter,
        attemptedQuestions: attemptedQuestions,
        finalScore: finalScore
        
    );
    allQuizData.add(newData);
    print("**********************#########################***********************");
    for(var data in allQuizData){
      temp.add(jsonEncode(data));
    }
    print(temp);
    prefs.setStringList('allQuizData', temp);
  }

  void fetchQNUM() async {
    while(true){
      String quesNo = random.nextInt(quizLength).toString();
      if(!attemptedQuestions.contains(quesNo)){
        setState(() {
          questionNumber = int.parse(quesNo);
          attemptedQuestions.insert(0, questionNumber.toString());
          print(questionNumber);
        });
        break;
      }
    }
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
  void checkScore() {
    int marks = marksCounter.sublist(0, level_Length).reduce((value, element) => value + element);
    finalScore = (marks/(level_Length*4))*100;
    print(marks);
    print(finalScore);
    if(finalScore >= 80){
      if(level<3){
        setState(() {
          level++;
          isMedalDrawer = true;
        });
        prevMarksCounter.addAll(marksCounter);
        marksCounter = [];
        print("************************************************");
        print(level);
        print("************************************************");
        _scaffoldKey.currentState?.openEndDrawer();
      }
    }
  }
  void calculateScore() {
    int marks = prevMarksCounter.reduce((value, element) => value + element);
    print(prevMarksCounter);
    print(attemptedQuestions);
    maxMarks = attemptedQuestions.length*4;
    finalScore = (marks*100)/maxMarks;
  }
  void quizCompleteActions() {
    setState(() {
      isQuizCompleted = true;
      calculateScore();
    });
    print("completecheck");
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
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: height * 0.13,
            actions: [Container()],
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
                      (feedbackText == "")
                          ? IconButton(
                        onPressed: (){
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 35,
                        ),
                      )
                          : Visibility(
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
          endDrawer: (isMedalDrawer)
              ? Drawer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Congratulations!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      "assets/images/medal-${level}.png",
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "You have successfully completed",
                            style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          levels[level-1],
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: width,
                      child: TextButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                          side: const BorderSide(
                            width: 1.0,
                            color: Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(_scaffoldKey.currentContext!).pop();
                          setState(() {
                            isMedalDrawer = false;
                          });
                          if(level==3){
                            print("COMPLETE");
                            quizCompleteActions();
                          }
                        },
                        child: Text(
                          (level==3)? "End Quiz" : "Continue",
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
              : Drawer(
            child: SizedBox(
                    height: height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FittedBox(
                              child: Text(
                                "Track Your Progress - ${level == 0 ? "Start" : level == 1 ? "Beginner Level" : level == 2 ? "Intermediate Level" : "Expert Level"}",
                                style: GoogleFonts.inter(
                                  color: disabledBorderColor.withOpacity(0.5),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          EasyStepper(
                            activeStep: level,
                            direction: Axis.vertical,
                            internalPadding: 10,
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 30, vertical: 20),
                            stepRadius: 50,
                            finishedStepTextColor: Colors.blue,
                            activeStepBorderColor: Colors.blue,
                            activeStepBackgroundColor: Colors.grey,
                            activeLineColor: Colors.blue,
                            defaultLineColor: Colors.blue,
                            finishedStepBackgroundColor: Colors.blue,
                            showLoadingAnimation: false,
                            // showScrollbar: false,

                            steps: [
                              EasyStep(
                                customStep: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Opacity(
                                    opacity: 1,
                                    child: Image.asset(
                                        'assets/images/medal-1.png'),
                                  ),
                                ),
                                customTitle: Text(
                                  'Beginner Level',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              EasyStep(
                                customStep: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Opacity(
                                    opacity: 1,
                                    child: Image.asset(
                                        'assets/images/medal-2.png'),
                                  ),
                                ),
                                customTitle: Text(
                                  'Intermediate Level',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              EasyStep(
                                customStep: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Opacity(
                                    opacity: 1,
                                    child: Image.asset(
                                        'assets/images/medal-3.png'),
                                  ),
                                ),
                                customTitle: Text(
                                  'Expert Level',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            // onStepReached: (index) =>
                            //     setState(() => level = index),
                          ),
                        ],
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
                          // questionNumber ++;
                          if(attemptedQuestions.length<quizLength){
                            setState(() {
                              reset();
                              if(marksCounter.length >= level_Length){
                                checkScore();
                              }
                              fetchQNUM();
                            });
                          }
                          else{
                            quizCompleteActions();
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
                                  marksCounter.insert(0,4);
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
                                  marksCounter.insert(0,2);
                                  _checkLoginStreak();
                                  manualCorrectOperation(selectedAns);
                                }
                                else {
                                  feedbackText = "Incorrect";
                                  isDisabled.add(selectedAns);
                                  marksCounter.insert(0,0);
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