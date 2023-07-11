// ignore_for_file: prefer_const_constructors, unnecessary_cast, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:bekushal/components/achievements.dart';
import 'package:bekushal/pages/QuizScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../BottomNavbar.dart';
import '../../components/drop_down.dart';
import '../../components/proficiency.dart';
import '../../constants/textStyles.dart';
import 'EditProfile.dart';
import 'ProfilePic.dart';
import 'UserForm.dart';

class DisplayInfo extends StatefulWidget {
  static String id = "DisplayInfo";
  const DisplayInfo({Key? key}) : super(key: key);

  @override
  _DisplayInfoState createState() => _DisplayInfoState();
}

class _DisplayInfoState extends State<DisplayInfo> {
  late SharedPreferences prefs;
  late String _profilePicturePath;
  late String _name = '';
  late String _email = '';
  // bool isCourseSelected = false;
  late int streak;
  late int attempted;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();

    _profilePicturePath = prefs.getString('profilePicturePath') ?? '';
    _name = prefs.getString('name') ?? '';
    _email = prefs.getString('email') ?? '';
    streak = (prefs.getInt('streak') ?? 0);
    attempted = (prefs.getInt('attempted') ?? 0);

    context.read<UserProvider>().setName(_name);
    context.read<UserProvider>().setEmail(_email);
    context.read<UserProvider>().streak!;
    context.read<UserProvider>().attempted;

    if (_profilePicturePath.isNotEmpty) {
      context.read<PicProvider>().setImageFile(File(_profilePicturePath));
      setState(() {});
    }
  }

  void onDropdownValueChanged(String value) {
    // Do something with the selected value
    print(value);
    setState(() {});
    // Perform setState or any other action based on the new value
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffEAF0F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: const Color(0xff00B0FF),
          iconSize: 30,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProfile.id).then((_) {
                setState(() {});
              });
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xffEAF0F9),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 23, color: Color(0xffFF4081)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: screenHeight * 0.02),
              Hero(
                tag: 'profilePic',
                child: Consumer<PicProvider>(
                  builder: (context, imageProvider, _) {
                    if (imageProvider.imageFile == null) {
                      return const CircleAvatar(
                        radius: 125,
                        backgroundImage:
                            AssetImage('assets/images/default_profile_pic.png'),
                      );
                    } else {
                      return CircleAvatar(
                          radius: 125,
                          backgroundImage: FileImage(imageProvider.imageFile!)
                              as ImageProvider);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child:
                    Consumer<UserProvider>(builder: (context, userProvider, _) {
                  if (userProvider.name == null || userProvider.name == '') {
                    return Text('No Username');
                  } else {
                    return Text(
                      userProvider.name!,
                      style: const TextStyle(
                        fontSize: 34,
                        color: Color(0xff00344C),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                }),
              ),
              Center(
                child:
                    Consumer<UserProvider>(builder: (context, userProvider, _) {
                  if (userProvider.email == null || userProvider.email == '') {
                    return Text('No E-mail');
                  } else {
                    return Text(
                      userProvider.email!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff00344C),
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(height: 16.0),

              // MyCourses and Achievements
              Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              // isCourseSelected = false;
                            });
                          },
                          child: Text(
                            'Achievements',
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.secondary,
                            )),
                          )),
                      Container(
                          width: 140,
                          child: Divider(
                            thickness: 3,
                            indent: 2,
                            height: 0,
                            color: Theme.of(context).colorScheme.secondary,
                          ))
                    ],
                  ),

              // My Courses
            

              // Achievements
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                      width: double.infinity,
                    ),
                    Text(
                      'Daily Streak',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    SizedBox(
                        height: 200,
                        child: Consumer<UserProvider>(
                            builder: (context, userProvider, _) {
                          if (userProvider.streak == null ||
                              userProvider.streak! < 7) {
                            return Text('No Achievements Yet');
                          } else if (userProvider.streak! >= 7 &&
                              userProvider.streak! <= 35) {
                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  // shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      (userProvider.streak! / 7).truncate(),
                                  itemBuilder: (context, index) {
                                    return achievementsDailyStreak(
                                        streak: (index + 1) * 7);
                                  }),
                            );
                          } else {
                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  // shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return achievementsDailyStreak(
                                        streak: (index + 1) * 7);
                                  }),
                            );
                          }
                        })),

                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Attemps',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    
                    SizedBox(
                        height: 200,
                        child: Consumer<UserProvider>(
                            builder: (context, userProvider, _) {
                          if (userProvider.attempted == null ||
                              userProvider.attempted! < 50) {
                            return Text('No Achievements Yet');
                          } else if (userProvider.attempted! >= 50 &&
                              userProvider.attempted! <= 250) {
                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  // shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      (userProvider.attempted! / 50).truncate(),
                                  itemBuilder: (context, index) {
                                    return achievementsAttemps(
                                        attempted: (index + 1) * 50);
                                  }),
                            );
                          } else {
                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  // shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return achievementsAttemps(
                                        attempted: (index + 1) * 50);
                                  }),
                            );
                          }
                        })),
                    // achievementsDailyattempted(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Hero(
        tag: "BottomNav",
        child: BottomNavigationBar(
          currentIndex: 2,
          selectedItemColor: const Color(0xFF00B0FF),
          unselectedItemColor: Theme.of(context).colorScheme.outline,
          selectedLabelStyle: kBottomNavText,
          unselectedLabelStyle: kBottomNavText,
          iconSize: 35,
          elevation: 1.5,
          onTap: (int index) {
            setState(() {
              if (index == 2) Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BottomNavbar(pageIndex: index),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
