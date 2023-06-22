import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.textStyle,
    required this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    required this.onPressed,
    this.padding
  });

  final double width;
  final double height;
  final String title;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed:  onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
            backgroundColor: backgroundColor,
            side: BorderSide(
              width: 1.0,
              color: borderColor ?? Colors.transparent,
            ),
          ),
          child: Text(
            title,
            style: GoogleFonts.outfit(
              textStyle: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    super.key,
    this.padding = const EdgeInsets.only(left: 25, top: 25),
    this.buttonSize = 40,
  });

  final EdgeInsets padding;
  final double buttonSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: padding,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: buttonSize,
            ),
          ),
        ),
      ],
    );
  }
}

