import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/Home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:google_sign_in/google_sign_in.dart';


class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();

  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String warningText = '';
  bool warn = false, enable = true;
  checkInput() {
    if (userController.text.trim() == '') {
      setState(() {
        warningText = 'Please enter a username.';
        warn = true;
      });
    } 
    else if(emailController.text.length < 5 || !emailController.text.contains('@')) {
      setState(() {
        warningText = 'Please enter a valid email id.';
        warn = true;
      });
    } 
    else if(passController.text.length < 8) {
      setState(() {
        warningText = 'Password should contain at least 8 characters.';
        warn = true;
      });
    }
    else {
      setState(() {
        enable = false;
      });
      signUp();
    }
  }

  signUp() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passController.text)
      .then((value) {
        print('done');
        createUser();
      });
      print(newUser);  
    } catch (e) {
      if(e.toString().trim() == 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {  
        setState(() {
          warningText = 'The email address is already in use by another account.';
          warn = true;
        });
      }
      else if(e.toString().trim() == 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {  
        setState(() {
          warningText = 'Invalid email id.';
          warn = true;
        });
      }
      setState(() {
        enable = true;        
      });
      print(e);
    }
  }

  createUser() async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    FirebaseUser user = await _auth.currentUser();
    var uid = user.uid;
    List<int> scores = [0,];
    var userData = {
      'username': userController.text,
      'scores': scores
    };

    ref.child(uid).set(userData).then((value) {
      print('user added');
      signIn();
    });
  }

  signIn() async {    
    try {
      final myUser = await _auth.signInWithEmailAndPassword(email: emailController.text, password: passController.text)
      .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => Home())));
      print(myUser.user.email);  
    } catch (e) {
      print(e);
    }
    // print(_auth.currentUser());  
  }



  // Widget FormText(label, controller) {
  //   return TextField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       icon: Icon(Icons.email, color: Color.fromRGBO(243,182,58, 1)),
  //       hintText: label,
  //       labelText: label,
  //       labelStyle: TextStyle(color: Color.fromRGBO(243,182,58, 1),),
  //       filled: true,
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Color.fromRGBO(243,182,58, 1),),
  //         borderRadius: BorderRadius.all(Radius.circular(15))
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(15))
  //       )
  //     )
  //   );  
  // }



  // Widget FormText(label, controller) {
  //   return TextField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       icon: Icon(Icons.email, color: Color.fromRGBO(243,182,58, 1)),
  //       hintText: label,
  //       labelText: label,
  //       labelStyle: TextStyle(color: Color.fromRGBO(243,182,58, 1),),
  //       filled: true,
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Color.fromRGBO(243,182,58, 1),),
  //         borderRadius: BorderRadius.all(Radius.circular(15))
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(15))
  //       )
  //     )
  //   );  
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color:  Color.fromRGBO(230,105,110, 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Sign Up',
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
                      warningText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                SizedBox(height: 10),
                  TextField(
                    controller: userController,
                    maxLength: 10,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Color.fromRGBO(255, 255, 255, 0.8)),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white),
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
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Color.fromRGBO(255, 255, 255, 0.8)),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
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
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.enhanced_encryption, color: Color.fromRGBO(255, 255, 255, 0.8)),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,),
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      )
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // TextField(
                  //   controller: pass2Controller,
                  //   decoration: InputDecoration(
                  //     icon: Icon(Icons.enhanced_encryption, color: Color.fromRGBO(255, 255, 255, 0.8)),
                  //     labelText: 'Repeat Password',
                  //     labelStyle: TextStyle(color: Colors.white),
                  //     filled: true,
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.white,),
                  //       borderRadius: BorderRadius.all(Radius.circular(15))
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(15))
                  //     )
                  //   ),
                  //   obscureText: true,
                  //   style: TextStyle(color: Colors.white),
                  // ),
                  SizedBox(height: 20,),
                  MaterialButton(
                    onPressed: enable ? () {checkInput();} : null,
                    // elevation: 0,
                    child: enable ? Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 25
                      ),
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
                  SizedBox(height: 40,),
                  MaterialButton(
                    onPressed: enable ? () {Navigator.pop(context);} : null,
                    // elevation: 0,
                    child: Text(
                      'Already have an account',
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
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}