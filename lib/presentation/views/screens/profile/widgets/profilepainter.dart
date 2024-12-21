import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.pink; 

    canvas.drawArc(
      Rect.fromLTWH(
        -30, 
        -size.height,
        size.width + 60, 
        size.height * 2, 
      ),
      0, 
      math.pi, 
      false, 
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
