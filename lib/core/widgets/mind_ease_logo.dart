import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// MindEase Logo displaying the authentic assets/images/logo.png
class MindEaseLogo extends StatelessWidget {
  final double size;
  final bool isMonochromeWhite;
  final bool showText;
  final bool showSubtitle;

  const MindEaseLogo({
    Key? key,
    this.size = 80,
    this.isMonochromeWhite = false,
    this.showText = false,
    this.showSubtitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      isMonochromeWhite ? AppConstants.whiteLogoImage : AppConstants.logoImage,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: isMonochromeWhite ? Colors.white : null,
      errorBuilder: (context, error, stackTrace) => CustomPaint(
        size: Size(size, size),
        painter: _MindEaseLogoPainter(isMonochromeWhite: isMonochromeWhite),
      ),
    );

    if (!showText) {
      return icon;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(height: 14),
        Text(
          'MindEase',
          style: AppTypography.logoText.copyWith(
            fontSize: size * 0.36,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'by Oligal',
            style: AppTypography.logoSubtitle,
          ),
        ],
      ],
    );
  }
}

class _MindEaseLogoPainter extends CustomPainter {
  final bool isMonochromeWhite;

  _MindEaseLogoPainter({required this.isMonochromeWhite});

  static const List<Color> _figureColors = [
    AppColors.logoCoral,
    AppColors.logoGolden,
    AppColors.logoTeal,
    AppColors.logoDarkBlue,
    AppColors.logoPurple,
    AppColors.logoGreen,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const count = 6;
    const angleStep = (2 * math.pi) / count;

    // Head dot radius
    final headRadius = radius * 0.14;
    final headCenterDist = radius * 0.74;

    // Body arc thickness
    final bodyStrokeWidth = radius * 0.16;

    final bodyPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyStrokeWidth
      ..strokeCap = StrokeCap.round;

    final headPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final angle = i * angleStep - (math.pi / 2);
      final color = isMonochromeWhite ? Colors.white : _figureColors[i % _figureColors.length];

      bodyPaint.color = color;
      headPaint.color = color;

      // Draw head dot
      final headX = center.dx + headCenterDist * math.cos(angle);
      final headY = center.dy + headCenterDist * math.sin(angle);
      canvas.drawCircle(Offset(headX, headY), headRadius, headPaint);

      // Draw stylized connecting body/arms arc towards adjacent figure
      final arcRadius = radius * 0.44;
      final startAngle = angle - (angleStep * 0.28);
      const sweepAngle = angleStep * 0.56;

      final rect = Rect.fromCircle(center: center, radius: arcRadius);
      canvas.drawArc(rect, startAngle, sweepAngle, false, bodyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MindEaseLogoPainter oldDelegate) {
    return oldDelegate.isMonochromeWhite != isMonochromeWhite;
  }
}
