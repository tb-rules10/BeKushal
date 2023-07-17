// ignore_for_file: must_be_immutable, file_names

import 'package:bekushal/BottomNavbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../../Components/Buttons.dart';
import '../../components/bottom_sheet.dart';
import '../../constants/textStyles.dart';
import '../../utils/exploreModel.dart';
import '../../utils/lbcModel.dart';

class LBCScreen extends StatefulWidget {
  static String id = "LBCScreen";
  late int courseID;

  LBCScreen({super.key, required this.courseID});

  @override
  State<LBCScreen> createState() => _LBCScreenState();
}

class _LBCScreenState extends State<LBCScreen> {
  List<Course> allCourses = [];
  List<Topics> allTopics = [];

// Functions to read data from the inputData.json
  Future<void> readData() async {
    String jsonString =
        await rootBundle.rootBundle.loadString('assets/data/inputData.json');
    List<Topics> topics = [];

    // Storing data in form of List<Dynamic>
    final jsonData = json.decode(jsonString) as List<dynamic>;
    allCourses = jsonData.map<Course>((item) {
      var course = Course.fromJson(item);
      course.topics.forEach((element) {
        topics.add(element);
      });
      return course;
    }).toList();
    allTopics = topics;
  }

  Future<List<LbcDataModel>> ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('assets/data/inputData.json');
    final list = json.decode(jsondata) as List<dynamic>;

    return list.map((e) => LbcDataModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            // SilverAppBar to impliment scrollable appbar
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              pinned: false,
              automaticallyImplyLeading: false,
              toolbarHeight: height * 0.24,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              flexibleSpace: Padding(
                padding: EdgeInsets.fromLTRB(28, 15, 26, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const GoBackButton(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    ),

                    // fetching data and return as a container
                    FutureBuilder(
                        future: ReadJsonData(),
                        builder: (context, data) {
                          if (data.hasError) {
                            return Center(child: Text("${data.error}"));
                          } else if (data.hasData) {
                            var items = data.data as List<LbcDataModel>;
                            return Align(
                              alignment: Alignment.bottomLeft,
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  double fontSize = height * 0.04;
                                  return Container(
                                    constraints:
                                        BoxConstraints(maxHeight: height),
                                    child: Text(
                                      items[widget.courseID]
                                          .courseName
                                          .toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.outfit(
                                        textStyle: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                  ],
                ),
              ),
            ),

            // Subjects
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Subjects',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    Container(
                      width: 95,
                      child: Divider(
                        thickness: 1.5,
                        indent: 2,
                        height: 8,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),

            // using listview builder to make list of all the subjects dynamically through json
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                  future: readData(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: allCourses[widget.courseID].topics.length,
                      itemBuilder: (context, courseIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: SizedBox(
                                child: ListTile(
                                  title: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 25),
                                        child: Text(
                                          allCourses[widget.courseID]
                                              .topics[courseIndex]
                                              .topicName,
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.white,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      )),
                                      // showing the bottomsheet on pressing the button
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return BottomSheetMenu(
                                                height: height,
                                                width: width,
                                                selectedTopic:
                                                    allCourses[widget.courseID]
                                                        .topics[courseIndex],
                                              );
                                            });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        fixedSize: const Size(50, 50),
                                        shape: const CircleBorder(),
                                        backgroundColor: Color(0xffEAF0F9),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_sharp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      )),
                                ),
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
          ],
        ),
        
        // BottomNavbar
        bottomNavigationBar: Hero(
          tag: "BottomNav",
          child: SizedBox(
            height: 74,
            child: BottomNavigationBar(
              selectedFontSize: 8,
              unselectedFontSize: 8,
              currentIndex: 0,
              selectedItemColor: Color(0xFF00B0FF),
              unselectedItemColor: Theme.of(context).colorScheme.outline,
              selectedLabelStyle: kBottomNavText,
              unselectedLabelStyle: kBottomNavText,
              iconSize: 25,
              elevation: 1.5,
              onTap: (int index) {
                setState(() {
                  if (index == 0) Navigator.pop(context);
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
      ),
    );
  }
}
