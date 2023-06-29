import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizCompletedScreen extends StatefulWidget {
  static String id = "QuizCompletedScreen";

  final double finalScore;
  QuizCompletedScreen({
    super.key,
    required this.finalScore,
  });

  @override
  State<QuizCompletedScreen> createState() => _QuizCompletedScreenState();
}

class _QuizCompletedScreenState extends State<QuizCompletedScreen> {
  final double scorePercentage = 60.0;
  final String topic = "Pandas & Numpy";

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF0F9),
      body: Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Image.asset(
                'assets/images/completed.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'Congratulations!',
                    style: GoogleFonts.outfit(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'You have scored',
                    style: GoogleFonts.outfit(
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    '${widget.finalScore.toStringAsFixed(0)}%',
                    style: GoogleFonts.outfit(
                      fontSize: 50.0,
                      color: Color(0xFFFF4081),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'in ',
                        style: GoogleFonts.outfit(
                          fontSize: 24.0,
                        ),
                      ),
                      Text(
                        topic,
                        style: GoogleFonts.outfit(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600 ,
                          color: Color(0xFF00B0FF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 290.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        print(widget.finalScore);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF00B0FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}