import 'dart:io';
import 'package:bekushal/BottomNavbar.dart';
import 'package:bekushal/pages/OnboardingScreens/DisplayInfo.dart';
import 'package:bekushal/pages/ExploreScreen.dart';
import 'package:bekushal/pages/HomeScreen.dart';
import 'package:bekushal/pages/OtherScreens/InstructionScreen.dart';
import 'package:bekushal/pages/OnboardingScreens/EditProfile.dart';
import 'package:bekushal/pages/OnboardingScreens/OnboardingScreen.dart';
import 'package:bekushal/pages/OtherScreens/OutTeamScreen.dart';
import 'package:bekushal/pages/OnboardingScreens/ProfilePic.dart';
import 'package:bekushal/pages/OtherScreens/QuizCompletedScreen.dart';
import 'package:bekushal/pages/QuizScreen.dart';
import 'package:bekushal/pages/OnboardingScreens/UserForm.dart';
import 'package:bekushal/pages/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/theme.dart';
import 'package:flutter/services.dart';

late bool onboardingCompleted;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(BeKushal()));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  onboardingCompleted = await prefs.getBool('onboardingCompleted') ?? false;
  runApp(BeKushal());
}

class BeKushal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PicProvider>(create: (_) => PicProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        // themeMode: ThemeMode.system,
        initialRoute: (onboardingCompleted) ? BottomNavbar.id : OnboardingScreen.id,
        // initialRoute: QuizScreen.id,
        routes: {
          OnboardingScreen.id: (context) => OnboardingScreen(),
          UserForm.id: (context) => UserForm(),
          ProfilePic.id: (context) => ProfilePic(),
          DisplayInfo.id: (context) => DisplayInfo(),
          EditProfile.id: (context) => EditProfile(),


          BottomNavbar.id: (context) => BottomNavbar(),
          HomeScreen.id: (context) => HomeScreen(),
          ExploreScreen.id: (context) => ExploreScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          QuizScreen.id: (context) => QuizScreen(),
          QuizCompletedScreen.id: (context) => QuizCompletedScreen(finalScore: 60,),
          InstructionScreen.id: (context) => InstructionScreen(),
          OurTeamScreen.id: (context) => OurTeamScreen(),
        },
      ),
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