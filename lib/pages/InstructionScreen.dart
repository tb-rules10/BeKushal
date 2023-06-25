import 'package:bekushal/pages/QuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InstructionScreen extends StatefulWidget {
  static String id = "InstructionScreen";

  String? quizCode;
  InstructionScreen({
    this.quizCode,
  });
  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Hide the status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Restore the status bar when the screen is disposed
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAF0F9),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      height: 300.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 8.0,
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 32.0,
                                  height: 32.0,
                                  child: IconButton(
                                    iconSize: 24.0,
                                    icon: Icon(Icons.arrow_back),
                                    color: Color(0xFF00B0FF),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Text(
                                  'Instructions',
                                  style: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00B0FF),
                                    fontFamily:
                                    'Outfit', // Specify the outlined font
                                  ),
                                ),
                                SizedBox(
                                  width: 40.0,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 8.0),
                                Container(
                                  margin:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris at nisl fringilla, dapibus nunc vel, scelerisque nunc. Vestibulum rutrum at magna id congue. Sed eu magna vel sem semper dictum eget in diam.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris at nisl fringilla, dapibus nunc vel, scelerisque nunc. Vestibulum rutrum at magna id congue. Sed eu magna vel sem semper dictum eget in diam.',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black,
                                        fontFamily:
                                        'Outfit', // Specify the outlined font
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.all(16.0),
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    width: 160.0,
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF00B0FF),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                QuizScreen(quizCode: "ML101"),
                                            transitionsBuilder:
                                                (context, animation, secondaryAnimation, child) {
                                              return FadeTransition(opacity: animation, child: child);
                                            },
                                          ),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          'Go to Test',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.0,
                                            fontFamily:
                                            'Outfit', // Specify the outlined font
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
