import 'dart:convert';

import 'package:flutter/material.dart';
import '../../utils/teamModel.dart';

class OurTeamScreen extends StatefulWidget {
  static String id = "OurTeamScreen";
  @override
  _OurTeamScreenState createState() => _OurTeamScreenState();
}

class _OurTeamScreenState extends State<OurTeamScreen> {
  List<Person> mentors = [];
  List<Person> developers = [];
  List<Person> futureDevelopers = [];

  @override
  void initState() {
    super.initState();
    loadTeamData();
  }

  Future<void> loadTeamData() async {
    String jsonData = await DefaultAssetBundle.of(context)
        .loadString('assets/data/team_data.json');
    Map<String, dynamic> data = json.decode(jsonData);

    setState(() {
      mentors = List<Person>.from(data['mentors'].map((person) => Person(
        name: person['name'],
        position: person['position'],
        image: person['image'],
      )));

      developers = List<Person>.from(data['developers'].map((person) => Person(
        name: person['name'],
        position: person['position'],
        image: person['image'],
      )));

      futureDevelopers =
      List<Person>.from(data['futureDevelopers'].map((person) => Person(
        name: person['name'],
        position: person['position'],
        image: person['image'],
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFEAF0F9),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              color: const Color(0xFF00B0FF),
              iconSize: 30,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Our Team',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Mentors',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF393536),
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 180.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: mentors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PersonCard(person: mentors[index]);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Developers',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF393536),
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 180.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: developers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PersonCard(person: developers[index]);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                if (futureDevelopers.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Future Developers',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF393536),
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 180.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: futureDevelopers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PersonCard(person: futureDevelopers[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
