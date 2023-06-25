import 'dart:io';
import 'package:bekushal/BottomNavbar.dart';
import 'package:bekushal/pages/ExploreScreen.dart';
import 'package:bekushal/pages/HomeScreen.dart';
import 'package:bekushal/pages/InstructionScreen.dart';
import 'package:bekushal/pages/QuizScreen.dart';
import 'package:bekushal/pages/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'constants/theme.dart';
import 'package:flutter/services.dart';

late bool isLoggedIn;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(BeKushal()));
  runApp(BeKushal());
}

class BeKushal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ,
      initialRoute: BottomNavbar.id,
      routes: {
        BottomNavbar.id: (context) => BottomNavbar(),
        HomeScreen.id: (context) => HomeScreen(),
        ExploreScreen.id: (context) => ExploreScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        QuizScreen.id: (context) => QuizScreen(),
        InstructionScreen.id: (context) => InstructionScreen(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}