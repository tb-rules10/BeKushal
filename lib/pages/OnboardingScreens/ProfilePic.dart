import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'Display.dart';
import 'package:path/path.dart' as path;

import '../../BottomNavbar.dart';


class PicProvider extends ChangeNotifier {
  File? _imageFile;

  File? get imageFile => _imageFile;

  void setImageFile(File file) {
    _imageFile = file;
    notifyListeners();
  }
}


class ProfilePic extends StatefulWidget {
  static String id = "ProfilePic";
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {

  late SharedPreferences prefs;
  late String profilePicturePath;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    profilePicturePath = prefs.getString('profilePicturePath') ?? '';
    if (profilePicturePath.isNotEmpty) {
      context.read<PicProvider>().setImageFile(File(profilePicturePath));
      setState(() {});
    }
  }

  Future<void> _pickProfilePicture() async {

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {

      String imagePath = pickedImage.path;
      File imageFile = File(imagePath);

      await imageFile.writeAsBytes(await pickedImage.readAsBytes());
      await prefs.setString('profilePicturePath', imagePath);

      profilePicturePath = (await prefs.getString('profilePicturePath'))!;

      context.read<PicProvider>().setImageFile(File(profilePicturePath));

      setState(() {
        profilePicturePath = imagePath;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00B0FF),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        decoration: const BoxDecoration(
          color: Color(0xffEAF0F9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Add a Profile Picture',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),),
            SizedBox(height: 70,),
            Center(
              child: Stack(
                children: [
                  Hero(
                    tag: 'profilePic',
                    child: Consumer<PicProvider>(
                      builder: (context, imageProvider, _) {
                        if (imageProvider.imageFile == null) {
                          return const CircleAvatar(
                            radius: 150,
                            backgroundImage: AssetImage('assets/images/default_profile_pic.png'),
                          );
                        } else {
                          return   CircleAvatar(
                              radius: 150,
                              backgroundImage: FileImage(imageProvider.imageFile!) as ImageProvider
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _pickProfilePicture();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickProfilePicture,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color(0xffEAF0F9),
              ),
              child: const Text('Change Picture',style: TextStyle(
                color: Color(0xff1E1E1E),
                fontSize: 23,
              ),),
            ), const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BottomNavbar.id,
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.75, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Set Profile Picture'),),
          ],
        ),
      ),

    );
  }
}
