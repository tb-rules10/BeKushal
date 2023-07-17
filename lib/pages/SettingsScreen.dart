// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_import

import 'package:bekushal/pages/OnboardingScreens/DisplayInfo.dart';
import 'package:bekushal/pages/OtherScreens/OutTeamScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/buttons.dart';
import '../components/commonWidgets.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "SettingsScreen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: ScreenHeading(heading: 'Settings'),
            ),  
            SubHeading(context, 'Account'),
            Tile(context, 'Profile', () {
              Navigator.pushNamed(context, DisplayInfo.id);
            },
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            // SubHeading(context, 'Theme'),
            // Tile(context, 'Dark Mode', () {
            //   print('Callback function called!');
            // }, SwitchExample()),
            SubHeading(context, 'About'),
            // Tile(context, 'Version', () {
            //   print('Callback function called!');
            // },
            //     Text(
            //       '1.0.0',
            //       style: GoogleFonts.inter(
            //           textStyle: TextStyle(
            //               fontSize: 15,
            //               color: Theme.of(context).colorScheme.secondary,
            //               fontWeight: FontWeight.w600)),
            //     )),
            // Tile(context, 'Terms of Use', () {
            //     print('Callback function called!');
            //   },
            //   null,
            // ),
            // Tile(context, 'Privacy Policy', () {
            //   print('Callback function called!');
            // }, null),
            Tile(context, 'Our Team', () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      OurTeamScreen(),
                ),
              );
            },
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            // SubHeading(context, 'Support'),
            // Tile(context, 'Report a Bug', () {
            //   print('Callback function called!');
            // },
            //     Icon(
            //       Icons.arrow_forward_ios,
            //       color: Theme.of(context).colorScheme.secondary,
            //     )),
            const SizedBox(
              height: 25,
            )
          ]),
        ),
      ),
    );
  }

  Padding Tile(
      BuildContext context, String text, Function callback, var trailingItem) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.7),
      child: Container(
          height: height * 0.07,
          color: (Theme.of(context).colorScheme.secondary == Colors.black)
              ? Colors.white
              : Color(0xff212121),
          child: GestureDetector(
            onTap: () => callback(),
            child: ListTile(
              // horizontalTitleGap: 50,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  )),
                ),
              ),
              trailing: trailingItem,
            ),
          )),
    );
  }

  Column SubHeading(BuildContext context, String text) {
    return Column(
      children: [
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 20, 7),
          child: Text(
            text,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (light) {
          return Color(0xFF00B0FF).withOpacity(0.4);
        } else if (!light) {
          return Colors.transparent.withOpacity(0.2);
        }
        return null;
      },
    );

    return Switch.adaptive(
      // This bool value toggles the switch.
      value: light,
      trackColor: trackColor,
      thumbColor: const MaterialStatePropertyAll<Color>(Color(0xFF00B0FF)),
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
