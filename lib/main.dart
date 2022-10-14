import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'quizWidget/variables.dart';
import 'quizWidget/winner.dart';

void main() {
  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  String question = "";
  late List apiData;
  late String correctAnswer;

  @override
  void initState() {
    getDAta();
    super.initState();
  }

// getting function
  void getDAta() async {
    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.get(Uri.parse(urx));

      final List<dynamic> fullList = json.decode(res.body);
      final firstIndex = fullList[0]["question"];
      apiData = fullList;

      debugPrint(firstIndex.toString());
      setState(() {
        question = firstIndex.toString();
        correctAnswer = apiData[0]["correctAnswer"];
        apiData = [
          apiData[0]["correctAnswer"],
          apiData[0]["incorrectAnswers"][0],
          apiData[0]["incorrectAnswers"][1],
          apiData[0]["incorrectAnswers"][2]
        ];
        apiData.shuffle();
        debugPrint(apiData.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  //push function
  void pushPage() {
    setState(() {
      qCount += 1;
    });
    getDAta();
    debugPrint('pressed');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => MyHomePage(
                  question: question,
                  correctAns: correctAnswer,
                  options: apiData,
                  pushPage: pushPage,
                )),
        (e) => false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme:
              GoogleFonts.bebasNeueTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
        ),
        // home: WinnerPage(
        //   pushPagef: pushPage,
        // ),
        home: question == ''
            ? LoadingPage()
            : qCount >= 11
                ? WinnerPage(
                    pushPagef: pushPage,
                  )
                : MyHomePage(
                    question: question,
                    options: apiData,
                    correctAns: correctAnswer,
                    pushPage: pushPage,
                  )
        //
        );
  }
}

//#############################################################################

class MyHomePage extends StatefulWidget {
  final String question;
  final List options;
  final String correctAns;
  final VoidCallback pushPage;

  const MyHomePage({
    super.key,
    required this.question,
    required this.options,
    required this.correctAns,
    required this.pushPage,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List click = [Colors.cyan, Colors.cyan, Colors.cyan, Colors.cyan];
  bool illigal = false;
  void resetCI() {
    click = [Colors.cyan, Colors.cyan, Colors.cyan, Colors.cyan];
    illigal = false;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(169, 255, 121, 68),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('question count'),
                  Text(
                    "$qCount/10",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(108, 68, 137, 255),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Your Score'),
                  Text(
                    "$score",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ],
              ))
        ],
      ),
      body: Center(
          child: Container(
              height: height / 2,
              width: width / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 30,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    child: Text(
                      widget.question,
                      style: const TextStyle(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  //
                  // INKWELL 1st
                  InkWell(
                    onTap: () {
                      if (illigal == false) {
                        widget.options[0] == widget.correctAns
                            ? score += 1
                            : score += 0;
                        setState(() {
                          illigal = true;
                          click[0] = Colors.red;
                          var x = widget.options.indexOf(widget.correctAns);
                          debugPrint(x.toString());
                          click[x] = Colors.green;
                        });
                        setState(() async {
                          await Future.delayed(Duration(seconds: 1));
                          resetCI();
                          widget.pushPage();
                        });
                      }
                    },
                    child: Container(
                      width: width,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: click[0],
                      ),
                      child: Center(
                        child: Text(widget.options[0],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (illigal == false) {
                        widget.options[1] == widget.correctAns
                            ? score += 1
                            : score += 0;
                        setState(() {
                          illigal = true;
                          click[1] = Colors.red;
                          var x = widget.options.indexOf(widget.correctAns);
                          debugPrint(x.toString());
                          click[x] = Colors.green;
                        });
                        setState(() async {
                          await Future.delayed(Duration(seconds: 1));
                          resetCI();
                          widget.pushPage();
                        });
                      }
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: click[1],
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(widget.options[1],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (illigal == false) {
                        widget.options[2] == widget.correctAns
                            ? score += 1
                            : score += 0;
                        setState(() {
                          illigal = true;
                          click[2] = Colors.red;
                          var x = widget.options.indexOf(widget.correctAns);
                          debugPrint(x.toString());
                          click[x] = Colors.green;
                        });
                        setState(() async {
                          await Future.delayed(Duration(seconds: 1));
                          resetCI();
                          widget.pushPage();
                        });
                      }
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: click[2],
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(widget.options[2],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (illigal == false) {
                        widget.options[3] == widget.correctAns
                            ? score += 1
                            : score += 0;
                        setState(() {
                          illigal = true;
                          click[3] = Colors.red;
                          var x = widget.options.indexOf(widget.correctAns);
                          debugPrint(x.toString());
                          click[x] = Colors.green;
                        });
                        setState(() async {
                          await Future.delayed(Duration(seconds: 1));
                          resetCI();
                          widget.pushPage();
                        });
                      }
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: click[3],
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(widget.options[3],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  const Spacer()
                ],
              ))),
    );
  }
}
