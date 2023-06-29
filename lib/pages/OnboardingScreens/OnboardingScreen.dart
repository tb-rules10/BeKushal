import 'package:bekushal/pages/OnboardingScreens/UserForm.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "OnboardingScreen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  List<Map<String, String>> splashData = [
    { "image": "assets/images/Onboarding1.png",
      "headingtext": 'Effective Self-Shiksha',
      "contenttext":'Learn the fundamentals of Data Science and Machine Learning effectively through self-study',
    },
    {
      "image":'assets/images/Onboarding2.png',
      "headingtext": 'Enhanced Learning and Assessment',
      "contenttext":'Interspersed MCQs: A powerful way to improve learning and assessment.'
    },
    {
      "image":'assets/images/Onboarding3.png',
      "headingtext": 'Assess Your Proficiency with Ease',
      "contenttext":'View your proficiency level in any subject and get insights for tracking progress & identifying areas of improvement.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffEAF0F9),
        body: Column(
          children: [
            Container(
              child: Expanded(
                flex: 3,
                child: PageView.builder(
                  itemCount: splashData.length,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) => OnBoardingPage(
                    image: splashData[index]["image"]!,
                    headingtext: splashData[index]['headingtext']!,
                    contenttext: splashData[index]['contenttext']!,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: _currentPage == 2 ?
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, UserForm.id);
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
                  color: Colors.white,
                  fontSize: 23,
                ),),
              ) :
              DotsIndicator(
                dotsCount: splashData.length,
                position: _currentPage,
                decorator: const DotsDecorator(
                  activeColor: Colors.blue,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {

  final String image;
  final String headingtext;
  final String contenttext;
  const OnBoardingPage({required this.image,required this.headingtext, required this.contenttext});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,height: 361.0),
          const SizedBox(height: 10),
          Text(headingtext,textAlign: TextAlign.center,style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(contenttext,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontSize:18,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                )
              ),),
          ),
        ],
      ),
    );
  }
}

