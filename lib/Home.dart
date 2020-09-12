import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/QuizPage.dart';

import 'Profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double btnDepth = 10;

  Widget ModeButton(String mode) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(mode)));
      },
      child: Card(
        elevation: btnDepth,
        color: Color.fromRGBO(64,75,250, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(width: 7, color: Color.fromRGBO(243,182,58, 1))
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            mode,
            textAlign: TextAlign.center,
            style: GoogleFonts.audiowide(
              fontSize: 40,
              // fontWeight: FontWeight.bold,
              // color: Color.fromRGBO(243,182,58, 1)
              color: Colors.white
            ),
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Color.fromRGBO(230,105,110, 1),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      elevation: 10,
                      color: Colors.black,
                      // shadowColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'TRIVIA',
                              style: GoogleFonts.arbutus(
                                color: Colors.white,
                                fontSize: 60
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Z O N E',
                              style: GoogleFonts.arbutus(
                                color: Colors.white,
                                fontSize: 55
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(20)),
                        ModeButton('Standard'),
                        Padding(padding: EdgeInsets.all(10)),
                        ModeButton('Quick')
                      ],
                    )                  
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                        },
                        shape: CircleBorder(
                          // borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Color.fromRGBO(243,182,58, 1), width: 2)
                        ),
                        color: Color.fromRGBO(64,75,250, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}