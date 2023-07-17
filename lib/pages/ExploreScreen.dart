import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/commonWidgets.dart';
import '../components/exploreWidgets.dart';
import '../components/bottom_sheet.dart';
import '../utils/exploreModel.dart';

class ExploreScreen extends StatefulWidget {
  static String id = "ExploreScreen";
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController myController = TextEditingController();
  ValueNotifier<String> textValueNotifier = ValueNotifier<String>('');
  bool showResults = false;
  List<Course> allCourses = [];
  List<Topics> allTopics = [];
  List<Topics> searchResults = [];
  List<Topics> recentSearches = [];

  void searchTopics(String query) async{
    List<Topics> results = [];
    for(var topic in allTopics){
      List<String> searchTerms = topic.searchTerms.split(' ');
      if (searchTerms.contains(query.trim())) {
        results.add(topic);
      }
    }
    setState(() {
      searchResults = results;
    });
  }
  // Store all topics in a variable to display them
  Future<void> readData() async{
    String jsonString = await rootBundle.loadString('assets/data/inputData.json');
    List<Topics> topics = [];
    final jsonData = json.decode(jsonString) as List<dynamic>;
    allCourses = jsonData.map<Course>((item){
      var course = Course.fromJson(item);
      course.topics.forEach((element) {topics.add(element);});
      return course;
    }).toList();
    allTopics = topics;
  }
  // Save recent searches in local storage
  Future<void> saveRecentSearches() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = [];
    for(var search in recentSearches){
      data.add(jsonEncode(search));
    }
    prefs.setStringList('recentSearches', data);
  }
  // Load recent searches for local storage
  Future<void> getRecentSearches() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? searches = prefs.getStringList('recentSearches');
    if(searches != null){
      for(String search in searches){
        var json = jsonDecode(search);
        setState(() {
          recentSearches.add(Topics.fromJson(json));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRecentSearches();
  }
  @override
  void dispose() async{
    saveRecentSearches();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ScreenHeading(
                      heading: "Explore",
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    controller: myController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "What are you looking for ?",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 12.0),
                      hintStyle: TextStyle(
                        color: Colors.grey[700],
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: (showResults)
                          ? GestureDetector(
                            onTap: (){
                              setState(() {
                                showResults = false;
                                myController.clear();
                                FocusScope.of(context).unfocus();
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.lightBlue,
                                  size: 30.0,
                                ),
                            ),
                          )
                          : null,
                      suffixIcon: (!showResults)
                          ? const  Padding(
                              padding: EdgeInsets.symmetric(horizontal:20.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.lightBlue,
                                size: 30.0,
                              ),
                          )
                          : null,
                        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                    onSubmitted: (query) async {
                    // onChanged: (query) async {
                      setState(() {
                        if(query == "" || query.trimLeft() == ""){
                          showResults = false;
                        }
                        else{
                          showResults = true;
                          searchTopics(query.trimLeft().toUpperCase());
                        }
                      });
                    },
                  ),

                  Visibility(
                    visible: (recentSearches.isNotEmpty || showResults),
                    child: SizedBox(
                      height: (showResults) ? 18 : 15,
                    ),
                  ),

                  Visibility(
                    visible: showResults,
                    child: Container(
                      height: height*.7,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        // scrollDirection: Axis.vertical,
                        itemCount : searchResults.length,
                        itemBuilder: (BuildContext context, int idx) {
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                if(recentSearches.contains(searchResults[idx])){
                                  recentSearches.remove(searchResults[idx]);
                                }
                                recentSearches.insert(0, searchResults[idx]);
                              });
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return BottomSheetMenu(
                                      height: height,
                                      width: width,
                                      selectedTopic: searchResults[idx],
                                    );
                                  }
                              );
                            },
                            child: TopicCard(
                              width: width,
                              bgColor: (Theme.of(context).colorScheme.secondary == Colors.black) ? Colors.white : Color(0xff212121),
                              textColor: Theme.of(context).colorScheme.secondary,
                              text: searchResults[idx].topicName,
                              bigBox: true,
                              height: height*0.15,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Recent Searches
                  Visibility(
                    visible: (!recentSearches.isEmpty),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width*0.6,
                              child: Text(
                                "Recent Searches",
                                style: GoogleFonts.outfit(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.secondary,
                                    )
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Clear Search History'),
                                      content: const SingleChildScrollView(
                                        child: Text('Do you want to clear your search history?'),
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
                                            setState(() {
                                              recentSearches.clear();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Clear All",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            height: 140,
                            width: width,
                            child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount : recentSearches.length,
                              itemBuilder: (BuildContext context, int idx) {
                                // return Container(width: 100, color: Colors.red,);
                                return GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return BottomSheetMenu(
                                            height: height,
                                            width: width,
                                            selectedTopic: recentSearches[idx],
                                          );
                                        }
                                    );
                                  },
                                  onLongPress: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Search History'),
                                          content: SingleChildScrollView(
                                            child: Text('Do you want to remove "${recentSearches[idx].topicName}" from your search history?'),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                  'Cancel',
                                                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(color: Colors.red),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  recentSearches.remove(recentSearches[idx]);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: TopicCard(
                                    width: width,
                                    bgColor: (Theme.of(context).colorScheme.secondary == Colors.black) ? Colors.white : Color(0xff212121),
                                    textColor: Theme.of(context).colorScheme.secondary,
                                    text: recentSearches[idx].topicName,
                                    height: height*0.15,
                                  ),
                                );
                              },
                            )
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width*0.5,
                          height: 1,
                          color: Theme.of(context).colorScheme.tertiary,
                          child: Divider(
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Courses
                  Visibility(
                    visible: !showResults,
                    child: FutureBuilder(
                      future: readData(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        return ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allCourses.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: width*0.6,
                                        child: Text(
                                          allCourses[index].courseName,
                                          style: GoogleFonts.outfit(
                                              textStyle: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).colorScheme.secondary,
                                              )
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 35,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ],
                                  ),
                                  Container(
                                      height: 140,
                                      width: width,
                                      child: ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount : allCourses[index].topics.length,
                                        itemBuilder: (BuildContext context, int idx) {
                                          return GestureDetector(
                                            onTap: (){
                                              showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) {
                                                    return BottomSheetMenu(
                                                      height: height,
                                                      width: width,
                                                      selectedTopic: allCourses[index].topics[idx],
                                                    );
                                                  }
                                              );
                                            },
                                            child: TopicCard(
                                              width: width,
                                              bgColor: (Theme.of(context).colorScheme.secondary == Colors.black) ? Colors.white : Color(0xff212121),
                                              textColor: Theme.of(context).colorScheme.secondary,
                                              text: allCourses[index].topics[idx].topicName,
                                            ),
                                          );
                                        },
                                      )
                                  ),
                                  SizedBox(
                                    height: 12.0,
                                  )
                                ],
                              );
                            }
                        );
                      },
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
