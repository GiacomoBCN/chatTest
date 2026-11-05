import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/falak_theme.dart';

/// Falak emblem: an engraved temple front with an orbit passing behind it.
class FalakEmblem extends StatelessWidget {
  final double size;
  const FalakEmblem({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final c = FalakColors.of(context);
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _EmblemPainter(c.ink, c.surface)),
      ),
    );
  }
}

class _EmblemPainter extends CustomPainter {
  final Color ink;
  final Color paper;
  _EmblemPainter(this.ink, this.paper);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 40; // drawn on a 40-unit grid
    canvas.scale(s);
    final line = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1.4;

    // Orbit behind the building.
    canvas.save();
    canvas.translate(20, 21);
    canvas.rotate(-18 * math.pi / 180);
    canvas.drawOval(
      const Rect.fromLTRB(-18, -7.5, 18, 7.5),
      Paint()
        ..color = ink.withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.restore();

    // Pediment, filled with paper so the orbit passes behind it.
    final roof = Path()
      ..moveTo(7, 15)
      ..lineTo(20, 7)
      ..lineTo(33, 15)
      ..close();
    canvas.drawPath(roof, Paint()..color = paper);
    canvas.drawPath(roof, line);
    // Columns, with paper behind them to occlude the orbit.
    canvas.drawRect(const Rect.fromLTRB(10, 16, 30, 29.5), Paint()..color = paper);
    final col = Paint()
      ..color = ink
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (final x in [11.0, 16.3, 23.7, 29.0]) {
      canvas.drawLine(Offset(x, 17), Offset(x, 29), col);
    }
    canvas.drawLine(const Offset(9, 15), const Offset(31, 15), line);
    canvas.drawLine(const Offset(8, 30), const Offset(32, 30), line);
    canvas.drawLine(const Offset(6, 33), const Offset(34, 33), line);
  }

  @override
  bool shouldRepaint(_EmblemPainter old) => old.ink != ink || old.paper != paper;
}

/// Guilloche rosette, the single decorative line work in the product.
class Guilloche extends StatelessWidget {
  final double size;
  const Guilloche({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(painter: _GuillochePainter(FalakColors.of(context).guilloche)),
        ),
      ),
    );
  }
}

class _GuillochePainter extends CustomPainter {
  final Color color;
  _GuillochePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.width / 2;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final big = c * 0.92;
    final small = big * 0.29;
    for (var k = 0; k < 14; k++) {
      final h = big * (0.42 + k * 0.012);
      final ph = k * math.pi / 14;
      final path = Path();
      var first = true;
      for (double t = 0; t <= math.pi * 2 * 7.01; t += 0.025) {
        final x =
            c + (big - small) * math.cos(t + ph) + h * math.cos((big - small) / small * t + ph);
        final y =
            c + (big - small) * math.sin(t + ph) - h * math.sin((big - small) / small * t + ph);
        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(_GuillochePainter old) => old.color != color;
}
