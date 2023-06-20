import 'package:flutter/material.dart';
import '../constants/textStyles.dart';
import 'package:google_fonts/google_fonts.dart';


class BlueButton extends StatelessWidget {
  BlueButton({
    super.key,
    required this.imageIcon,
    required this.smallText,
    required this.boldText,
  });

  String imageIcon;
  String smallText;
  String boldText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            Image.asset(
              imageIcon,
              height: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  smallText,
                  style: kBlueBtnLight,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  boldText,
                  style: kBlueBtnBold,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


class CoursesButton extends StatelessWidget {
  CoursesButton({
    super.key,
    required this.width,
    required this.topics,
    required this.course,
    required this.onTap,
  });

  final double width;
  final String topics;
  final String course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: width*0.42,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    course,
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Number of Topics",
                              style: kPinkBtnLight,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              topics,
                              style: kPinkBtnBold,
                            )
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
