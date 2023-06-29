import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Person {
  final String name;
  final String position;
  final String image;

  Person({
    required this.name,
    required this.position,
    required this.image,
  });
}

class PersonCard extends StatelessWidget {
  final Person person;

  const PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage(person.image),
            ),
            SizedBox(height: 10.0),
            Text(
              person.name,
              style: GoogleFonts.outfit(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
            const SizedBox(height: 5.0),
            Text(
              person.position,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
                fontFamily: 'Outfit', // Set the font family to 'Outfit'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
