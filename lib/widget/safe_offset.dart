import 'package:flutter/material.dart';

class SafeOffsetWidget extends StatelessWidget {
  final double x;
  final double y;

  SafeOffsetWidget({required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    // Ensure x and y are not NaN
    final safeX = x.isNaN ? 0.0 : x;
    final safeY = y.isNaN ? 0.0 : y;

    return CustomPaint(
      painter: SafeOffsetPainter(safeX, safeY),
    );
  }
}

class SafeOffsetPainter extends CustomPainter {
  final double x;
  final double y;

  SafeOffsetPainter(this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0;

    // Ensure x and y are not NaN
    final safeX = x.isNaN ? 0.0 : x;
    final safeY = y.isNaN ? 0.0 : y;

    canvas.drawCircle(Offset(safeX, safeY), 10.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}