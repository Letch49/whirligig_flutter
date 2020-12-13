import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chgk_wheel_flutter/whirligigPainter.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'bottomSheet.dart';
import 'dialogs.dart';
import 'game.dart';
import 'settings.dart';


void main() {
  runApp(WheelApp());
}

class WheelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whirligig',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: new WhirligigRoute(),
      )
    );
  }
}

class WhirligigRoute extends StatefulWidget {
  @override
  _WhirligigRouteState createState() => _WhirligigRouteState();
}

class _WhirligigRouteState extends State<WhirligigRoute>
    with SingleTickerProviderStateMixin {

  double whirligigAngle = randomizeStartAngle();
  double startSpeed = randomizeStartSpeed();
  double lastAnimationValue = 0.0;

  Animation<double> _animation;
  AnimationController controller;

  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer;

  static double randomizeStartAngle() {
    return new Random().nextDouble() * 2 * pi;
  }

  static double randomizeStartSpeed() {
    return START_SPEED + (new Random().nextDouble() - 0.5) * START_SPEED_RANDOMIZE_RANGE;
  }

  static double normalizeAngle(double angle) {
    return angle % (2 * pi);
  }

  static int calcArrowSectorPosition(int amountOfSectors, double angle) {
    return (amountOfSectors + 1) - ((angle) / (2.0 * pi / amountOfSectors)).ceil() % amountOfSectors;
  }

  @override
  void initState() {
    super.initState();
    audioCache.load('whirligig.mp3');
    controller = AnimationController(
        duration: Duration(seconds: ANIMATION_DURATION.floor()), vsync: this);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        whirligigAngle = normalizeAngle(whirligigAngle);
        int sectorPosition = calcArrowSectorPosition(GameHolder.instance.getQuestions().length, whirligigAngle);
        Question question = GameHolder.instance.getNextQuestion(sectorPosition);
        question.deactivate();

        audioPlayer.stop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return QuestionDialog(questionName: question.name, isCloseButtonDisabled: false);
            },
            barrierDismissible: false,
        );
        //controller.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('WhirligigRoute build, whirligigAngle: $whirligigAngle');
    _animation = Tween(begin: 0.0, end: ANIMATION_DURATION).animate(controller)
      ..addListener(() {
        setState(() {
          double currentSpeed = (1 - (_animation.value / ANIMATION_DURATION)) * startSpeed;
          whirligigAngle -= (_animation.value - lastAnimationValue) * currentSpeed;
          lastAnimationValue = _animation.value;
        });
      });

    return Center(
      child: new GestureDetector(
        onDoubleTap: () async {
          if (!controller.isAnimating) {
            audioPlayer = await audioCache.play('whirligig.mp3');
            lastAnimationValue = 0.0;
            startSpeed = randomizeStartSpeed();
            controller.reset();
            controller.forward();
          }
        },
        onScaleEnd: (ScaleEndDetails details) {
          showBottomSheet(
              context: context,
              builder: (context) => BottomSheetWidget()
          );
        },
        child: new CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: WhirligigPainter(whirligigAngle, GameHolder.instance.getQuestions()),
        ),
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}
