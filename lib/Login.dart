
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/Forgot.dart';
import 'package:quiz_app/SIgnup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool enable = true;
  bool warn = false;

  signIn() async {

    if (emailController.text != '' && passController.text != '') {
      setState(() {
        enable = false;
      });
      try {
        final myUser = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text)
        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())));
        print(myUser.user.email);  
      } catch (e) {
        print(e);
        setState(() {
          enable = true;
          warn = true;
        });
      }  
    }
    

    // print(_auth.currentUser());  
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
              color:  Color.fromRGBO(230,105,110, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Login',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.audiowide(
                      fontSize: 40,
                      // fontWeight: FontWeight.bold,
                      // color: Color.fromRGBO(243,182,58, 1)
                      color: Colors.white
                    )
                  ),
                ),
                Visibility(
                  visible: warn,
                  child: Text(
                    'INVALID EMAIL OR PASSWORD',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: Color.fromRGBO(255, 255, 255, 0.5)),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white,),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white,),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    )
                  )
                ),
                Text(
                  '',
                  style: TextStyle(height: 1)
                ),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.enhanced_encryption, color: Color.fromRGBO(255, 255, 255, 0.8)),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    )
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20,),
                MaterialButton(
                  onPressed: enable ? signIn : null,
                  // elevation: 0,
                  child: enable ? 
                  Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 25
                    )
                  ) : 
                  CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(64,75,250, 1), 
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(243,182,58, 1))
                  ),
                  padding: EdgeInsets.only(top:15, bottom: 15, left: 10, right: 10),
                  color: Color.fromRGBO(64,75,250, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(width: 2, color: Color.fromRGBO(243,182,58, 1))
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Forgot()));
                  },
                  child: Text(
                    'Forgot Password', 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, height: 2),
                  )
                ),
                SizedBox(height: 40,),
                MaterialButton(
                  onPressed: enable ? () {Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));} : null,
                  child: Text(
                    'Create new account',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  padding: EdgeInsets.only(top:10, bottom: 10),
                  color: Color.fromRGBO(64,75,250, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(width: 2, color: Color.fromRGBO(243,182,58, 1))
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}