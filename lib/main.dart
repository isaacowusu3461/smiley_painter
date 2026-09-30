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

  bool showHat = false;
  bool showGlasses = false;

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

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Changed face to $faceName',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  void randomizeFace() {
    setState(() {
      selectedFace = Random().nextInt(3);
      mood = Random().nextDouble();
    });

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Randomized to $faceName with mood '
            '${mood.toStringAsFixed(2)}',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CustomPainter Smiley Lab',
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: cycleFace,
              onLongPress: randomizeFace,
              child: Center(
                child: CustomPaint(
                  size: const Size(320, 320),
                  painter: SmileyPainter(
                    mood: mood,
                    faceType: selectedFace,
                    showHat: showHat,
                    showGlasses: showGlasses,
                  ),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Toggle hat',
                      icon: Icon(
                        showHat
                            ? Icons.checkroom
                            : Icons.checkroom_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          showHat = !showHat;
                        });
                      },
                    ),

                    IconButton(
                      tooltip: 'Toggle glasses',
                      icon: Icon(
                        showGlasses
                            ? Icons.visibility
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          showGlasses = !showGlasses;
                        });
                      },
                    ),

                    const SizedBox(width: 8),

                    ElevatedButton(
                      onPressed: cycleFace,
                      child: const Text(
                        'Next Face',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                const Text(
                  'Tap the face to change it • '
                  'Long press to randomize',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
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
    required this.showHat,
    required this.showGlasses,
  });

  final double mood;
  final int faceType;
  final bool showHat;
  final bool showGlasses;

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

    // Draw the selected face.
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

    // Accessories are drawn last.
    if (showGlasses) {
      _drawGlasses(
        canvas,
        center,
        radius,
      );
    }

    if (showHat) {
      _drawHat(
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

    // Eyes.
    canvas.drawCircle(
      Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + eyeDx,
        eyeY,
      ),
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

    // Left closed eye.
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

    // Right closed eye.
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

    // Soft smile.
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

    // Bigger eyes.
    canvas.drawCircle(
      Offset(
        center.dx - eyeDx,
        eyeY,
      ),
      radius * 0.13,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + eyeDx,
        eyeY,
      ),
      radius * 0.13,
      eyePaint,
    );

    // Open mouth.
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

  void _drawGlasses(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final glassesPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * 0.35;

    final lensWidth = radius * 0.38;
    final lensHeight = radius * 0.27;

    // Left lens.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx - eyeDx,
          eyeY,
        ),
        width: lensWidth,
        height: lensHeight,
      ),
      glassesPaint,
    );

    // Right lens.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(
          center.dx + eyeDx,
          eyeY,
        ),
        width: lensWidth,
        height: lensHeight,
      ),
      glassesPaint,
    );

    // Bridge.
    canvas.drawLine(
      Offset(
        center.dx - radius * 0.08,
        eyeY,
      ),
      Offset(
        center.dx + radius * 0.08,
        eyeY,
      ),
      glassesPaint,
    );
  }

  void _drawHat(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final hatPaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    // Hat brim.
    final hatBrim = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy - radius * 0.92,
      ),
      width: radius * 1.20,
      height: radius * 0.18,
    );

    canvas.drawOval(
      hatBrim,
      hatPaint,
    );

    // Hat body.
    final hatBody = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy - radius * 1.02,
        ),
        width: radius * 0.75,
        height: radius * 0.55,
      ),
      const Radius.circular(10),
    );

    canvas.drawRRect(
      hatBody,
      hatPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType ||
        oldDelegate.showHat != showHat ||
        oldDelegate.showGlasses != showGlasses;
  }
}