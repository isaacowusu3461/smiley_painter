// In-Class Activity 06 — Drawing with Flutter
// Student: Isaac Owusu
// Date: September 30, 2026


import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const SmileyApp());
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;

  int selectedFace = 0;

  String get faceName {
    if (selectedFace == 0) {
      return 'Classic';
    } else if (selectedFace == 1) {
      return 'Sleepy';
    } else {
      return 'Surprised';
    }
  }

  void cycleFace() {
    setState(() {
      selectedFace = (selectedFace + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(320, 320),
                painter: SmileyPainter(
                  mood: mood,
                  faceType: selectedFace,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Face: $faceName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Mood: ${mood.toStringAsFixed(2)}',
                ),

                Slider(
                  value: mood,
                  onChanged: (double value) {
                    setState(() {
                      mood = value;
                    });
                  },
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: cycleFace,
                  child: const Text('Next Face'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceType,
  });

  final double mood;
  final int faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.40;

    // Change face color based on mood.
    Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue.shade300;
    } else if (mood <= 0.7) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange.shade400;
    }

    // Face.
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // Border.
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    if (faceType == 0) {
      _drawClassicFace(
        canvas,
        center,
        radius,
      );
    } else if (faceType == 1) {
      _drawSleepyFace(
        canvas,
        center,
        radius,
      );
    } else {
      _drawSurprisedFace(
        canvas,
        center,
        radius,
      );
    }
  }

  void _drawClassicFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * 0.35;
    final eyeRadius = radius * 0.09;

    canvas.drawCircle(
      Offset(center.dx - eyeDx, eyeY),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(center.dx + eyeDx, eyeY),
      eyeRadius,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.15,
      ),
      width: radius,
      height: radius * (0.4 + mood * 0.5),
    );

    if (mood >= 0.35) {
      canvas.drawArc(
        mouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    } else {
      final frownRect = mouthRect.translate(
        0,
        radius * 0.25,
      );

      canvas.drawArc(
        frownRect,
        1.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    }
  }

  void _drawSleepyFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.15;
    final eyeDx = radius * 0.35;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          center.dx - eyeDx,
          eyeY,
        ),
        width: radius * 0.30,
        height: radius * 0.15,
      ),
      0,
      pi,
      false,
      eyePaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          center.dx + eyeDx,
          eyeY,
        ),
        width: radius * 0.30,
        height: radius * 0.15,
      ),
      0,
      pi,
      false,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.18,
      ),
      width: radius * 0.70,
      height: radius * 0.35,
    );

    canvas.drawArc(
      mouthRect,
      0.15 * pi,
      0.70 * pi,
      false,
      mouthPaint,
    );
  }

  void _drawSurprisedFace(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * 0.35;

    canvas.drawCircle(
      Offset(center.dx - eyeDx, eyeY),
      radius * 0.13,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(center.dx + eyeDx, eyeY),
      radius * 0.13,
      eyePaint,
    );

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.22,
        ),
        width: radius * 0.38,
        height: radius * 0.50,
      ),
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}