import 'package:chat_app/quizWidget/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

//##############################################################################
class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
class WinnerPage extends StatefulWidget {
  final VoidCallback pushPagef;
  const WinnerPage({super.key, required this.pushPagef});

  @override
  State<WinnerPage> createState() => _WinnerPageState();
}

class _WinnerPageState extends State<WinnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'your score is',
                style: TextStyle(fontSize: 45),
              ),
              Text(
                '$score',
                style: TextStyle(fontSize: 250),
              ),
              Container(
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        qCount = 0;
                        score = 0;
                        Phoenix.rebirth(context);
                      });
                    },
                    icon: Icon(
                      Icons.replay_outlined,
                      color: Colors.orange,
                      size: 50,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
