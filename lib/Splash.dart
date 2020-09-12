import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/Login.dart';
import 'Home.dart';

class Splash extends StatefulWidget {


  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer t;
  void goToHome() {
    Timer.periodic(Duration(milliseconds: 900), (t) async {
      var cuser = await FirebaseAuth.instance.currentUser(); 
      if (cuser != null) {
        print(cuser.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
      }
      t.cancel();
    });
  }
  
  @override
  void initState() {
    goToHome();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 10,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                // side: BorderSide(width: 3, color: Color.fromRGBO(243,182,58, 1))
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
                        fontSize: 27
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}