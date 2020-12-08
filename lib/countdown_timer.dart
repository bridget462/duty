import 'dart:math' as math;
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pomodoro_timer/main.dart';

class CountDownTimer extends StatefulWidget {
  final Duration initialCountDownDuration;

  final Color remainingCircleIndicatorColor;
  final Color remainingCircleBackgroundColor;
  final bool isFocusMode;
  final bool autoStart;

  CountDownTimer({
    @required this.isFocusMode,
    @required this.initialCountDownDuration,
    @required this.remainingCircleIndicatorColor,
    @required this.remainingCircleBackgroundColor,
    this.autoStart = true,
  });

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  Duration countdownDuration;
  Duration remainingTimeInDuration;
  final player = AudioCache();
  // TODO make it selectable
  String ringtone = 'woodblock.mp3';

  String get timerString {
    updateRemainingTimeInDuration();
    return '${remainingTimeInDuration.inMinutes}:${(remainingTimeInDuration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void updateRemainingTimeInDuration() {
    remainingTimeInDuration = controller.duration * controller.value;
  }

  @override
  void initState() {
    super.initState();
    countdownDuration = widget.initialCountDownDuration;
    remainingTimeInDuration = countdownDuration;
    controller = AnimationController(
      vsync: this,
      duration: countdownDuration,
    );
    controller.value = 1.0;
    // to print controller value to the console
    controller.addListener(() {
      // print(controller.value);
      updateRemainingTimeInDuration();
      if (controller.value == 0.0) {
        player.play(ringtone);
        // _showPopUp();
      }
    });

    if (widget.autoStart) {
      controller.reverse();
    }
  }

  Future<void> _showPopUp() async {
    if (widget.isFocusMode) {
      showBreakAlert(context);
    } else {
      showLetsWorkAlert(context);
    }
  }

  void reset() {
    print('reset function called');
    // TODO reset extended time
    countdownDuration = widget.initialCountDownDuration;
    remainingTimeInDuration = countdownDuration;

    controller = AnimationController(
      vsync: this,
      duration: countdownDuration,
    );

    controller.value = 1.0;

    controller.addListener(() {
      updateRemainingTimeInDuration();
      if (controller.value == 0.0) {
        player.play(ringtone);
        // _showPopUp();
      }
    });
    setState(() {});
  }

  void play() {
    print('play function called.');
    controller.reverse();
    setState(() {});
  }

  void pause() {
    print('pause function called');
    controller.stop();
    setState(() {});
  }

  void addOneMin() {
    print('addOneMin function called');
    // update remaining time
    remainingTimeInDuration += Duration(minutes: 1);
    countdownDuration += Duration(minutes: 1);

    controller = AnimationController(
      vsync: this,
      duration: countdownDuration,
    );
    print('${remainingTimeInDuration.inMilliseconds}');
    controller.value = remainingTimeInDuration.inMilliseconds /
        countdownDuration.inMilliseconds;

    if (controller.value != 1.0) {
      // continue playing countdown
      play();
    }

    controller.addListener(() {
      updateRemainingTimeInDuration();
      if (controller.value == 0.0) {
        player.play(ringtone);
        // _showPopUp();
      }
    });
    setState(() {});
  }

  void switchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        if (widget.isFocusMode) {
          return BreakTimer();
        } else {
          return FocusTimer();
        }
      }),
    );
  }

  void showBreakAlert(BuildContext context) {
    player.play(ringtone);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            title: Text('Take a break ?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Later',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return BreakTimer();
                    }),
                  );
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  void showLetsWorkAlert(BuildContext context) {
    player.play(ringtone);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            title: Text('Let\'s Get Things Done !'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Later',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FocusTimer();
                    }),
                  );
                },
                child: Text('Yeah!'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      switchScreen(context);
                    },
                    icon: widget.isFocusMode
                        ? Icon(
                            Icons.free_breakfast,
                            color: Colors.white70,
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.white70,
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(80.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor:
                                        widget.remainingCircleBackgroundColor,
                                    color: widget.remainingCircleIndicatorColor,
                                  )),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      top: 145,
                                      child: Text(
                                        timerString,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          // add one minute button
                                          IconButton(
                                            onPressed: addOneMin,
                                            icon: Icon(Icons.add),
                                          ),
                                          // play / pause button
                                          AnimatedBuilder(
                                            animation: controller,
                                            builder: (context, child) {
                                              if (controller.value == 0) {
                                                // when timer is finished, disable play/bause button
                                                // TODO show like icon here
                                                return IconButton(
                                                  onPressed: () {
                                                    switchScreen(context);
                                                  },
                                                  icon: widget.isFocusMode
                                                      ? Icon(
                                                          Icons.free_breakfast)
                                                      : Icon(Icons.check),
                                                  iconSize: 40.0,
                                                );
                                              } else {
                                                if (controller.isAnimating ==
                                                    true) {
                                                  return IconButton(
                                                    onPressed: pause,
                                                    icon: Icon(Icons.pause),
                                                    iconSize: 40.0,
                                                  );
                                                } else {
                                                  return IconButton(
                                                    onPressed: play,
                                                    icon:
                                                        Icon(Icons.play_arrow),
                                                    iconSize: 40.0,
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                          // reset button
                                          AnimatedBuilder(
                                            animation: controller,
                                            builder: (context, child) {
                                              return IconButton(
                                                onPressed:
                                                    controller.value != 1.0
                                                        ? reset
                                                        : null,
                                                icon: Icon(Icons.replay),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // RaisedButton(
                      //   onPressed: () {
                      //     print('debug botton pressed.');
                      //     print(timerString);
                      //     player.play(ringtone);

                      //     // if (widget.isFocusMode) {
                      //     //   showBreakAlert(context);
                      //     // } else {
                      //     //   // go back to focus screen
                      //     //   showLetsWorkAlert(context);
                      //     // }
                      //   },
                      //   child: Text('Debug Button'),
                      // ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 48.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
