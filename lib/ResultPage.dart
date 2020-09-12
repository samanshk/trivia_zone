import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/Home.dart';
import 'package:quiz_app/Profile.dart';


class ResultPage extends StatefulWidget {
  int score;
  ResultPage(this.score);
  @override
  _ResultPageState createState() => _ResultPageState(score);
}

class _ResultPageState extends State<ResultPage> {
  int score;
  _ResultPageState(this.score);
  var maxScore = null, totalScore = null;


  updateScore() async {
    var user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var scList = await ref.child(uid).child('scores').once();
    List<dynamic> scores = [...scList.value];
    scores.add(score);
    ref.child(uid).child('scores').set(scores).then((value) => print('score added'));
    setState(() {
      scores.sort();
      maxScore = scores.last;
      totalScore = scores.reduce((a, b) => a + b);
    });
  }

  @override
  void initState() {
    updateScore();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: (maxScore == null && totalScore == null) ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(64,75,250, 1), 
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(243,182,58, 1))
            )
          ],
        ),
      ) :
      SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color:  Color.fromRGBO(230,105,110, 1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 10,
                  color: Colors.black,
                  // shadowColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'TRIVIA',
                          style: GoogleFonts.arbutus(
                            color: Colors.white,
                            fontSize: 30
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Z O N E',
                          style: GoogleFonts.arbutus(
                            color: Colors.white,
                            fontSize: 27.5
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),
                ),
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 100
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'High Score',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                        Text(
                          '$maxScore',
                          style: TextStyle(
                            fontSize: 70
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Total Score',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                        Text(
                          '$totalScore',
                          style: TextStyle(
                            fontSize: 70
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                      },
                      color: Color.fromRGBO(64,75,250, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Color.fromRGBO(243,182,58, 1), width: 4)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.home, color: Colors.white, size: 40),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Color.fromRGBO(243,182,58, 1), width: 4)
                      ),
                      color: Color.fromRGBO(64,75,250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () => exit(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(color: Color.fromRGBO(243,182,58, 1), width: 4)
                      ),
                      color: Color.fromRGBO(64,75,250, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.exit_to_app, color: Colors.white, size: 40,),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}