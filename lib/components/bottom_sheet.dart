import 'package:bekushal/pages/InstructionScreen.dart';
import 'package:bekushal/pages/QuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/exploreModel.dart';
import 'buttons.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({
    super.key,
    required this.height,
    required this.width,
    required this.selectedTopic,
  });

  final double height;
  final double width;
  final Topics selectedTopic;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: height*0.48,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: (Theme.of(context).colorScheme.secondary == Colors.black) ? Colors.white : Color(0xff212121),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 5,
                          width: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            // color: Theme.of(context).colorScheme.outline,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width* 0.6,
                        child: Text(
                          selectedTopic.topicName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          width: width,
                          height: 1,
                          color: Colors.grey,
                          child: Divider(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          "Syllabus",
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width*0.6,
                            height: height*0.15,
                            child: ListView.builder(
                                itemCount: selectedTopic.syllabus.length,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, i){
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 20,
                                        child: Text(
                                          "${i + 1}.",
                                          style: GoogleFonts.outfit(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8)
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          selectedTopic.syllabus[i].substring(3),
                                          style: GoogleFonts.outfit(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),

              Container(
                child: SubmitButton(
                    padding: const EdgeInsets.all(16.0),
                    width: width*0.65,
                    height: height*0.07,
                    title: "Start Quiz",
                    textStyle: GoogleFonts.outfit(
                      textStyle: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    borderRadius: 10,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              QuizScreen(quizCode: selectedTopic.quizCode,),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
