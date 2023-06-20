import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../Components/Buttons.dart';
import '../constants/textStyles.dart';
import '../utils/lbcModel.dart';

class LBCScreen extends StatefulWidget {
  static String id = "LBCScreen";
  int courseID;

  LBCScreen({super.key, required this.courseID});

  @override
  State<LBCScreen> createState() => _LBCScreenState();
}

class _LBCScreenState extends State<LBCScreen> {

  Future<List<LbcDataModel>> ReadJsonData() async {
    final jsondata = await rootBundle.rootBundle.loadString('assets/data/inputData.json');
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
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              pinned: false,
              automaticallyImplyLeading: false,
              toolbarHeight: 215,
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
                    FutureBuilder(
                        future: ReadJsonData(),
                        builder: (context, data) {
                          if (data.hasError) {
                            return Center(child: Text("${data.error}"));
                          } else if (data.hasData) {
                            var items = data.data as List<LbcDataModel>;
                            return Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                items[widget.courseID].courseName.toString(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.outfit(
                                  textStyle: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<List<LbcDataModel>>(
                  future: ReadJsonData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      var items = snapshot.data!;
                      var courses = items[widget.courseID].topics;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: courses!.length,
                        itemBuilder: (context, courseIndex) {
                          var course = courses[courseIndex];
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
                                            course.topicName!,
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
                                    trailing: ElevatedButton(
                                        onPressed: () {},
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
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 15,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: const Color(0xFF00B0FF),
          unselectedItemColor: Theme.of(context).colorScheme.outline,
          selectedLabelStyle: kBottomNavText,
          unselectedLabelStyle: kBottomNavText,
          iconSize: 35,
          elevation: 1.5,
          onTap: (int index) {
            setState(() {
              print(index);
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
