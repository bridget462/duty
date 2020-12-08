import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'countdown_timer.dart';
import 'package:screen/screen.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Screen.keepOn(true);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          accentColor: Colors.red,
        ),
        home: SettingPage());
  }
}

class SettingPage extends StatelessWidget {
  // TODO make this selectable
  int focusDurationInSec = 10;
  final breakDuration = Duration(seconds: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              child: Text('Go to Home page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            focusDuration:
                                Duration(seconds: focusDurationInSec),
                            breakDuration: breakDuration,
                          )),
                );
              },
            ),
          ),
          NumberPicker.integer(
              initialValue: 50,
              minValue: 0,
              maxValue: 100,
              onChanged: (num) {
                focusDurationInSec = num;
                print(focusDurationInSec);
              })
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  final focusDuration;
  final breakDuration;

  Home({@required this.focusDuration, @required this.breakDuration});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        FocusTimer(focusDuration: focusDuration),
        BreakTimer(breakDuration: breakDuration),
      ],
    );
  }
}

class FocusTimer extends StatelessWidget {
  final Duration focusDuration;
  FocusTimer({this.focusDuration});

  @override
  Widget build(BuildContext context) {
    return CountDownTimer(
      isFocusMode: true,
      initialCountDownDuration: focusDuration,
      remainingCircleBackgroundColor: Color(0xFFF79D43),
      remainingCircleIndicatorColor: Colors.grey[800],
    );
  }
}

class BreakTimer extends StatelessWidget {
  final Duration breakDuration;
  BreakTimer({this.breakDuration});

  @override
  Widget build(BuildContext context) {
    return CountDownTimer(
      isFocusMode: false,
      initialCountDownDuration: breakDuration,
      remainingCircleBackgroundColor: Color(0xFF6A96E4),
      remainingCircleIndicatorColor: Colors.grey[800],
    );
  }
}
