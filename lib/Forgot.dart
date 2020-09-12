import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController emailController = TextEditingController();
  bool enable = true, warn = false, confirm = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  resetRequest() async {
    setState(() {
      enable = false;
    });
    if (emailController.text == '') {
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text)
      .then((value) {
        setState(() {
          warn = false;
          confirm = true;
          enable = true;
        });
        print('Done');
        // confirmation();
        // print('Done2');
      });      
    } catch (e) {
      setState(() {
        warn = true;
        confirm = false;
        enable = true;
      });
    }
    // confirmation(context);
  }


  confirmation(BuildContext context) {
    final snack = SnackBar(
      content: Text(
        '🔐\nPassword reset link will be sent to your registered email id.',
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Color.fromRGBO(43,43,82, 1),
      duration: Duration(seconds: 20),
      behavior: SnackBarBehavior.floating,      
    );
    Scaffold.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(),
      body: Builder(
        builder: (context) =>  SafeArea(
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
                      'Forgot password?',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.audiowide(
                        fontSize: 40,
                        color: Colors.white
                      )
                    ),
                  ),
                  Visibility(
                    visible: warn,
                    child: Text(
                      'Email id not registered.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.alternate_email, color: Color.fromRGBO(255, 255, 255, 0.5)),
                      labelText: 'Your registered email id',
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
                  SizedBox(height: 20,),
                  MaterialButton(
                    onPressed: enable ? () {
                      resetRequest().then((v) {
                        if (confirm) {
                          confirmation(context);
                          print('done');
                        }
                      });
                    } : null,
                    child: enable ? 
                    Text(
                      'Request password reset',
                      style: TextStyle(
                        fontSize: 20
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
                  SizedBox(height: 40,),
                  
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}