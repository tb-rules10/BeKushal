import 'dart:io';
import 'package:bekushal/constants/textStyles.dart';
import 'package:bekushal/pages/OnboardingScreens/UserForm.dart';
import 'package:bekushal/pages/OtherScreens/LBCScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';
import '../components/drop_down.dart';
import '../components/homeWidgets.dart';
import 'OnboardingScreens/DisplayInfo.dart';
import 'OnboardingScreens/ProfilePic.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  late String _profilePicturePath;
  String _name = '';
  String username = "Yoru";
  int streakDays = 0;

  // String photoUrl = "https://dotesports.com/wp-content/uploads/2021/01/12162418/Yoru.png";

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  Future<void> getDetails() async{
      // username = username ?? "Yoru";
      // photoUrl = photoUrl ?? "https://dotesports.com/wp-content/uploads/2021/01/12162418/Yoru.png";
      var prefs = await SharedPreferences.getInstance();
      _profilePicturePath = prefs.getString('profilePicturePath') ?? 'assets/images/default_profile_pic.png';
      _name = prefs.getString('name') ?? '';
      var name = _name;
      int index = name.indexOf(" ");
      if(index!=-1) name =  name.substring(0, name.indexOf(" "));
      _name = name;
      _checkLoginStreak();
      var streakDays = prefs.getInt('streak');
      context.read<UserProvider>().setStreak(streakDays!);
      var attempt = prefs.getInt('attempted');
      context.read<UserProvider>().setAttempted(attempt!);
  }

  bool _hasLoggedInToday = false;

  Future<void> _checkLoginStreak() async {

    var prefs = await SharedPreferences.getInstance();

    final lastLoginDate = prefs.getString('lastLoginDate');
    final today = DateTime.now();

    if (lastLoginDate != null) {
      final lastLoginDateTime = DateTime.parse(lastLoginDate);
      final isSameDay = lastLoginDateTime.year == today.year &&
          lastLoginDateTime.month == today.month &&
          lastLoginDateTime.day == today.day;

      if (isSameDay) {
        setState(() {
          _hasLoggedInToday = true;
        });
      } else {
        final difference = today.difference(lastLoginDateTime).inDays;
        if (difference > 1) {
          prefs.setInt('streak', 0);
          UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setStreak(0);
        }
      }
    }
  }

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();

    _profilePicturePath = prefs.getString('profilePicturePath') ?? '';
    _name = prefs.getString('name') ?? '';

    _checkLoginStreak();
    var streakDays = prefs.getInt('streak');
    context.read<UserProvider>().setStreak(streakDays!);
    var attempt = prefs.getInt('attempted');
    context.read<UserProvider>().setAttempted(attempt!);

    context.read<UserProvider>().setName(_name);

    if (_profilePicturePath.isNotEmpty) {
      context.read<PicProvider>().setImageFile(File(_profilePicturePath));
      setState(() { });}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    int milestone = 7;
    double streak_milestone = (context.read<UserProvider>().streak! / milestone);

    while(streak_milestone >= 1.0 && milestone < 56){
      milestone = (milestone * 2);
      setState(() {
        print("working");
        streak_milestone = (context.read<UserProvider>().streak! / milestone);
      });
    }

    if(streak_milestone > 1.0){
      streak_milestone = 1.0;
    }


    int a_milestone = 50;
    double attempted_milestone = (context.read<UserProvider>().attempted! / a_milestone);

    while(attempted_milestone >= 1.0 && a_milestone < 500){
      a_milestone = (a_milestone * 2);
      setState(() {
        attempted_milestone = (context.read<UserProvider>().attempted! / a_milestone);
      });
    }

    if(attempted_milestone > 1.0){
      attempted_milestone = 1.0;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Consumer<UserProvider>(
                            builder: (context,userProvider,_) {
                              String? firstName = userProvider.name;
                              if (_name.isNotEmpty) {
                                List<String> nameParts = firstName!.split(' ');
                                firstName = nameParts.first;
                              }

                              return Container(
                                width: width*0.70,
                                padding: EdgeInsets.zero,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text("Welcome, ${firstName}!",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.outfit(
                                      textStyle: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                              "Let's dive into learning",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.outfit(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ))),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, DisplayInfo.id);
                        },
                        child: Consumer<PicProvider>(
                          builder: (context, imageProvider, _) {
                            if (imageProvider.imageFile == null) {
                              return const CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage('assets/images/default_profile_pic.png'),
                              );
                            } else {
                              return   CircleAvatar(
                                  radius: 32,
                                  backgroundImage: FileImage(imageProvider.imageFile!) as ImageProvider
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 70,
                  width: width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: double.infinity),
                            child: Consumer<UserProvider>(
                              builder: (context, userProvider, _) {
                                return FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(context: context,
                                          builder: (BuildContext context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                elevation: 16,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: Color(0xffEAF0F9),
                                                  ),
                                                  height: 145,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(15.0,8.0,15.0,8.0),
                                                        child: Text("Attempt 1 question daily to continue your streak!",textAlign: TextAlign.start,style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w500 , color: Colors.grey),),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          WhiteButton(
                                                            imageIcon: "assets/images/fire1.png",
                                                            smallText: "${userProvider.streak} days",
                                                            boldText: "Current Streak",
                                                          ),
                                                          WhiteButton(
                                                            imageIcon: "assets/images/star.png",
                                                            smallText: "${milestone} days",
                                                            boldText: "Next Milestone",
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 200,
                                                        child: Stack(
                                                          children: [
                                                            WaveLinearProgressIndicator(
                                                              value: streak_milestone ,
                                                              backgroundColor: Colors.grey[300],
                                                              waveColor: const Color(0xff00B0FF),
                                                              waveBackgroundColor:Color(0xffFF4081) ,
                                                              labelDecoration:BoxDecoration(
                                                              color: Color(0xffFF4081), borderRadius: BorderRadius.circular(100.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                          }
                                      );
                                    },
                                    child: BlueButton(
                                      imageIcon: "assets/images/fire1.png",
                                      smallText: "Daily Streak",
                                      boldText: "${userProvider.streak} Days",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: double.infinity),
                            child: Consumer<UserProvider>(
                              builder: (context, userProvider, _) {
                                return FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: GestureDetector(
                                    onTap: (){
                                      showDialog(context: context,
                                          builder: (BuildContext context){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                              elevation: 16,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  color: Color(0xffEAF0F9),
                                                ),
                                                height: 125,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        WhiteButton(
                                                          imageIcon: "assets/images/pencilt.png",
                                                          smallText: "${userProvider.attempted} Questions",
                                                          boldText: "Attempted",
                                                        ),
                                                        WhiteButton(
                                                          imageIcon: "assets/images/star.png",
                                                          smallText: "${a_milestone} Questions",
                                                          boldText: "Next Milestone",
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 200,
                                                      child: Stack(
                                                        children: [
                                                          WaveLinearProgressIndicator(
                                                            value: attempted_milestone, // Set the progress value between 0.0 and 1.0
                                                            backgroundColor: Colors.grey[300],
                                                            waveColor: const Color(0xff00B0FF),
                                                            waveBackgroundColor:Color(0xffFF4081) ,
                                                            labelDecoration:BoxDecoration(
                                                              color: Color(0xffFF4081), borderRadius: BorderRadius.circular(100.0),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                      );
                                    },
                                    child: BlueButton(
                                    imageIcon: "assets/images/pencil.png",
                                    smallText: "Attempts",
                                    boldText: "${userProvider.attempted} Questions",
                                  ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Learn by Categories",
                      style: GoogleFonts.outfit(
                          textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                      ),
                    ),
                    SizedBox(
                    height: 5,
                    ),
                    Text(
                      "Practise through randomised MCQ tests",
                      style: GoogleFonts.outfit(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff646464),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 165,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // child: ListView(
                          //   scrollDirection: Axis.horizontal,
                          children: [
                            CoursesButton(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        LBCScreen(courseID: 0),
                                    transitionsBuilder:
                                        (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                              course: "Introduction to Machine Learning",
                              topics: "6",
                              width: width,
                            ),
                            CoursesButton(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        LBCScreen(courseID: 1),
                                    transitionsBuilder:
                                        (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                              course: "Artificial Intelligence",
                              topics: "6",
                              width: width,
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Recent Attempts",
                            style: GoogleFonts.outfit(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Flexible(
                          child: DropdownButtonWidget(
                            items: ["All Courses", "Machine Learning", "Artificial Intelligence"],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                attempts(context, 'Pandas & Numpy'),
                const SizedBox(
                  height: 15,
                ),
                attempts(context, 'Logical Programming'),
                const SizedBox(
                  height: 15,
                ),
                attempts(context, 'Unsupervised Learning Basics'),
                // attempts(context, 'Pandas & Numpy'),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card attempts(BuildContext context, String text) {
    return Card(
      color: (Theme.of(context).colorScheme.secondary == Colors.black) ? Colors.white : Color(0xff212121),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(text, style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  )
              ),),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                  children: [Text('Level: ', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,color: Theme.of(context).colorScheme.secondary,),), Text('Beginner',style: TextStyle(fontSize: 15,color: Theme.of(context).colorScheme.secondary,),)]),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.tertiary),
                    Container(
                      height: 4,
                      width: 83,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    Icon(Icons.radio_button_checked, color: Theme.of(context).colorScheme.tertiary,),
                    Container(
                      height: 4,
                      width: 83,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    Icon(Icons.radio_button_checked, color: Theme.of(context).colorScheme.tertiary,),
                    Container(
                      height: 4,
                      width: 83,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    Icon(Icons.radio_button_checked, color: Theme.of(context).colorScheme.tertiary,),
                  ],
                ),
              ),
            )
          ],),
      ),
    );
  }
}