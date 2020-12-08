import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'countdown_timer.dart';
import 'package:screen/screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Home page'),
          onPressed: () {
            // TODO move to Home page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [FocusTimer(), BreakTimer()],
    );
  }
}

class FocusTimer extends StatelessWidget {
  FocusTimer();
  @override
  Widget build(BuildContext context) {
    return CountDownTimer(
      isFocusMode: true,
      initialCountDownDuration: Duration(minutes: 25),
      remainingCircleBackgroundColor: Color(0xFFF79D43),
      remainingCircleIndicatorColor: Colors.grey[800],
    );
  }
}

class BreakTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CountDownTimer(
      isFocusMode: false,
      initialCountDownDuration: Duration(minutes: 5),
      remainingCircleBackgroundColor: Color(0xFF6A96E4),
      remainingCircleIndicatorColor: Colors.grey[800],
    );
  }
}
