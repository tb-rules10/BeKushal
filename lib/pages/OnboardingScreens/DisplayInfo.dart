import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../BottomNavbar.dart';
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

    context.read<UserProvider>().setName(_name);
    context.read<UserProvider>().setEmail(_email);

    if (_profilePicturePath.isNotEmpty) {
      context.read<PicProvider>().setImageFile(File(_profilePicturePath));
      setState(() { });}

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
          color:  const Color(0xff00B0FF),
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
                setState(() {
                });
              });
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xffEAF0F9),
            ),
            child: const Text('Edit',style: TextStyle(
                fontSize: 23,
                color: Color(0xffFF4081)
            ),),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.1),
            Hero(
              tag: 'profilePic',
              child: Consumer<PicProvider>(
                builder: (context, imageProvider, _) {
                  if (imageProvider.imageFile == null) {
                    return const CircleAvatar(
                      radius: 125,
                      backgroundImage: AssetImage('assets/images/default_profile_pic.png'),
                    );
                  } else {
                    return   CircleAvatar(
                        radius: 125,
                        backgroundImage: FileImage(imageProvider.imageFile!) as ImageProvider
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Consumer<UserProvider>(
                  builder: (context,userProvider,_){
                    if(userProvider.name == null || userProvider.name == ''){
                      return Text('No Username');
                    }else{
                      return Text(userProvider.name!,style: const TextStyle(
                        fontSize: 34,
                        color: Color(0xff00344C),
                        fontWeight: FontWeight.bold,
                      ),);
                    }
                  }
              ),
            ),
            Center(
              child: Consumer<UserProvider>(
                  builder: (context,userProvider,_){
                    if(userProvider.email == null || userProvider.email == ''){
                      return Text('No E-mail');
                    }else{
                      return Text(userProvider.email!,style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff00344C),
                        fontWeight: FontWeight.w400,
                      ),);
                    }
                  }
              ),
            ),
            const SizedBox(height: 16.0),
          ],
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
              if(index == 2) Navigator.pop(context);
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
