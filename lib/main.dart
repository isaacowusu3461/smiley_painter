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
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
  });

  final double mood;

  @override
  void paint(Canvas canvas, Size size) {
    // Center the face based on the available canvas size.
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    // Use the shortest side so the face remains responsive.
    final radius = size.shortestSide * 0.40;

    // Face.
    final facePaint = Paint()
      ..color = Colors.yellow.shade600
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // Face border.
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    // Eyes.
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

    // Mouth.
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
      width: radius * 1.0,
      height: radius * (0.4 + mood * 0.5),
    );

    if (mood >= 0.5) {
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

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood;
  }
}
