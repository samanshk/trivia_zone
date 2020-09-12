import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charcode/html_entity.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/ResultPage.dart';

class QuizPage extends StatefulWidget {
  var mode;
  QuizPage(this.mode);
  @override
  _QuizPageState createState() => _QuizPageState(mode);
}

class _QuizPageState extends State<QuizPage> {
  var mode;
  _QuizPageState(this.mode);

  var questions;
  bool clicked = false;
  var optionOrder = [];
  Timer timer;
  var timeLeft = 10; 
  int _currentPage = 0;
  var score = 0;
  bool correct = false;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  getQuestions() async {
    var n = mode == 'Quick'? 10 : 25;
    var response = await http.get('https://opentdb.com/api.php?amount=$n');
    var data = json.decode(response.body);

    setState(() {
      questions = data['results'];
    });
    optionOrderGenerator();
    print(questions);
  }

  optionOrderGenerator() {
    for (var i = 0; i < questions.length; i++) {
      var arr = [];
      var n = questions[i]['type'] == 'multiple' ? [0, 1, 2, 3] : [0, 1];
      var l = questions[i]['type'] == 'multiple' ? 4 : 2;
      for(int j = 0; j < l; j++) {
        int k = Random().nextInt(n.length);
        arr.add(n[k]);
        n.removeAt(k);
      }
      setState(() {
        optionOrder.add(arr);
      });
    }
    print(optionOrder);
  }

  optionColor(List<bool> correctness, int i) {
    if(correctness[i]) {
      return Colors.green[600];
      // return Color.fromRGBO(46, 204, 114, 1);
    }
    else if (!correctness[i]) {
      return Colors.red[600];
    }
    else
      return Colors.white;
  }

  questionSwitch() {
    if (_currentPage < questions.length - 1) {  
      setState(() {
        _currentPage++;
        clicked = false;
        timeLeft = 10;
      });

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    }

    else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(score)));
    }
    // print(_currentPage);
  }

  timeController() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) { 
      if (_currentPage == questions.length - 1 && timeLeft == 0) {
        timer.cancel();
      }
      else {  
        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } 
        // else {
        //   questionSwitch();
        // }

      }
    });
  }

  Widget scoreBar() {
    double totalWidth = MediaQuery.of(context).size.width;
    double singleWidth = totalWidth/(questions.length);
    print(totalWidth);
    print(singleWidth);

    Color colorGiver(int i) {
      if (i == _currentPage) 
        return Colors.grey;
      else if (i < _currentPage)
        return Colors.greenAccent; 
      else 
        return Colors.white;
    }
    
    return Container(
      // color: Colors.red,
      height: 10,
      width: totalWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // scrollDirection: ScrollDirection.,
        itemCount: questions.length,
        itemBuilder: (context, i) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: colorGiver(i)          
            ),
            height: 10, 
            width: singleWidth, 
          );
        }
      ),
    );
  }

  Widget emoji() {
    return Center(
      child: AnimatedContainer(
        height: clicked ? 200 : 0,
        width: clicked ? 200 : 0,
        duration: Duration(milliseconds: 1100),
        curve: Curves.fastLinearToSlowEaseIn,
        child: Text(
          correct ? '😄' : '😞',
          style: TextStyle(
            fontSize: 100
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget answers(int inx) {
    // var clicked = false;
    List<String> answers = [questions[inx]['correct_answer'], ...questions[inx]['incorrect_answers']];
    int n = answers.length;
    List<String> orderedAnswers = [];
    List<bool> correctness = [];
    
    // for (var x = 0; x < n; x++) {
    //   int index = Random().nextInt(answers.length);
    //   orderedAnswers.add(answers[index]);
    //   if (answers[index] == questions[inx]['correct_answer']) {
    //     correctness.add(true);
    //   } else {
    //     correctness.add(false);
    //   }
    //   answers.removeAt(index);
    // }
    for (var x = 0; x < n; x++) {
      // int index = Random().nextInt(answers.length);
      orderedAnswers.add(answers[optionOrder[inx][x]]);
      if (answers[optionOrder[inx][x]] == questions[inx]['correct_answer']) {
        correctness.add(true);
      } else {
        correctness.add(false);
      }
      // answers.removeAt(optionOrder[inx][x]);
    }     
    print(orderedAnswers);
    print(correctness);
    // answerList(inx);

    return Expanded(
      child: ListView.builder(
        itemCount: orderedAnswers.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: MaterialButton(
              child: Text(
                HtmlCharacterEntities.decode(orderedAnswers[i]),
                style: TextStyle(
                  fontSize: 20,
                  color: clicked ? Colors.white : Colors.black
                ),
                textAlign: TextAlign.center
              ),
              onPressed: () {
                if (!clicked && timeLeft > 0) {
                  setState(() {
                    clicked = true;
                    if (orderedAnswers[i] == questions[inx]['correct_answer']) {
                      score += 10;
                      correct = true;
                    }
                    else {
                      correct = false;
                    }                  
                  });
                }  
                print(score);          
              },
              elevation: 0,
              padding: EdgeInsets.only(top:15, bottom: 15, left: 10, right: 10),
              color: clicked ? optionColor(correctness, i) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(width: 2, color: Color.fromRGBO(243,182,58, 1))
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  void initState() {
    getQuestions().then((v) {
      timeController();
    });
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: SafeArea(
        child: questions == null ? 
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
          child: Column(
            children: <Widget>[
              scoreBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, i) {
                    return Stack(
                      children: <Widget>[
                        Card(
                          // color: Color.fromRGBO(64,75,250, 1),
                          color:  Color.fromRGBO(50, 50, 100, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(width: 7, color: Color.fromRGBO(243,182,58, 1))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                HtmlCharacterEntities.decode(questions[i]['question']),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.audiowide(
                                    fontSize: 25,
                                    color: Colors.white
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(10)),
                                answers(i),
                                Padding(padding: EdgeInsets.all(10)),
                              ],
                            ),
                          )
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(width: 4, color: Color.fromRGBO(243,182,58, 1),)
                                ),
                                child: CircleAvatar(
                                  // backgroundColor: Color.fromRGBO(64,75,250, 1),
                                  backgroundColor: Colors.black, 
                                  radius: 30,
                                  child: clicked || timeLeft == 0 ? 
                                  GestureDetector(
                                    onTap: questionSwitch,
                                    child: Text(
                                      '>',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.audiowide(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color.fromRGBO(243,182,58, 1),                                  
                                      ),
                                    ),
                                  ) : 
                                  Text(
                                    '$timeLeft',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.graduate(
                                      fontSize: 33,
                                      fontWeight: FontWeight.w100,
                                      // color: Color.fromRGBO(243,182,58, 1), 
                                      color: Colors.white,                                  
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        emoji()
                      ],
                    );
                  }
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Column(
                children: <Widget>[
                  Text(
                    'SCORE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  Text(
                    '$score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}