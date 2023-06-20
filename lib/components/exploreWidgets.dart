import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.width,
    required this.bgColor,
    required this.textColor,
    this.bigBox = false, required this.text, this.height,
  });

  final double width;
  final double?  height;
  final Color bgColor;
  final Color textColor;
  final bool bigBox;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (bigBox == true)
          ? const EdgeInsets.fromLTRB(0,5,0,12)
          : const EdgeInsets.fromLTRB(0,10,16,8),
      child: Container(
        height: height,
        width: (bigBox == true) ? width : width*0.5,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: (bigBox == true) ? width*0.5 : width*0.32,
                    child: Text(
                      text,
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: (bigBox == true) ? 24 : 18,
                          color: Theme.of(context).colorScheme.secondary
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                      "assets/images/stars.png",
                      height: (bigBox == true) ? 35 : 30
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

