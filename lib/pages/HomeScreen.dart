import 'package:bekushal/constants/textStyles.dart';
import 'package:bekushal/pages/OtherScreens/LBCScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/drop_down.dart';
import '../components/homeWidgets.dart';
import 'OnboardingScreens/DisplayInfo.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;
  String _profilePicturePath = '';
  String _name = '';
  String username = "Yoru";
  // String photoUrl = "https://dotesports.com/wp-content/uploads/2021/01/12162418/Yoru.png";

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
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder(
                            future: getDetails(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              return Container(
                                width: width*0.73,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Welcome, $_name!",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.outfit(
                                      textStyle: TextStyle(
                                        fontSize: 32,
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
                        child: FutureBuilder(
                          future: getDetails(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            return Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: false,
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: AssetImage(_profilePicturePath),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: (){
                    // future
                  },
                  child: Container(
                    height: 90,
                    width: width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BlueButton(
                            imageIcon: "assets/images/fire.png",
                            smallText: "Daily Streak",
                            boldText: "0 days",
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 1.5,
                          ),
                          BlueButton(
                            imageIcon: "assets/images/clock.png",
                            smallText: "Total Hours",
                            boldText: "0 hrs",
                          ),
                        ],
                      ),
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
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 180,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Attempts",
                      style: GoogleFonts.outfit(
                          textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                      ),
                    ),
                    SizedBox(width: 20,),
                    DropdownButtonWidget(items: ["All Courses", "Machine Learning", "Artificial Intelligence"],)
                  ],
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