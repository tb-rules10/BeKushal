import 'package:bekushal/pages/OnboardingScreens/ProfilePic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../../components/customRadio.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _mobileNumber;
  String? _occupation;
  String? _gender;

  String? get name => _name;
  String? get email => _email;
  String? get mobileNumber => _mobileNumber;
  String? get occupation => _occupation;
  String? get gender => _gender;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setMobileNumber(String mobileNumber) {
    _mobileNumber = mobileNumber;
    notifyListeners();
  }

  void setOccupation(String occupation) {
    _occupation = occupation;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }
  void deleteUserInformation() {
    _name = null;
    _email = null;
    _mobileNumber = null;
    _occupation = null;
    notifyListeners();
  }
}

class UserForm extends StatefulWidget {
  static String id = "UserForm";
  UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  //Forms Data
  late String name,email,gender='other',occupation,mobileNumber;
  late DateTime dateOfBirth;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> OnboardingCompleted(BuildContext context) async {
    try{
      await prefs.setBool('onboardingCompleted', true);
      await prefs.setString('name',name);
      await prefs.setString('email',email);
      await prefs.setString('mobileNumber',mobileNumber);
      await prefs.setString('occupation',occupation);
      await prefs.setString('gender',gender);

      context.read<UserProvider>().setName(name);
      context.read<UserProvider>().setEmail(email);
      context.read<UserProvider>().setMobileNumber(mobileNumber);
      context.read<UserProvider>().setOccupation(occupation);
      context.read<UserProvider>().setGender(gender);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Created'),
        ),
      );
    }catch(error){
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00B0FF),
      body:SingleChildScrollView(
        child: Container(
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Adjust the border radius
                child: Container(
                  height: 8.0,
                  width: 80.0, // Adjust the width of the line
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.grey, // Adjust the color of the line
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.060),
                child: const Text("Create Your Account",style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                ),),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                              fontSize: 16,
                            )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value!;
                          context.read<UserProvider>().setName(value);
                        },
                      ),const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                              fontSize: 16,
                            )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address.\n Example: john@example.com';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value!;
                          context.read<UserProvider>().setEmail(value);
                        },
                      ),const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                            fontSize: 16,
                          ),
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty || value.length != 10){
                            return 'Please enter a valid 10-digit mobile number.\nExample: 1234567890';
                          }
                          return null;
                        },
                        onSaved: (value){
                          mobileNumber = value!;
                          context.read<UserProvider>().setMobileNumber(value);
                        },
                      ),const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gender:',style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                          ),),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0,top:16.0),
                                child: CustomRadioButton(
                                  label: 'Male',
                                  isSelected: gender == 'male',
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      if (newValue) {
                                        gender = 'male';
                                        context.read<UserProvider>().setGender('male');
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0,left: 16.0,top:16.0),
                                child: CustomRadioButton(
                                  label: 'Female',
                                  isSelected: gender == 'female',
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      if (newValue) {
                                        gender = 'female';
                                        context.read<UserProvider>().setGender('female');
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0,left: 16.0,top:16.0),
                                child: CustomRadioButton(
                                  label: 'Other',
                                  isSelected: gender == 'other',
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      if (newValue) {
                                        gender = 'other';
                                        context.read<UserProvider>().setGender('other');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),const SizedBox(height: 20.0,),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Occupation',
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w700,
                                )
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please enter a occupation';
                              }
                              return null;
                            },
                            onSaved: (value){
                              occupation = value!;
                              context.read<UserProvider>().setOccupation(value);
                            },
                          ),
                          const SizedBox(height: 35.0),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await OnboardingCompleted(context);
                                      Navigator.pushNamed(context, ProfilePic.id);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff00B0FF),
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.75, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                  child: const Text('Next',style: TextStyle(
                                    fontFamily: 'Outfit',
                                  ),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}