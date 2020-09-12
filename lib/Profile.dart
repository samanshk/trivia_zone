import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/Login.dart';

import 'Home.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int maxScore = null, totalScore = null;
  // List<dynamic> scores, sortedScores;
  List<dynamic> scores;
  String name;
  bool signingOut = false;

  logOut() async {
    showDialog(
      context: context,
      builder: (BuildContext context){
          return AlertDialog(
            title: Text("Log out of Trivia Zone?", textAlign: TextAlign.center,),
            content: signingOut ?
            CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(64,75,250, 1), 
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(243,182,58, 1))
            ) :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
                    });
                    setState(() {
                      signingOut = true;
                    });
                  },
                  child: Text('Log Out')
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')
                )
              ],
            ),
          );
      }
    );
    // await FirebaseAuth.instance.signOut().then((value) {
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (Route<dynamic> route) => false);
    // });
  }

  getUserData() async {
    var user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    // List<dynamic> sortedScores;
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    await ref.child(uid).once().then((data) {
      // print(data.value[1].toString());
      setState(() {
        name = data.value['username'];
        scores = data.value['scores'];
        List<dynamic> sortedScores = scores;
        sortedScores.sort();
        maxScore = sortedScores.last;
        totalScore = scores.reduce((a, b) => a + b);
      });
      print(name);
      print(scores);
      print(maxScore);
      print(totalScore);
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Color.fromRGBO(230,105,110, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.audiowide(
                    fontSize: 40,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  children: <Widget>[
                    Text(
                      'High Score',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      '$maxScore',
                      style: TextStyle(
                        fontSize: 50
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Column(
                  children: <Widget>[
                    Text(
                      'Total Score',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      '$totalScore',
                      style: TextStyle(
                        fontSize: 50
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text(
                  'Scores',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(0,0,0, 0.4),
                  ),
                  child: ListView.builder(                    
                    scrollDirection: Axis.horizontal,
                    itemCount: scores.length - 1,
                    itemBuilder: (context, i) {
                      return Text(
                        ' ${scores[scores.length - 1 - i]} ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35
                        ),
                      );
                    }
                  ),
                ),
                SizedBox(height: 30),
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
                    child: Text(
                      ' Home ',
                      style: GoogleFonts.audiowide(
                        fontSize: 30
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  onPressed: logOut,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: Color.fromRGBO(243,182,58, 1), width: 4)
                  ),
                  color: Colors.red[700],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Log out',
                      style: GoogleFonts.audiowide(
                        fontSize: 20
                      ),
                    ),
                  ),
                )
              ]
            ),
          )
        ),
      ),
    );
  }
}