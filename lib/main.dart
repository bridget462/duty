import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'countdown_timer.dart';
import 'package:screen/screen.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

const Color focusColor = Color(0xFFF79D43);
const Color breakColor = Color(0xFF6A96E4);

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
          accentColor: focusColor,
        ),
        home: SettingPage());
  }
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int focusDurationInMin = 25;
  int focusDurationInSec = 00;
  int breakDurationInMin = 5;
  int breakDurationInSec = 00;

  final breakDuration = Duration(seconds: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // for focus mode
                Column(
                  children: [
                    Row(
                      children: [
                        NumberPicker.integer(
                          initialValue: focusDurationInMin,
                          minValue: 0,
                          maxValue: 240,
                          onChanged: (num) => setState(() {
                            focusDurationInMin = num;
                          }),
                        ),
                        Text(
                          ':',
                          style: TextStyle(fontSize: 24, color: focusColor),
                        ),
                        NumberPicker.integer(
                          initialValue: focusDurationInSec,
                          minValue: 0,
                          maxValue: 60,
                          onChanged: (num) => setState(() {
                            focusDurationInSec = num;
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'focus time',
                    ),
                  ],
                ),
                // Divider
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 14),
                  width: 2.5,
                  height: 135,
                  color: Colors.white24,
                ),
                // for break mode
                Column(
                  children: [
                    Row(
                      children: [
                        NumberPicker.integer(
                          selectedTextStyle:
                              TextStyle(fontSize: 24, color: breakColor),
                          initialValue: breakDurationInMin,
                          minValue: 0,
                          maxValue: 240,
                          onChanged: (num) => setState(() {
                            breakDurationInMin = num;
                          }),
                        ),
                        Text(
                          ':',
                          style: TextStyle(fontSize: 24, color: breakColor),
                        ),
                        NumberPicker.integer(
                          selectedTextStyle:
                              TextStyle(fontSize: 24, color: breakColor),
                          initialValue: breakDurationInSec,
                          minValue: 0,
                          maxValue: 60,
                          onChanged: (num) => setState(() {
                            breakDurationInSec = num;
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'break time',
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: TextButton(
                child: Text(
                  'START',
                  style: TextStyle(color: focusColor),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        focusDuration: Duration(
                          minutes: focusDurationInMin,
                          seconds: focusDurationInSec,
                        ),
                        breakDuration: Duration(
                          minutes: breakDurationInMin,
                          seconds: breakDurationInSec,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
      remainingCircleBackgroundColor: focusColor,
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
      remainingCircleBackgroundColor: breakColor,
      remainingCircleIndicatorColor: Colors.grey[800],
    );
  }
}
