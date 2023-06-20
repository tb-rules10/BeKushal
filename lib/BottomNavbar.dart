import 'dart:ui';
import 'package:bekushal/constants/textStyles.dart';
import 'package:bekushal/pages/ExploreScreen.dart';
import 'package:bekushal/pages/HomeScreen.dart';
import 'package:bekushal/pages/SettingsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavbar extends StatefulWidget {
  static String id = "BottomNavbar";

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 1;
  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    SettingsScreen(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  // }
  //
  // @override
  // void dispose() {
  //   // Reset the preferred orientations to allow all orientations
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
            // return SlideTransition(
            //   position: Tween<Offset>(
            //     begin: const Offset(1, 0), // Slide from right
            //     end: Offset.zero,
            //   ).animate(animation),
            //   child: child,
            // );
          },
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Color(0xFF00B0FF),
          unselectedItemColor: Theme.of(context).colorScheme.outline,
          selectedLabelStyle: kBottomNavText,
          unselectedLabelStyle: kBottomNavText,
          iconSize: 35,
          elevation: 1.5,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
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