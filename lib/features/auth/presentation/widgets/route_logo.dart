import 'package:flutter/material.dart';
import 'package:route_ecommerce/core/utils/context_extention.dart';

/// Vector wordmark for the Route brand displayed on auth screens.
class RouteLogo extends StatelessWidget {
  final double height;
  final Color? color;

  const RouteLogo({super.key, this.height = 72, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.onPrimary;
    return Semantics(
      label: context.locale.appTitle,
      child: CustomPaint(
        size: Size(height * 3.2, height),
        painter: _RouteLogoPainter(color: effectiveColor),
      ),
    );
  }
}

class _RouteLogoPainter extends CustomPainter {
  final Color color;

  const _RouteLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.036
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final h = size.height;
    final w = size.width;

    // Stylized 'R' with step-down left tail
    final rPath = Path()
      ..moveTo(w * 0.04, h * 0.88)
      ..lineTo(w * 0.04, h * 0.72)
      ..lineTo(w * 0.14, h * 0.72)
      ..lineTo(w * 0.14, h * 0.12)
      ..cubicTo(w * 0.30, h * 0.10, w * 0.34, h * 0.56, w * 0.14, h * 0.54)
      ..lineTo(w * 0.26, h * 0.90)
      ..lineTo(w * 0.31, h * 0.76);
    canvas.drawPath(rPath, paint);

    // 'o'
    canvas.drawOval(
      Rect.fromLTWH(w * 0.33, h * 0.42, w * 0.15, h * 0.46),
      paint,
    );

    // 'u'
    final uPath = Path()
      ..moveTo(w * 0.53, h * 0.42)
      ..lineTo(w * 0.53, h * 0.72)
      ..cubicTo(w * 0.53, h * 0.92, w * 0.67, h * 0.92, w * 0.67, h * 0.72)
      ..lineTo(w * 0.67, h * 0.42);
    canvas.drawPath(uPath, paint);

    // 't'
    final tPath = Path()
      ..moveTo(w * 0.73, h * 0.16)
      ..lineTo(w * 0.73, h * 0.74)
      ..cubicTo(w * 0.73, h * 0.89, w * 0.81, h * 0.89, w * 0.84, h * 0.83)
      ..moveTo(w * 0.69, h * 0.42)
      ..lineTo(w * 0.81, h * 0.42);
    canvas.drawPath(tPath, paint);

    // 'e'
    final ePath = Path()
      ..moveTo(w * 0.83, h * 0.65)
      ..lineTo(w * 0.97, h * 0.65)
      ..cubicTo(w * 0.97, h * 0.36, w * 0.83, h * 0.36, w * 0.83, h * 0.65)
      ..cubicTo(w * 0.83, h * 0.92, w * 0.95, h * 0.92, w * 0.97, h * 0.78);
    canvas.drawPath(ePath, paint);
  }

  @override
  bool shouldRepaint(covariant _RouteLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
