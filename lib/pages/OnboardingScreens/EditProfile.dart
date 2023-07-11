import 'dart:io';
import 'package:bekushal/pages/OnboardingScreens/DisplayInfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../BottomNavbar.dart';
import '../../components/customRadio.dart';
import '../../constants/textStyles.dart';
import 'OnboardingScreen.dart';
import 'ProfilePic.dart';
import 'UserForm.dart';

class EditProfile extends StatefulWidget {
  static String id = "EditProfile";
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _occupationController;
  late String _gender;

  late SharedPreferences prefs;
  late String profilePicturePath;

  bool isNameEditable = false;
  bool isEmailEditable = false;
  bool isMobileEditable = false;
  bool isOccupationEditable = false;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _occupationController = TextEditingController();
    _gender = 'other';
    loadProfileData(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  void loadProfileData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profilePicturePath = prefs.getString('profilePicturePath') ?? '';
    if (profilePicturePath.isNotEmpty) {
      context.read<PicProvider>().setImageFile(File(profilePicturePath));
      setState(() {});
    }
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _mobileNumberController.text = prefs.getString('mobileNumber') ?? '';
      _occupationController.text = prefs.getString('occupation') ?? '';
      _gender = prefs.getString('gender') ?? 'other';

      context.read<UserProvider>().setName(_nameController.text);
      context.read<UserProvider>().setEmail(_emailController.text);
      context.read<UserProvider>().setMobileNumber(_mobileNumberController.text);
      context.read<UserProvider>().setOccupation(_occupationController.text);
      context.read<UserProvider>().setGender(_gender);

    });
  }

  void updateProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('mobileNumber', _mobileNumberController.text);
    await prefs.setString('occupation', _occupationController.text);
    await prefs.setString('gender', _gender);

    context.read<UserProvider>().setName(_nameController.text);
    context.read<UserProvider>().setEmail(_emailController.text);
    context.read<UserProvider>().setMobileNumber(_mobileNumberController.text);
    context.read<UserProvider>().setOccupation(_occupationController.text);
    context.read<UserProvider>().setGender(_gender);

  }

  void _deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    context.read<UserProvider>().deleteUserInformation();
    Navigator.pushNamedAndRemoveUntil(
      context,
      OnboardingScreen.id,
          (route) => false,
    );
  }

  void toggleNameEdit() {
    setState(() {
      isNameEditable = !isNameEditable;
    });
  }
  void toggleEmailEdit() {
    setState(() {
      isEmailEditable = !isEmailEditable;
    });
  }
  void toggleMobileEdit() {
    setState(() {
      isMobileEditable = !isMobileEditable;
    });
  }
  void toggleOccupationEdit() {
    setState(() {
      isOccupationEditable = !isOccupationEditable;
    });
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete your account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteAccount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Edit Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                updateProfileData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated'),
                  ),
                );
                Navigator.pushNamed(context, DisplayInfo.id);
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xffEAF0F9),
            ),
            child: const Text('Save',style: TextStyle(
                fontSize: 23,
                color: Color(0xffFF4081)
            ),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: 'profilePic',
                          child: Consumer<PicProvider>(
                            builder: (context, imageProvider, _) {
                              if (imageProvider.imageFile == null) {
                                return const CircleAvatar(
                                  radius: 80,
                                  backgroundImage: AssetImage('assets/images/default_profile_pic.png'),
                                );
                              } else {
                                return   CircleAvatar(
                                    radius: 80,
                                    backgroundImage: FileImage(imageProvider.imageFile!) as ImageProvider
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: IconButton(
                              onPressed: () {
                                updateProfileData();
                                Navigator.pushNamed(context, ProfilePic.id);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),),
                      ],
                    ),
                    const SizedBox(height: 40.0,),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: 'Outfit',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isNameEditable ? Icons.done : Icons.edit),
                          onPressed: toggleNameEdit,
                        ),
                      ),
                      controller: _nameController,
                      enabled: true,
                      readOnly: !isNameEditable,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ), const SizedBox(height: 15.0,),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: 'Outfit',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isEmailEditable ? Icons.done : Icons.edit),
                          onPressed: toggleEmailEdit,
                        ),
                      ),
                      controller: _emailController,
                      enabled: true,
                      readOnly: !isEmailEditable,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ), const SizedBox(height: 15.0,),
                    TextFormField(
                      decoration:InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Outfit',
                          fontSize: 18,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isMobileEditable ? Icons.done : Icons.edit),
                          onPressed: toggleMobileEdit,
                        ),
                      ),
                      controller: _mobileNumberController,
                      enabled: true,
                      readOnly: !isMobileEditable,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 10) {
                          return 'Please enter a valid Mobile Number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gender:',style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0,top:16.0),
                              child: CustomRadioButton(
                                label: 'Male',
                                isSelected: _gender == 'male',
                                onChanged: (bool newValue) {
                                  setState(() {
                                    if (newValue) {
                                      _gender = 'male';
                                    }
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0,left: 16.0,top:16.0),
                              child: CustomRadioButton(
                                label: 'Female',
                                isSelected: _gender == 'female',
                                onChanged: (bool newValue) {
                                  setState(() {
                                    if (newValue) {
                                      _gender = 'female';
                                    }
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0,left: 16.0,top:16.0),
                              child: CustomRadioButton(
                                label: 'Other',
                                isSelected: _gender == 'other',
                                onChanged: (bool newValue) {
                                  setState(() {
                                    if (newValue) {
                                      _gender = 'other';
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0,),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Occupation',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Outfit',
                          fontSize: 18,
                        ),
                        suffixIcon: IconButton(
                          onPressed: toggleOccupationEdit,
                          icon: Icon(isOccupationEditable ? Icons.done : Icons.edit),
                        ),
                      ),
                      value: _occupationController.text.isEmpty ? null : _occupationController.text,
                      items: [
                        DropdownMenuItem(
                          value: 'Student',
                          child: Text('Student'),
                        ),
                        DropdownMenuItem(
                          value: 'Working Professional',
                          child: Text('Working Professional'),
                        ),
                      ],
                      onChanged: isOccupationEditable ? (value) {
                        _occupationController.text = value!;
                        context.read<UserProvider>().setOccupation(value);
                      } : null,
                      validator: (value) {
                        if (!isOccupationEditable) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please select an occupation';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.010),
              alignment: Alignment.bottomLeft,
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xffEAF0F9),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Hero(
        tag: "BottomNav",
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: BottomNavigationBar(
            selectedFontSize: 8,
            unselectedFontSize: 8,
            currentIndex: 2,
            selectedItemColor: Color(0xFF00B0FF),
            unselectedItemColor: Theme.of(context).colorScheme.outline,
            selectedLabelStyle: kBottomNavText,
            unselectedLabelStyle: kBottomNavText,
            iconSize: 25,
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
