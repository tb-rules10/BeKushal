// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class achievementsDailyStreak extends StatelessWidget {
  int? streak;
  achievementsDailyStreak({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Center(
                child: Container(
                  height: 130,
                  width: 120,
                  child: Image.asset(
              'assets/images/image 14.png',
              fit: BoxFit.fill,
            ))),
            SizedBox(height: 10,),
            Text('$streak/$streak days', style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              )
            ),),
          ],
        ),
      ),
    );
  }
}
class achievementsAttemps extends StatelessWidget {
  int? attempted;
  achievementsAttemps({super.key, required this.attempted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Column(
          children: [
            Center(
                child: Container(
                  height: 130,
                  width: 120,
                  child: Image.asset(
              'assets/images/image 14.png',
              fit: BoxFit.fill,
            ))),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('$attempted/$attempted questions', style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                )
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
