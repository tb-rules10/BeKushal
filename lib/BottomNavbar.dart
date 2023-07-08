import 'dart:ui';
import 'package:bekushal/constants/textStyles.dart';
import 'package:bekushal/pages/ExploreScreen.dart';
import 'package:bekushal/pages/HomeScreen.dart';
import 'package:bekushal/pages/SettingsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomNavbar extends StatefulWidget {
  static String id = "BottomNavbar";

  int? pageIndex;
  BottomNavbar({
    this.pageIndex,
  });
  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int _currentIndex;
  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex ?? 0;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

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
        bottomNavigationBar: SizedBox(
          height: 65,
          child: BottomNavigationBar(
            selectedFontSize: 8,
            unselectedFontSize: 8,
            currentIndex: _currentIndex,
            selectedItemColor: Color(0xFF00B0FF),
            unselectedItemColor: Theme.of(context).colorScheme.outline,
            selectedLabelStyle: kBottomNavText,
            unselectedLabelStyle: kBottomNavText,
            iconSize: 25,
            elevation: 1.5,
            onTap: (int index) {
              if(index == 0 && _currentIndex !=0 && widget.pageIndex!= null) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
              setState(() {
                _currentIndex = index;
              });
            },
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}