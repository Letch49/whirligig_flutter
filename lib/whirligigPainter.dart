import 'package:flutter/material.dart';
import 'package:arrow_path/arrow_path.dart';

import 'dart:math';

import 'game.dart';

class WhirligigPainter extends CustomPainter {
  var linePaint = Paint()
    ..color = Colors.yellowAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;

  var characterPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;

  var whirligigPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6.0
    ..isAntiAlias = true;

  var whirligigTopPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  double whirligigAngle;
  List<Question> questions;

  WhirligigPainter(double whirligigAngle,  List<Question> questions) {
    this.whirligigAngle = whirligigAngle;
    this.questions = questions;
  }

  void drawText(Canvas canvas, String text, Offset position, double angleRotation, double radius, int elements) {
    const double FONT_SIZE_MULTIPLIER = 0.17;
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: characterPaint.color,
            fontSize: 2 * pi * radius / elements * FONT_SIZE_MULTIPLIER,
            fontFamily: 'Roboto'
        ),
        text: text
    );
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr
    );

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angleRotation);
    tp.layout(maxWidth: 80);
    tp.paint(canvas, new Offset(-(tp.width / 2), -(tp.height / 2)));
    canvas.restore();
  }

  void drawArrow(Canvas canvas, Offset position, double angleRotation, double radius, int elements) {
    const double ARROW_SIZE_MULTIPLIER = 0.3;
    Path path = Path();
    path.moveTo(- pi * radius / elements * ARROW_SIZE_MULTIPLIER, 0);
    path.relativeCubicTo(0, 0, 0, 0, 2.0 * pi * radius / elements * ARROW_SIZE_MULTIPLIER, 0);
    path = ArrowPath.make(path: path);

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angleRotation);
    canvas.drawPath(path, linePaint);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    double radius = min(size.width, size.height) * 0.95 / 2.0;

    canvas.drawCircle(Offset(centerX, centerY), radius, linePaint);

    double sectorAngle = 2.0 * pi / this.questions.length.toDouble();
    double angle = 0.0;
    for (int i = this.questions.length - 1; i >= 0; i--, angle += sectorAngle) {
      canvas.drawLine(
          Offset(centerX, centerY),
          Offset(centerX + radius * sin(angle), centerY + radius * cos(angle)),
          linePaint
      );
    }

    angle = sectorAngle / 2.0;
    for (int i = this.questions.length - 1; i >= 0; i--, angle += sectorAngle) {
      Question question = this.questions[i];
      if (question.isActive) {
        this.drawText(
            canvas,
            question.name,
            Offset(centerX + radius * 0.85 * sin(angle), centerY + radius * 0.85 * cos(angle)),
            pi - angle,
            radius,
            this.questions.length
        );
      } else {
        this.drawArrow(
            canvas,
            Offset(centerX + radius * 0.85 * sin(angle), centerY + radius * 0.85 * cos(angle)),
            pi - angle,
            radius,
            this.questions.length
        );
      }
    }

    canvas.drawLine(
        Offset(centerX - radius * sin(whirligigAngle) * 0.2, centerY - radius * cos(whirligigAngle) * 0.2),
        Offset(centerX + radius * sin(whirligigAngle) * 0.8, centerY + radius * cos(whirligigAngle) * 0.8),
        whirligigPaint
    );

    canvas.drawCircle(Offset(centerX, centerY), radius * 0.1, whirligigTopPaint);
  }

  @override
  bool shouldRepaint(WhirligigPainter oldDelegate) {
    return oldDelegate.whirligigAngle != whirligigAngle;
  }

}