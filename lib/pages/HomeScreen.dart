import 'package:bekushal/constants/textStyles.dart';
import 'package:bekushal/pages/LBCScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/homeWidgets.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "Yoru";
  String photoUrl = "https://dotesports.com/wp-content/uploads/2021/01/12162418/Yoru.png";

  Future<void> getDetails() async{
      username = username ?? "Yoru";
      photoUrl = photoUrl ?? "https://dotesports.com/wp-content/uploads/2021/01/12162418/Yoru.png";
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
                              return Text(
                                "Welcome, $username!",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.outfit(
                                  textStyle: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
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

                        },
                        child: FutureBuilder(
                          future: getDetails(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            return CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(photoUrl),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                            boldText: "911 days",
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 1.5,
                          ),
                          BlueButton(
                            imageIcon: "assets/images/clock.png",
                            smallText: "Total Hours",
                            boldText: "68 hrs",
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
