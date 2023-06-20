import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenHeading extends StatelessWidget {
  ScreenHeading({
    super.key, required this.heading,
  });

  final String heading;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.left,
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
