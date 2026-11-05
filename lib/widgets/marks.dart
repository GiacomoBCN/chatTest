import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/falak_theme.dart';

/// Trust marks borrowed from banknote printing. They read in
/// monochrome: solid = from the system, hatch = estimate,
/// dots = not yet confirmed. Colour is never the only signal.
enum MarkKind { solid, hatch, dots }

class TrustMark extends StatelessWidget {
  final MarkKind kind;
  final double size;
  final Color? color;

  const TrustMark(this.kind, {super.key, this.size = 22, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? FalakColors.of(context).ink;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _MarkPainter(kind, c)),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  final MarkKind kind;
  final Color color;
  _MarkPainter(this.kind, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    final stroke = math.max(1.2, size.width / 16);
    final ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: r)));
    paintPattern(canvas, Offset.zero & size, kind, color, fine: size.width < 18);
    canvas.restore();
    canvas.drawCircle(center, r - stroke / 2, ring);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.kind != kind || old.color != color;
}

/// Shared by marks and the certainty strip so both read the same.
void paintPattern(Canvas canvas, Rect rect, MarkKind kind, Color color, {bool fine = false}) {
  final p = Paint()..color = color;
  switch (kind) {
    case MarkKind.solid:
      canvas.drawRect(rect, p);
    case MarkKind.hatch:
      p
        ..style = PaintingStyle.stroke
        ..strokeWidth = fine ? 1.1 : 1.4;
      final gap = fine ? 3.4 : 4.2;
      canvas.save();
      canvas.clipRect(rect);
      for (double x = rect.left - rect.height; x < rect.right + rect.height; x += gap) {
        canvas.drawLine(Offset(x, rect.bottom), Offset(x + rect.height, rect.top), p);
      }
      canvas.restore();
    case MarkKind.dots:
      final gap = fine ? 3.6 : 4.5;
      final dot = fine ? 0.85 : 1.05;
      canvas.save();
      canvas.clipRect(rect);
      for (double x = rect.left + gap / 2; x < rect.right; x += gap) {
        for (double y = rect.top + gap / 2; y < rect.bottom; y += gap) {
          canvas.drawCircle(Offset(x, y), dot, p);
        }
      }
      canvas.restore();
  }
}

/// A ringed icon mark, for the person hand-off and the staff role.
class IconMark extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const IconMark(this.icon, {super.key, required this.color, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: math.max(1.2, size / 16)),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: size * 0.62, color: color),
      ),
    );
  }
}
