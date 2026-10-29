import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Circular Back Button with outline border and no background fill
class CircularBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLightOnDark;

  const CircularBackButton({
    Key? key,
    this.onPressed,
    this.isLightOnDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isLightOnDark
        ? Colors.white.withOpacity(0.7)
        : AppColors.inputBorder;

    final iconColor = isLightOnDark ? Colors.white : AppColors.textPrimary;

    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.0),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 22,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
