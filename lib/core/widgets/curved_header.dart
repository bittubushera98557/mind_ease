import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../theme/app_colors.dart';
import 'circular_back_button.dart';

/// Top Decorative Ribbon Header for Sign Up and Sign In screens
/// Accurately matches the Figma design with the multi-toned organic ribbon:
/// - Left darker mahogany arc behind the circular back button
/// - Top-right darker mahogany diagonal fold
/// - Vibrant terracotta coral main ribbon body
/// - Organic angled bottom curve (higher on left, sweeping down towards right)
/// - Centered white MindEase logo
/// - Circular back button
class CurvedHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final double height;

  const CurvedHeader({
    Key? key,
    this.onBack,
    this.height = 152.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // The layered ribbon canvas
          Positioned.fill(
            child: CustomPaint(
              painter: _RibbonPainter(),
            ),
          ),

          // Safe area interactive controls
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Circular Back Button at Top-Left
                Positioned(
                  left: 18,
                  top: 10,
                  child: CircularBackButton(
                    isLightOnDark: true,
                    onPressed: onBack,
                  ),
                ),

                // White MindEase Logo centered horizontally
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Image.asset(
                      AppConstants.whiteLogoImage,
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                      color: Colors.white,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppConstants.logoImage,
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                    ),
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

class _RibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Clip canvas to the overall bottom curved silhouette
    final silhouettePath = Path();
    silhouettePath.lineTo(0, size.height * 0.82); // Left edge starts at ~125px

    // Gentle organic wave sweeping down towards the right edge (~146px)
    final controlPoint = Offset(size.width * 0.48, size.height * 0.89);
    final endPoint = Offset(size.width, size.height * 0.96);
    silhouettePath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    silhouettePath.lineTo(size.width, 0);
    silhouettePath.lineTo(0, 0);
    silhouettePath.close();

    canvas.save();
    canvas.clipPath(silhouettePath);

    // 2. Main Ribbon Body (Terracotta Coral)
    final mainPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), mainPaint);

    // 3. Left Darker Mahogany Arc behind the Back Button
    // An organic rounded shape anchored at the left edge
    final leftDarkPaint = Paint()
      ..color = const Color(0xFF9E3424).withOpacity(0.92)
      ..style = PaintingStyle.fill;

    final leftArcPath = Path();
    leftArcPath.moveTo(0, 0);
    leftArcPath.lineTo(0, size.height * 0.82);
    leftArcPath.quadraticBezierTo(
      size.width * 0.28,
      size.height * 0.80,
      size.width * 0.32,
      size.height * 0.46,
    );
    leftArcPath.quadraticBezierTo(
      size.width * 0.26,
      0,
      size.width * 0.12,
      0,
    );
    leftArcPath.close();
    canvas.drawPath(leftArcPath, leftDarkPaint);

    // 4. Top-Right Darker Mahogany Diagonal Fold / Wedge
    final rightDarkPaint = Paint()
      ..color = const Color(0xFF9E3424).withOpacity(0.92)
      ..style = PaintingStyle.fill;

    final rightWedgePath = Path();
    rightWedgePath.moveTo(size.width * 0.68, 0);
    rightWedgePath.lineTo(size.width, size.height * 0.65);
    rightWedgePath.lineTo(size.width, 0);
    rightWedgePath.close();
    canvas.drawPath(rightWedgePath, rightDarkPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
