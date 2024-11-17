import 'package:flutter/material.dart';
import 'dart:math' as math;

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define starting and ending points
    Offset startPointTop = Offset(0, 0);
    Offset endPointTop = Offset(size.width, 0);
    Offset controlPointTop = Offset(size.width / 2, 80);

    Offset startPointBottom = Offset(size.width, size.height);
    Offset endPointBottom = Offset(0, size.height);
    // Offset controlPointBottom = Offset(size.width / 2, size.height - 80);

    Paint gradientPaintBottom = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [Colors.green, Colors.blue],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint gradientPaintBottom1 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [Colors.blue, Colors.green],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Define gradients

    Paint gradientPaintTop = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blue, Colors.green],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));


    // Draw pattern at the top
    Path topPatternPath = Path()
      ..moveTo(startPointTop.dx, startPointTop.dy)
      ..lineTo(endPointTop.dx, endPointTop.dy)
      ..quadraticBezierTo(controlPointTop.dx, controlPointTop.dy, startPointTop.dx, startPointTop.dy + 80)
      ..close();

    canvas.drawPath(topPatternPath, gradientPaintTop);



    //Draw pattern at the bottom
    Path bottomPatternPath = Path()
      ..moveTo(startPointBottom.dx, startPointBottom.dy)
      ..lineTo(endPointBottom.dx, endPointBottom.dy);
    for (double x = 0; x <= size.width; x += 10) {
      double y = 40 * math.sin(x / size.width * 2 * math.pi);
      bottomPatternPath.lineTo(x, size.height - y - size.height / 8);
    }
    bottomPatternPath.lineTo(size.width, size.height / 2);
    bottomPatternPath.close();

    canvas.drawPath(bottomPatternPath, gradientPaintBottom);


    // Draw pattern at the bottom
    Path bottomPatternPath1 = Path()
      ..moveTo(startPointBottom.dx, startPointBottom.dy)
      ..lineTo(endPointBottom.dx, endPointBottom.dy);
    for (double x = 0; x <= size.width; x += 10) {
      double y = 20 * math.sin(x / size.width * 2 * math.pi);
      bottomPatternPath1.lineTo(x, size.height - y - size.height / 18);
    }
    bottomPatternPath1.lineTo(size.width, size.height / 2);
    bottomPatternPath1.close();

    canvas.drawPath(bottomPatternPath1, gradientPaintBottom1);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}