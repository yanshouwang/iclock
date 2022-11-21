import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:iclock/utilities.dart';

class MimeticStopwatch extends StatelessWidget {
  final Duration elapsed;
  final Duration duration;
  final Color primaryColor;
  final Color secondaryColor;
  final Color foregroundColor;

  const MimeticStopwatch({
    super.key,
    required this.elapsed,
    required this.duration,
    this.primaryColor = const Color(0xffff0000),
  })  : secondaryColor = const Color(0xffe0e0e0),
        foregroundColor = const Color(0xff000000);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StopwatchPainter(
        elapsed: elapsed,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              heightFactor: 0.16,
              child: FittedBox(
                // child: Text(elapsed.stopwatchText),
                child: Text.rich(
                  TextSpan(
                    text: '${elapsed.minutes}:${elapsed.seconds}',
                    children: [
                      TextSpan(
                        text: '.${elapsed.centiseconds}',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: const FractionalOffset(0.5, 0.62),
            child: FractionallySizedBox(
              heightFactor: 0.05,
              child: FittedBox(
                child: Text(
                  duration.stopwatchText,
                  style: TextStyle(
                    color: foregroundColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StopwatchPainter extends CustomPainter {
  final Duration elapsed;
  final Color primaryColor;
  final Color secondaryColor;

  StopwatchPainter({
    super.repaint,
    required this.elapsed,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = primaryColor;
    final bounds = Offset.zero & size;
    final center = bounds.center;
    // 坐标系转换
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, -1.0);
    // 画刻度
    final diameter = math.min(bounds.width, bounds.height);
    final distance1 = diameter / 2.0;
    final distance2 = distance1 * 0.92;
    const unit = 2 * math.pi / 180.0;
    final sp1 = Offset(0.0, distance1);
    final sp2 = Offset(0.0, distance2);
    canvas.drawLine(sp1, sp2, paint);
    paint.color = secondaryColor;
    for (var i = 1; i < 180; i++) {
      final radians = math.pi / 2.0 - i * unit;
      final x1 = distance1 * math.cos(radians);
      final y1 = distance1 * math.sin(radians);
      final x2 = distance2 * math.cos(radians);
      final y2 = distance2 * math.sin(radians);
      final p1 = Offset(x1, y1);
      final p2 = Offset(x2, y2);
      canvas.drawLine(p1, p2, paint);
    }
    final radians1 =
        math.pi / 2.0 - elapsed.inMilliseconds / (60 * 1000) * 2 * math.pi;
    // 画指针
    final distance3 = distance1 * 0.85;
    final cx = distance3 * math.cos(radians1);
    final cy = distance3 * math.sin(radians1);
    final c = Offset(cx, cy);
    final radius = distance1 * 0.02;
    paint
      ..style = PaintingStyle.fill
      ..color = primaryColor;
    canvas.drawCircle(c, radius, paint);
  }

  @override
  bool shouldRepaint(covariant StopwatchPainter oldDelegate) {
    return oldDelegate.elapsed != elapsed;
  }
}
