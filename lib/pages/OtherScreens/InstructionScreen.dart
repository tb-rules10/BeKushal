import 'package:bekushal/pages/QuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructionScreen extends StatefulWidget {
  static String id = "InstructionScreen";

  final String? quizCode;
  const InstructionScreen({
    Key? key,
    this.quizCode,
  }) : super(key: key);

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2700), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              InstructionPage(
            quizCode: widget.quizCode,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme =
        Theme.of(context).scaffoldBackgroundColor == const Color(0xFFEAF0F9);
    final imageAsset = isLightTheme
        ? "assets/gif/rotate_light.gif"
        : "assets/gif/rotate_dark.gif";
    return Scaffold(
      body: Center(
        child: Image.asset(imageAsset),
      ),
    );
  }
}

class InstructionPage extends StatefulWidget {
  final String? quizCode;
  const InstructionPage({
    Key? key,
    this.quizCode,
  }) : super(key: key);

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  bool submitPressed = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    if (!submitPressed) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme =
        Theme.of(context).scaffoldBackgroundColor == const Color(0xFFEAF0F9);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              margin: const EdgeInsets.all(23.0),
              decoration: BoxDecoration(
                color: isLightTheme ? Colors.white : Color(0xff232323),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 18.0,
                      left: 30.0,
                      right: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 32.0,
                          icon: const Icon(Icons.arrow_back),
                          color: const Color(0xFF00B0FF),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Instructions',
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: isLightTheme ? Color(0xFF00B0FF) : Colors.white,
                            )
                          ),
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: false,
                          child: IconButton(
                            iconSize: 32.0,
                            icon: const Icon(Icons.arrow_back),
                            color: const Color(0xFF00B0FF),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                        child: Text(
                          'Lorem ipsum dolor sit amet, congue. Nulla dignissim nisi a neque lacinia eleifend. Vestibulum sollicitudin est eu risus fermentum hendrerit. Morbi nec mauris eu lorem convallis faucibus. Donec vestibulum congue lectus a imperdiet. Aliquam pharetra dui quis nulla luctus, ac congue urna lacinia. Aliquam dapibus pharetra leo, a egestas leo auctor at. Proin at felis et justo interdum egestas. Quisque vitae metus rutrum, ultricies massa eget, facilisis metus.',
                          style: GoogleFonts.outfit(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: isLightTheme ? Colors.black : Colors.white,
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.tertiary),
                    ),
                    onPressed: () {
                      setState(() {
                        submitPressed = true;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            quizCode: widget.quizCode,
                          ),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 32.0,
                      ),
                      child: Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
