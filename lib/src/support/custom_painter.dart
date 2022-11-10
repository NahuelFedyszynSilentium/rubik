import 'package:flutter/material.dart';

class GraphPainter extends CustomPainter {
  final double barsWidth;
  final Color pathColor;
  final List<Color> barsColors;
  final List<double> barsHeight;
  final List<Path> pathsList = [];
  final List<Paint> paints = [];
  final Path trackPath = Path();
  late Paint trackPaint;
  double origin = 0;

  GraphPainter({
    this.pathColor = Colors.grey,
    this.barsWidth = 10,
    required this.barsColors,
    required this.barsHeight,
  }) {
    trackPaint = Paint()
      ..color = pathColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barsWidth;
    for (int i = 0; i < barsColors.length; i++) {
      paints.add(Paint()
        ..color = barsColors[i]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barsWidth);
    }
    barsColors.forEach((element) {
      pathsList.add(Path());
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    double origin = 0;

    trackPath.moveTo(origin, size.height);
    trackPath.lineTo(origin, 0);

    for (int i = 0; i < barsColors.length; i++) {
      pathsList[i].moveTo(origin, size.height);
      pathsList[i].lineTo(origin, size.height * barsHeight[i]);
    }

    origin = origin + size.width * 0.25;

    canvas.drawPath(trackPath, trackPaint);

    for (int i = 0; i < barsColors.length; i++) {
      canvas.drawPath(pathsList[i], paints[i]);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
