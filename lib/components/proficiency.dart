// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
// import 'package:bekushal/pages/QuizScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyWidget extends StatelessWidget {
  String? text;
  int level;
  MyWidget({super.key, required this.text, required this.level});

  bool medal1 = false;
  bool medal2 = false;
  bool medal3 = false;
  var levels = ['Start', 'Beginner', 'Intermediate', 'Expert'];
  late String currentLevel;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (level.truncate() == 0) {
      currentLevel = levels[0];
    } else if (level.truncate() == 1) {
      currentLevel = levels[1];
      medal1 = true;
    } else if (level.truncate() == 2) {
      currentLevel = levels[2];
      medal1 = medal2 = true;
    } else {
      currentLevel = levels[3];
      medal1 = medal2 = medal3 = true;
    }

    return Container(
      height: 140,
      child: Card(
        color: (Theme.of(context).colorScheme.secondary == Colors.black) ? Colors.white : Color(0xff212121),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(text!, style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                ),),
                
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                        children: [Text('Level: ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17,color: Theme.of(context).colorScheme.secondary,),), Text(currentLevel,style: TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.secondary,),)]),
                  ),
                  Row(
                    children: [
                      Visibility(
                  visible: medal1,
                  child: Container(
                      height: 51,
                      width: 42,
                      // color: Colors.amber,
                      child: Image.asset(
                        "assets/images/medal1.png",
                        fit: BoxFit.fill,
                      )),
                ),
                SizedBox(width: 10,),
                Visibility(
                  visible: medal2,
                  child: Container(
                      height: 51,
                      width: 42,
                      // color: Colors.amber,
                      child: Image.asset(
                        "assets/images/medal2.png",
                        fit: BoxFit.fill,
                      )),
                ),
                SizedBox(width: 10,),
                Visibility(
                  visible: medal3,
                  child: Container(
                      height: 51,
                      width: 42,
                      // color: Colors.amber,
                      child: Image.asset(
                        "assets/images/medal3.png",
                        fit: BoxFit.fill,
                      )),
                )
                    ],
                  )
                ],
              ),
              // SizedBox(height: 10,),
            //   LinearPercentIndicator(
            //   // width: MediaQuery.of(context).size.width - 50,
            //   animation: true,
            //   lineHeight: 20.0,
            //   animationDuration: 1000,
            //   percent: (finalScore.truncate() / 100),
            //   center: Text("${finalScore.truncate()}%"),
            //   barRadius: Radius.circular(10),
            //   backgroundColor: Colors.blue[100],
            //   progressColor: Theme.of(context).colorScheme.tertiary,
            // ),
            ],),
        ),
      ),
    );
  }
}
